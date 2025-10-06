const std = @import("std");
const capTUre = @import("capTUre");

const cli = @import("zig-cli");

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    var r = try cli.AppRunner.init(alloc);
    const app = cli.App{
        .command = cli.Command{
            .name = "capTUre",
            .description = .{
                .one_line = "Capture lectures from Technical University (TU) of Vienna",
                .detailed = "https://github.com/lukasl-dev/capTUre",
            },
            .target = cli.CommandTarget{
                .subcommands = try r.allocCommands(&.{}),
            },
        },
    };
    try r.run(&app);
}
