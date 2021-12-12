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

pub fn leastCommonBitAtDigit(allocator: *std.mem.Allocator, numbers: std.ArrayList([]u8), digit: usize) anyerror!std.ArrayList([]u8) {
    var oneAtDigit = std.ArrayList([]u8).init(allocator);
    var zeroAtDigit = std.ArrayList([]u8).init(allocator);

    for (numbers.items) |item| {
        if (item[digit] == 49) {
            try oneAtDigit.append(item);
        } else {
            try zeroAtDigit.append(item);
        }
    }

    if (oneAtDigit.items.len > zeroAtDigit.items.len) {
        oneAtDigit.clearAndFree();
        return zeroAtDigit;
    } else {
        zeroAtDigit.clearAndFree();
        return oneAtDigit;
    }

    return arrayList;
}

pub fn day3_part2() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;
    
    var oxygenList = std.ArrayList([]u8).init(allocator);

    const content = try std.fs.cwd().readFileAlloc(allocator, "day3.txt", std.math.maxInt(usize));
    var numbers = std.mem.split(content, "\n");

    while (numbers.next()) |number| {
        var newNumber = try allocator.alloc(u8, number.len);
        std.mem.copy(u8, newNumber, number);
        try oxygenList.append(newNumber);
    }

    var digit: usize = 0;
    while (oxygenList.items.len > 1) {
        oxygenList = try leastCommonBitAtDigit(allocator, oxygenList, digit);
        digit += 1;
    }

    std.debug.print("{s}", .{oxygenList.items[0]});
    // oxygen: 1176 
    // c02 scrubber: 4076
}