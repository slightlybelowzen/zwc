const std = @import("std");

const Config = struct { show_lines: bool = false, show_words: bool = false, show_bytes: bool = false, show_chars: bool = false, filename: ?[]u8 };

const ArgParseError = error{ MissingArgument, InvalidNumber, UnknownArgument, PrintHelp };
const UsageDesc = "usage: zwc [-clmw] [file ...]";

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args_iterator = try std.process.ArgIterator.initWithAllocator(allocator);
    const config: Config = Config{ .filename = undefined, .show_lines = true, .show_words = true, .show_chars = true };
    _ = args_iterator.skip();
    const next = args_iterator.next() orelse "";

    if (!std.mem.startsWith(u8, "-", next)) {
        std.debug.print("flag passed: {s}\n", .{next});
        // std.debug.print("{s}\n", .{UsageDesc});
        return error.UnknownArgument;
    }
    try stdout.print("config: {?}\n", .{config});
    defer args_iterator.deinit();
    try bw.flush();
}
