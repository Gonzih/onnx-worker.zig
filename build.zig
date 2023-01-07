const std = @import("std");
const zigcv = @import("lib/zigcv/libs.zig");

inline fn getThisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("onnx-worker", "src/main.zig");

    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addIncludePath("/opt/homebrew/include");

    exe.linkSystemLibrary("libonnxruntime");
    exe.linkSystemLibrary("opencv4");

    zigcv.link(exe);
    zigcv.addAsPackage(exe);

    const nats = @import("lib/nats.zig/build.zig");
    exe.addPackage(nats.pkgs.libressl);
    exe.addPackage(nats.pkgs.nats);

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
