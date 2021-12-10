pub fn day2() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;
    
    var arrayList = std.ArrayList(u32).init(allocator);

    const content = try std.fs.cwd().readFileAlloc(allocator, "day2.txt", std.math.maxInt(usize));

    var parts = std.mem.split(content, "\n");
    var hPos: usize = 0;
    var vPos: usize = 0;
    while (parts.next()) |line| {
        const val = try std.fmt.parseInt(usize, line[line.len - 1 .. line.len], 10);
        const dir = line[0 .. line.len - 2];
        
        if (std.mem.eql(u8, dir, "forward")) {
            hPos += val;
        } else if (std.mem.eql(u8, dir, "up")) {
            vPos -= val;
        } else if (std.mem.eql(u8, dir, "down")) {
            vPos += val;
        }
    }

    std.log.info("{}", .{ hPos * vPos });
}

pub fn day2_part2() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator;
    
    var arrayList = std.ArrayList(u32).init(allocator);

    const content = try std.fs.cwd().readFileAlloc(allocator, "day2.txt", std.math.maxInt(usize));

    var parts = std.mem.split(content, "\n");
    var hPos: usize = 0;
    var depth: usize = 0;
    var aim: usize = 0;
    while (parts.next()) |line| {
        const val = try std.fmt.parseInt(usize, line[line.len - 1 .. line.len], 10);
        const dir = line[0 .. line.len - 2];
        
        if (std.mem.eql(u8, dir, "forward")) {
            hPos += val;
            depth += (val * aim);
        } else if (std.mem.eql(u8, dir, "up")) {
            aim -= val;
        } else if (std.mem.eql(u8, dir, "down")) {
            aim += val;
        }
    }

    std.log.info("{}", .{ hPos * depth });
}