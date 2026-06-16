const std = @import("std");
const Io = std.Io;

pub fn clearLine(w: *Io.Writer) !void {
    try w.writeAll("\r\x1b[K");
}
