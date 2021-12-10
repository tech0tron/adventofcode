pub fn day1() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;
    
    var arrayList = std.ArrayList(u32).init(allocator);

    const content = try std.fs.cwd().readFileAlloc(allocator, "day1.txt", std.math.maxInt(usize));

    var parts = std.mem.split(content, "\n");
    while (parts.next()) |line| {
        const n = try std.fmt.parseInt(u32, line, 10);
        try arrayList.append(n);
    }

    var i: usize = 0;
    var times: usize = 0;

    while (i < arrayList.items.len - 3) : (i += 1) {
        var sum1: usize = arrayList.items[i] + arrayList.items[i + 1] + arrayList.items[i + 2];
        var sum2: usize = arrayList.items[i + 1] + arrayList.items[i + 2] + arrayList.items[i + 3];
        if (sum1 < sum2) {
            times += 1;
        }
    }

    std.log.info("{}", .{ times });
}