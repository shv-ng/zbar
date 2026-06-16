const std = @import("std");
const spinner = @import("spinner.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Starting spinners \n");
    try stdout.flush();

    try classicSpinner(io, stdout);
    try arcSpinner(io, stdout);
    try brailleSpinner(io, stdout);
    try clockSpinner(io, stdout);

    try stdout.writeAll("All done 🫠!\n");
    try stdout.flush();
}

fn classicSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var classic = spinner.Spinner.init(io, stdout, 150, .classic, "Classic Spinner...");

    try classic.start();
    try io.sleep(.fromSeconds(2), .awake);
    try classic.stop();
}

fn arcSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var arc = spinner.Spinner.init(io, stdout, 150, .arc, "Arc Spinner...");

    try arc.start();
    try io.sleep(.fromSeconds(2), .awake);
    try arc.stop();
}

fn brailleSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var braille = spinner.Spinner.init(io, stdout, 150, .braille, "Braille Spinner...");

    try braille.start();
    try io.sleep(.fromSeconds(2), .awake);
    try braille.stop();
}

fn clockSpinner(io: std.Io, stdout: *std.Io.Writer) !void {
    var clock = spinner.Spinner.init(io, stdout, 150, .clock, "Clock Spinner...");

    try clock.start();
    try io.sleep(.fromSeconds(2), .awake);
    try clock.stop();
}
