const std = @import("std");

const Io = std.Io;

pub const SpinnerStyle = enum {
    classic,
    arc,

    pub fn frames(self: SpinnerStyle) []const []const u8 {
        return switch (self) {
            .classic => &.{ "\\", "|", "-", "/" },
            .arc => &.{ "◜", "◠", "◝", "◞", "◡", "◟" },
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

    pub fn init(io_param: Io, writer: *Io.Writer, interval_ms: i64, style: SpinnerStyle, message: []const u8) Spinner {
        return .{
            .io = io_param,
            .writer = writer,
            .message = message,
            .interval_ms = interval_ms,
            .frames = style.frames(),
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

            try self.writer.print("\r{s} {s}", .{ frame, self.message });
            try self.writer.flush();

            try self.io.sleep(.fromMilliseconds(self.interval_ms), .awake);
        }
    }

    pub fn start(self: *Spinner) !void {
        self.running = std.atomic.Value(bool).init(true);
        _ = try std.Thread.spawn(.{}, Spinner.tick, .{self});
    }

    pub fn stop(self: *Spinner) !void {
        self.running.store(false, .release);
        try self.writer.writeAll("\n");
    }
};
