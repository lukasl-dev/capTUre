const std = @import("std");
const cli = @import("zig-cli");
const Channel = @import("../university/Channel.zig");
const ansi = @import("../ansi.zig");

var flags = struct {
    show_urls: bool = false,
    show_aliases: bool = true,
}{};

pub fn command(r: *cli.AppRunner) !cli.Command {
    return cli.Command{
        .name = "channels",
        .description = .{
            .one_line = "List common channels that are known to capTUre.",
        },
        .options = try r.allocOptions(&.{
            cli.Option{
                .long_name = "show-urls",
                .short_alias = 'u',
                .required = false,
                .help = "Whether to show the channel urls.",
                .value_name = "bool",
                .value_ref = r.mkRef(&flags.show_urls),
            },
            cli.Option{
                .long_name = "show-aliases",
                .short_alias = 'a',
                .required = false,
                .help = "Whether to display known aliases.",
                .value_name = "bool",
                .value_ref = r.mkRef(&flags.show_aliases),
            },
        }),
        .target = cli.CommandTarget{
            .action = cli.CommandAction{ .exec = run },
        },
    };
}

fn run() !void {
    const stdout = std.fs.File.stdout();
    var stdout_buf: [1024]u8 = undefined;
    var stdout_writer = stdout.writer(&stdout_buf);
    var writer = &stdout_writer.interface;

    try writer.print("{s}The following (common) channels are available:{s}\n\n", .{
        ansi.cyan,
        ansi.reset,
    });
    if (!flags.show_urls) {
        try writer.print("{s}(use --show-urls to include livestream links){s}\n\n", .{
            ansi.dim,
            ansi.reset,
        });
    }
    inline for (Channel.common) |channel| {
        if (flags.show_urls) {
            try writer.print("  {s}>{s} {s}{s}{s}\n", .{
                ansi.green,
                ansi.reset,
                ansi.bold,
                channel.name,
                ansi.reset,
            });
        } else {
            try writer.print("  {s}>{s} {s}{s}{s}\n", .{
                ansi.green,
                ansi.reset,
                ansi.bold,
                channel.name,
                ansi.reset,
            });
        }

        if (flags.show_aliases) {
            if (channel.aliases.len > 0) {
                try writer.print("    {s}", .{ansi.dim});
                for (channel.aliases, 0..) |alias, alias_idx| {
                    if (alias_idx != 0) {
                        try writer.print(", ", .{});
                    }
                    try writer.print("{s}", .{alias});
                }
                try writer.print("{s}\n", .{ansi.reset});
            } else {
                try writer.print("\n", .{});
            }
        }
        if (flags.show_urls) {
            try writer.print("    {s}{s}{s}\n", .{
                ansi.blue,
                channel.url,
                ansi.reset,
            });
        }
    }
    try writer.print("\n", .{});
}
