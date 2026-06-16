const std = @import("std");
const ansi = @import("ansi.zig");

const Io = std.Io;

pub const SpinnerStyle = enum {
    classic,
    arc,
    braille,
    clock,

    pub fn frames(self: SpinnerStyle) []const []const u8 {
        return switch (self) {
            .classic => &.{ "\\", "|", "-", "/" },
            .arc => &.{ "◜", "◠", "◝", "◞", "◡", "◟" },
            .braille => &.{ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            .clock => &.{ "🕛", "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚" },
        };
    }
};

pub const Spinner = struct {
    frames: []const []const u8,
    interval_ms: i64,
    running: std.atomic.Value(bool),
    writer: *Io.Writer,
    message: []const u8,
    io: Io,
    done: []const u8,
    thread: std.Thread,

    pub fn init(io_param: Io, writer: *Io.Writer, interval_ms: i64, style: SpinnerStyle, message: []const u8) Spinner {
        return .{
            .io = io_param,
            .writer = writer,
            .message = message,
            .interval_ms = interval_ms,
            .frames = style.frames(),
            .done = "✓",
            .thread=undefined,
            .running = std.atomic.Value(bool).init(false),
        };
    }

    fn tick(self: *Spinner) !void {
        var idx: usize = 0;
        const len: usize = self.frames.len;

        while (self.running.load(.monotonic)) : (idx += 1) {
            if (idx >= len) {
                idx %= len;
            }

            const frame = self.frames[idx];

            try self.writer.print("{s} {s}", .{ frame, self.message });
            try self.writer.flush();
            try self.io.sleep(.fromMilliseconds(self.interval_ms), .awake);
            try ansi.clearLine(self.writer);
        }
    }

    pub fn start(self: *Spinner) !void {
        self.running = std.atomic.Value(bool).init(true);
        self.thread = try std.Thread.spawn(.{}, Spinner.tick, .{self});
    }

    pub fn stop(self: *Spinner) !void {
        self.running.store(false, .release);
        self.thread.join();

        try self.writer.print("\r{s} {s}", .{ self.done, self.message });
        try self.writer.flush();

        try self.writer.writeAll("\n");
    }
};
