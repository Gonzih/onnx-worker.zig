const std = @import("std");
const cv = @import("zigcv");

const CVError = error{NoImage};

pub fn readImage(allocator: std.mem.Allocator, path: []const u8, width: i32, height: i32) ![]f32 {
    std.debug.print("Reading {s}\n", .{path});
    var im = try cv.imRead(path, .color);
    defer im.deinit();

    // if (im == null) {
    //     return CVError.NoImage;
    // }

    cv.cvtColor(im, &im, .bgr_to_rgb);
    cv.resize(im, &im, cv.Size{ .width = width, .height = height }, 0, 0, cv.InterpolationFlag{});
    im = try im.reshape(1, 1);

    const bufSize: usize = @intCast(usize, im.total());

    // create new empty target mat
    const toType: cv.Mat.MatType = cv.Mat.MatType.cv32fc1;
    var to = try cv.Mat.initSize(width, height, toType);
    im.convertToWithParams(&to, toType, 1.0 / 255.0, 0.0);

    // convert to mat into array of f32
    var arr = try allocator.alloc(f32, bufSize);
    to.copyTo(&arr[0..bufSize]);

    // Transpose (height, width, channels) -> (channels, height, width)
    var output = try allocator.alloc(f32, bufSize);

    var i: usize = 0;
    while (i < bufSize) : (i += 3) {
        output[i] = arr[i + 2];
        output[i + 1] = arr[i + 1];
        output[i + 2] = arr[i];
    }

    return output;
}
