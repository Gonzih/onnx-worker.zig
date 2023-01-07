const std = @import("std");
const cv = @import("zigcv");

pub fn readImage(path: []const u8) !void {
    std.debug.print("Reading {s}\n", .{path});
    const im = cv.imRead(path, .color);
    std.debug.print("Reading {any}\n", .{im});
    return;
}
