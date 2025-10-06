const std = @import("std");
const cli = @import("zig-cli");
const Channel = @import("../university/Channel.zig");
const ansi = @import("../cli/ansi.zig");
const Spinner = @import("../cli/spinner.zig").Spinner;

var flags = struct {
    channel: []const u8 = "",
}{};

pub fn command(r: *cli.AppRunner) !cli.Command {
    return cli.Command{
        .name = "watch",
        .description = .{
            .one_line = "Watch a channel livestream via mpv.",
        },
        .options = try r.allocOptions(&.{
            cli.Option{
                .long_name = "channel",
                .short_alias = 'c',
                .required = true,
                .help = "The channel to watch.",
                .value_name = "name/url",
                .value_ref = r.mkRef(&flags.channel),
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
            return err;
        }
        return err;
    };

    try writer.print("{s}→ Watching from{s} {s}{s}{s}\n", .{
        ansi.green,
        ansi.reset,
        ansi.bold,
        resolved_url,
        ansi.reset,
    });
    try writer.flush();

    const alloc = arena.allocator();

    var args: std.ArrayList([]const u8) = .empty;
    try args.appendSlice(alloc, &.{
        "mpv",
        "--no-terminal",
        "--really-quiet",
        "--referrer=https://tuwel.tuwien.ac.at",
        resolved_url,
    });

    var child = std.process.Child.init(args.items, alloc);
    child.stdin_behavior = .Inherit;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    child.spawn() catch |err| {
        try writer.print("{s}Failed to start mpv: {s}{s}\n", .{
            ansi.red,
            @errorName(err),
            ansi.reset,
        });
        return err;
    };

    var spinner = Spinner{};
    try spinner.start("Watching", ansi.cyan);

    const term = child.wait() catch |err| {
        spinner.stop();
        try writer.print("{s}mpv wait failed: {s}{s}\n", .{
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
                try writer.print("{s}✔ Watching session ended after {d}:{d:0>2}{s}\n", .{
                    ansi.green,
                    minutes,
                    seconds,
                    ansi.reset,
                });
            } else {
                try writer.print("{s}mpv exited with code {d}.{s}\n", .{
                    ansi.red,
                    code,
                    ansi.reset,
                });
            }
        },
        .Signal => |sig| {
            try writer.print("{s}mpv terminated by signal {d}.{s}\n", .{
                ansi.red,
                sig,
                ansi.reset,
            });
        },
        else => {},
    }
}
