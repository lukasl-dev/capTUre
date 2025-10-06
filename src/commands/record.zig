const std = @import("std");
const cli = @import("zig-cli");
const Channel = @import("../university/Channel.zig");
const ansi = @import("../cli/ansi.zig");
const Spinner = @import("../cli/spinner.zig").Spinner;

var flags = struct {
    channel: []const u8 = "",
    output_file: ?[]const u8 = null,
    format: ?[]const u8 = null,
    ffmpeg_opts: []const []const u8 = &.{},
}{};

pub fn command(r: *cli.AppRunner) !cli.Command {
    return cli.Command{
        .name = "record",
        .description = .{
            .one_line = "Record a channel.",
        },
        .options = try r.allocOptions(&.{
            cli.Option{
                .long_name = "channel",
                .short_alias = 'c',
                .required = true,
                .help = "The channel to record.",
                .value_name = "name/url",
                .value_ref = r.mkRef(&flags.channel),
            },
            cli.Option{
                .long_name = "output-file",
                .short_alias = 'o',
                .required = false,
                .help = "File to write the recording to (default: capTUre-<timestamp>.ts).",
                .value_name = "path",
                .value_ref = r.mkRef(&flags.output_file),
            },
            cli.Option{
                .long_name = "format",
                .short_alias = 'f',
                .required = false,
                .help = "Container format to mux into (passed to ffmpeg -f).",
                .value_name = "name",
                .value_ref = r.mkRef(&flags.format),
            },
            cli.Option{
                .long_name = "ffmpeg-opts",
                .short_alias = 'F',
                .required = false,
                .help = "Additional ffmpeg options (repeatable).",
                .value_name = "opt",
                .value_ref = r.mkRef(&flags.ffmpeg_opts),
            },
        }),
        .target = cli.CommandTarget{
            .action = cli.CommandAction{ .exec = run },
        },
    };
}

fn run() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const stdout = std.fs.File.stdout();
    var stdout_buf: [1024]u8 = undefined;
    var stdout_writer = stdout.writer(&stdout_buf);
    var writer = &stdout_writer.interface;

    if (flags.channel.len == 0) {
        try writer.print("{s}Please specify a channel (url or name).{s}\n", .{
            ansi.red,
            ansi.reset,
        });
        return error.NoChannel;
    }

    const resolved_url = Channel.resolve(flags.channel) catch |err| {
        if (err == Channel.ResolveError.UnknownChannel) {
            try writer.print("{s}Channel{s} {s}'{s}'{s} {s}is neither a known channel nor a valid URI.{s}\n", .{
                ansi.red,
                ansi.reset,
                ansi.bold,
                flags.channel,
                ansi.reset,
                ansi.red,
                ansi.reset,
            });
            try writer.print("{s}Run{s} capTUre channels {s}to see the list of known channels.{s}\n", .{
                ansi.dim,
                ansi.reset,
                ansi.dim,
                ansi.reset,
            });
        }
        return err;
    };

    try record(arena.allocator(), writer, resolved_url);
}

fn record(
    arena: std.mem.Allocator,
    stdout: *std.Io.Writer,
    url: []const u8,
) !void {
    const timestamp = std.time.timestamp();
    const base_filename = try std.fmt.allocPrint(
        arena,
        "capTUre-{d}.ts",
        .{timestamp},
    );

    const output_path = blk: {
        if (flags.output_file) |file| {
            const trimmed = std.mem.trim(u8, file, " \t\r\n");
            if (trimmed.len == 0) break :blk base_filename;
            break :blk trimmed;
        }

        break :blk base_filename;
    };

    try stdout.print("{s}→ Recording from{s} {s}{s}{s}\n", .{
        ansi.green,
        ansi.reset,
        ansi.bold,
        url,
        ansi.reset,
    });
    try stdout.print("{s}→ Output file:{s} {s}{s}{s}\n", .{
        ansi.green,
        ansi.reset,
        ansi.bold,
        output_path,
        ansi.reset,
    });
    try stdout.flush();

    var args: std.ArrayList([]const u8) = .empty;
    try args.appendSlice(arena, &.{
        "ffmpeg",
        "-hide_banner",
        "-loglevel",
        "warning",
        "-headers",
        "Referer: https://tuwel.tuwien.ac.at\r\n",
        "-i",
        url,
    });
    if (flags.format) |fmt| {
        try args.appendSlice(arena, &.{ "-f", fmt });
    }
    try args.appendSlice(arena, &.{ "-c", "copy" });
    for (flags.ffmpeg_opts) |opt| {
        try args.append(arena, opt);
    }
    try args.append(arena, output_path);

    var child = std.process.Child.init(args.items, arena);
    child.stdin_behavior = .Inherit;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    child.spawn() catch |err| {
        try stdout.print("{s}Failed to start ffmpeg: {s}{s}\n", .{
            ansi.red,
            @errorName(err),
            ansi.reset,
        });
        return err;
    };

    var spinner = Spinner{};
    try spinner.start("Recording", ansi.cyan);

    const term = child.wait() catch |err| {
        spinner.stop();
        try stdout.print("{s}ffmpeg wait failed: {s}{s}\n", .{
            ansi.red,
            @errorName(err),
            ansi.reset,
        });
        return err;
    };

    spinner.stop();
    const elapsed_ms = spinner.elapsedMillis();
    const total_secs = elapsed_ms / 1000;
    const minutes = total_secs / 60;
    const seconds = total_secs % 60;

    switch (term) {
        .Exited => |code| {
            if (code == 0) {
                try stdout.print("{s}✔ Recording finished after {d}:{d:0>2}{s}\n", .{
                    ansi.green,
                    minutes,
                    seconds,
                    ansi.reset,
                });
            } else {
                try stdout.print("{s}ffmpeg exited with code {d}.{s}\n", .{
                    ansi.red,
                    code,
                    ansi.reset,
                });
            }
        },
        .Signal => |sig| {
            try stdout.print("{s}ffmpeg terminated by signal {d}.{s}\n", .{
                ansi.red,
                sig,
                ansi.reset,
            });
        },
        else => {},
    }
}
