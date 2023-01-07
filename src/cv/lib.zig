const std = @import("std");
const cv = @import("zigcv");

pub fn readImage(path: []const u8) !void {
    std.debug.print("Reading {s}\n", .{path});
    // const im = cv.ImRead(path, cv.ImReadFlag.color);
    // std.debug.print("Reading {any}", .{im});
    return;
}
