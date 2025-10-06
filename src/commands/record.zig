const std = @import("std");
const cli = @import("zig-cli");
const Channel = @import("../university/Channel.zig");
const ansi = @import("../ansi.zig");

var flags = struct {
    channel: []const u8 = "",
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

    if (std.Uri.parse(flags.channel) catch null) |_| {
        try record(arena.allocator(), writer, flags.channel);
    } else if (Channel.find(flags.channel)) |channel| {
        try record(arena.allocator(), writer, channel.url);
    } else {
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

    try writer.flush();
}

fn record(
    arena: std.mem.Allocator,
    stdout: *std.Io.Writer,
    url: []const u8,
) !void {
    const timestamp = std.time.timestamp();
    const filename = try std.fmt.allocPrint(
        arena,
        "capTUre-{d}.ts",
        .{timestamp},
    );

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
        filename,
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
        "-c",
        "copy",
        filename,
    });

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

    const start_ms = std.time.milliTimestamp();

    var spinner_running = std.atomic.Value(bool).init(true);
    const spinner_thread = try std.Thread.spawn(
        .{},
        spinnerLoop,
        .{ start_ms, &spinner_running },
    );
    var spinner_active = true;

    const term = child.wait() catch |err| {
        if (spinner_active) {
            stopSpinner(&spinner_running, spinner_thread);
            spinner_active = false;
        }
        try stdout.print("{s}ffmpeg wait failed: {s}{s}\n", .{
            ansi.red,
            @errorName(err),
            ansi.reset,
        });
        return err;
    };

    if (spinner_active) {
        stopSpinner(&spinner_running, spinner_thread);
        spinner_active = false;
    }

    switch (term) {
        .Exited => |code| {
            if (code == 0) {
                const finished_ms = std.time.milliTimestamp();
                const delta = finished_ms - start_ms;
                const elapsed_ms: u64 = if (delta > 0)
                    @intCast(delta)
                else
                    0;
                const total_secs = elapsed_ms / 1000;
                const minutes = total_secs / 60;
                const seconds = total_secs % 60;
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

fn stopSpinner(running: *std.atomic.Value(bool), thread: std.Thread) void {
    running.store(false, .release);
    thread.join();
}

fn spinnerLoop(start_ms: i64, running: *std.atomic.Value(bool)) void {
    const frames = [_][]const u8{
        ".  ",
        ".. ",
        "...",
        " ..",
        "  .",
        " ..",
        "...",
        ".. ",
    };
    var frame_idx: usize = 0;
    const stdout = std.fs.File.stdout();

    while (running.load(.acquire)) {
        const now_ms = std.time.milliTimestamp();
        const delta = now_ms - start_ms;
        const elapsed_ms: u64 = if (delta > 0)
            @intCast(delta)
        else
            0;
        const total_secs = elapsed_ms / 1000;
        const minutes = total_secs / 60;
        const seconds = total_secs % 60;

        var buf: [128]u8 = undefined;
        const msg = std.fmt.bufPrint(
            &buf,
            "\r{s}{s} Recording… {d}:{d:0>2}{s}",
            .{
                ansi.cyan,
                frames[frame_idx],
                minutes,
                seconds,
                ansi.reset,
            },
        ) catch continue;
        stdout.writeAll(msg) catch {};
        frame_idx = (frame_idx + 1) % frames.len;
        std.Thread.sleep(200 * std.time.ns_per_ms);
    }

    stdout.writeAll("\r                                   \r") catch {};
}
