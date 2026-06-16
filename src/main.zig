const std = @import("std");
const spinner = @import("spinner.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Starting spinners \n");
    try stdout.flush();

    try Spinner(io, stdout, .wave, "Wave...");
    try Spinner(io, stdout, .train, "Train...");
    try Spinner(io, stdout, .bouncing_ball, "Bouncing Ball...");
    try Spinner(io, stdout, .clock, "Clock...");

    try stdout.writeAll("All done 🫠!\n");
    try stdout.flush();
}

fn Spinner(io: std.Io, stdout: *std.Io.Writer, style: spinner.SpinnerStyle, msg: []const u8) !void {
    var classic = spinner.Spinner.init(io, stdout, 120, style, msg);

    try classic.start();
    try io.sleep(.fromSeconds(2), .awake);
    try classic.stop();
}
