const std = @import("std");

pub fn day3() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;
    
    var arrayList = std.ArrayList(usize).init(allocator);
    try arrayList.appendNTimes(0, 12);

    const content = try std.fs.cwd().readFileAlloc(allocator, "day3.txt", std.math.maxInt(usize));
    var parts = std.mem.split(content, "\n");

    while (parts.next()) |line| {
        var i: usize = 0;
        while (i < 12) : (i += 1) {
            arrayList.items[i] += try std.fmt.parseInt(usize, line[i .. i + 1], 10);
        }
    }

    for (arrayList.items) |value, index| {
        var percentIsOne: f32 = @intToFloat(f32, value) / 1000.0;
        if (percentIsOne > 0.50) {
            arrayList.items[index] = 1;
        } else {
            arrayList.items[index] = 0;
        }
    }

    for (arrayList.items) |value, index| {
        std.debug.print("{}", .{value});
        // gamma: 217
        // epsilon: 3878
    }
}