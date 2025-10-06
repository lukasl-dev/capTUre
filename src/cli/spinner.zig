const std = @import("std");
const ansi = @import("./ansi.zig");

pub const Spinner = struct {
    start_ms: i64 = 0,
    running: std.atomic.Value(bool) = std.atomic.Value(bool).init(false),
    thread: ?std.Thread = null,
    label: []const u8 = "",
    color: []const u8 = ansi.cyan,

    pub fn start(self: *Spinner, label: []const u8, color: []const u8) !void {
        self.start_ms = std.time.milliTimestamp();
        self.label = label;
        self.color = color;
        self.running = std.atomic.Value(bool).init(true);
        self.thread = try std.Thread.spawn(.{}, loop, .{self});
    }

    pub fn stop(self: *Spinner) void {
        if (self.thread) |thread| {
            self.running.store(false, .release);
            thread.join();
            self.thread = null;
            const stdout = std.fs.File.stdout();
            stdout.writeAll("\r\x1b[K") catch {};
        }
    }

    pub fn elapsedMillis(self: *Spinner) u64 {
        const delta = std.time.milliTimestamp() - self.start_ms;
        return if (delta > 0) @intCast(delta) else 0;
    }

    fn loop(self: *Spinner) void {
        const frames = [_][]const u8{ ".  ", ".. ", "...", " ..", "  .", " ..", "...", ".. " };
        var frame_idx: usize = 0;
        const stdout = std.fs.File.stdout();

        while (self.running.load(.acquire)) {
            const delta = std.time.milliTimestamp() - self.start_ms;
            const elapsed_ms: u64 = if (delta > 0) @intCast(delta) else 0;
            const total_secs = elapsed_ms / 1000;
            const minutes = total_secs / 60;
            const seconds = total_secs % 60;

            var buf: [160]u8 = undefined;
            const msg = std.fmt.bufPrint(
                &buf,
                "\r{s}{s}{s} {s}{s}{s} {d}:{d:0>2}",
                .{
                    self.color,
                    frames[frame_idx],
                    ansi.reset,
                    ansi.bold,
                    self.label,
                    ansi.reset,
                    minutes,
                    seconds,
                },
            ) catch continue;
            stdout.writeAll(msg) catch {};
            frame_idx = (frame_idx + 1) % frames.len;
            std.Thread.sleep(200 * std.time.ns_per_ms);
        }
    }
};
