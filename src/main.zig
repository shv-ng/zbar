const std = @import("std");
const spinner = @import("spinner.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Starting spinners \n");
    try stdout.flush();

    try stdout.writeAll("Classic spinners:\n");
    try classicSpinner(io, stdout);

    try stdout.writeAll("Arc spinners:\n");
    try arcSpinner(io, stdout);

    try stdout.writeAll("Arc spinners:\n");
    try arcSpinner(io, stdout);

    try stdout.writeAll("All done🫠!\n");
    try stdout.flush();
}

fn classicSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var classic = spinner.Spinner.init(io, stdout, 200, .classic, "Loading...");

    try classic.start();
    try io.sleep(.fromSeconds(2), .awake);
    try classic.stop();
}

fn arcSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var arc = spinner.Spinner.init(io, stdout, 150, .arc, "Loading...");

    try arc.start();
    try io.sleep(.fromSeconds(2), .awake);
    try arc.stop();
}
