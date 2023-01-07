const std = @import("std");

inline fn getThisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("hello-wordl", "src/main.zig");

    exe.setTarget(target);
    exe.setBuildMode(mode);
    // exe.addIncludePath("/opt/homebrew/Cellar/onnxruntime/1.13.1/include");
    exe.addIncludePath("/opt/homebrew/include");
    exe.addIncludePath("libs/zigcv/libs/gocv");

    // exe.addLibraryPath("/opt/homebrew/Cellar/onnxruntime/1.13.1/lib");
    exe.linkSystemLibrary("libonnxruntime");
    exe.linkSystemLibrary("opencv4");
    // exe.linkSystemLibrary("stdc++.dll");
    // exe.linkSystemLibrary("unwind");
    // exe.linkSystemLibrary("m");
    // exe.linkSystemLibrary("c");

    exe.addPackage(.{ .name = "zigcv", .source = .{ .path = "libs/zigcv/src/main.zig" } });
    // @import("libs/zigcv/build.zig").build(b);

    exe.install();

    // std.debug.print("DIRS: \n", .{});
    // for (exe.include_dirs.items) |path| {
    //     std.debug.print("{s}\n", .{path.raw_path});
    // }

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
