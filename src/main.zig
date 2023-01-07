const std = @import("std");
const cv = @import("cv/lib.zig");
const ort = @import("onnxruntime_c_api.zig");

fn logStatus(s: ?*ort.OrtStatus) void {
    if (s != null) {
        std.debug.print("Error: {*}\n", .{s});
    }
}

pub fn main() !void {
    std.debug.print("RT {}", .{ort});

    const apibase = ort.OrtGetApiBase().?.*;
    const api = (apibase.GetApi.?)(ort.ORT_API_VERSION).?.*;
    std.debug.print("api {}\n", .{true});

    var env: ?*ort.OrtEnv = undefined;
    const envStatus = (api.CreateEnv.?)(ort.ORT_LOGGING_LEVEL_WARNING, "test", &env);
    logStatus(envStatus);
    std.debug.print("env {*}\n", .{env});

    const model = "assets/resnet50v2.onnx";
    var session: ?*ort.OrtSession = undefined;
    const sessStatus = (api.CreateSession.?)(env, model, null, &session);
    logStatus(sessStatus);
    std.debug.print("sess {*}\n", .{session});

    const allocator = std.heap.page_allocator;
    const im = try cv.readImage(allocator, "assets/dog.png", 224, 224);
    std.debug.print("IM {any}\n", .{im});
}

test "simple test" {
    try std.testing.expectEqual(1, 2);
}
