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

pub fn day3_part2() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;

    const content = try std.fs.cwd().readFileAlloc(allocator, "day3.txt", std.math.maxInt(usize));
    var numbers = std.mem.split(content, "\n");
    var numbersList = std.ArrayList([]u8).init(allocator);
    
    while (numbers.next()) |number| {
        var numberCopy = try allocator.alloc(u8, number.len);
        std.mem.copy(u8, numberCopy, number);
        try numbersList.append(numberCopy);
    }

    var i: usize = 0;
    while (i < 12) : (i += 1) {
        var zeroCount: usize = 0;
        var oneCount: usize = 0;

        for (numbersList.items) |number| {
            if (number[i] == '1') {
                oneCount += 1;
            } else {
                zeroCount += 1;
            }
        }

        var newNumbersList = std.ArrayList([]u8).init(allocator);
        if (zeroCount == oneCount or oneCount > zeroCount) {
            for (numbersList.items) |value| {
                if (value[i] == '0') {
                    try newNumbersList.append(value);
                }
            }
        } else {
            for (numbersList.items) |value| {
                if (value[i] == '1') {
                    try newNumbersList.append(value);
                }
            }
        }

        for (newNumbersList.items) |item| {
            std.debug.print("{s}\n", .{item});
        }

        std.debug.print("-----------------------\n", .{});
        numbersList = newNumbersList;

        // oxygen: 010010011001
        // c02 scrubber: 111111100110
    }
}