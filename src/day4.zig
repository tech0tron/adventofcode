const std = @import("std");

const ArrayList = std.ArrayList;
const day4Text = @embedFile("../day4.txt");
const day4ExampleText = @embedFile("../day4_example.txt");

const BingoBoard = struct {
    const Self = @This();
    numbers: [5][5]usize,
    filledIn: [5][5]bool,

    pub fn fillInNumber(self: *Self, number: usize) bool {
        var x: usize = 0;
        
        // fill in
        while (x < 5) : (x += 1) {
            var y: usize = 0;
            while (y < 5) : (y += 1) {
                if (self.numbers[x][y] == number) {
                    self.filledIn[x][y] = true;
                }
            }
        }
        
        if (self.won()) {
            return true;
        } else {
            return false;
        }
    }

    pub fn won(self: *Self) bool {
        // horizontal + vertical rows
        var i: usize = 0;
        while (i < 5) : (i += 1) {
            if (self.filledIn[0][i] and self.filledIn[1][i] and self.filledIn[2][i] and self.filledIn[3][i] and self.filledIn[4][i]) {
                return true;
            }

            if (self.filledIn[i][0] and self.filledIn[i][1] and self.filledIn[i][2] and self.filledIn[i][3] and self.filledIn[i][4]) {
                return true;
            }
        }

        // diagonals
        if (self.filledIn[0][0] and self.filledIn[1][1] and self.filledIn[2][2] and self.filledIn[3][3] and self.filledIn[4][4]) {
            return true;
        }

        if (self.filledIn[4][4] and self.filledIn[3][3] and self.filledIn[2][2] and self.filledIn[1][1] and self.filledIn[0][0]) {
            return true;
        }

        return false;
    }

    pub fn sumOfUncheckedNumbers(self: *Self) usize {
        var x: usize = 0;
        var sum: usize = 0;
        // fill in
        while (x < 5) : (x += 1) {
            var y: usize = 0;
            while (y < 5) : (y += 1) {
                if (self.filledIn[x][y] == false) {
                    sum += self.numbers[x][y];
                }
            }
        }
        
        return sum;
    }
};

pub fn parseDrawingOrder(allocator: *std.mem.Allocator, text: []const u8) anyerror!ArrayList(usize) {
    var drawingOrderText = std.mem.tokenize(std.mem.tokenize(text, "\n").next().?, ",");
    var toReturn = ArrayList(usize).init(allocator);

    while (drawingOrderText.next()) |numSlice| {
        const number = try std.fmt.parseInt(usize, numSlice, 10);
        try toReturn.append(number);
    }

    std.debug.print("{any}\n", .{toReturn.items});
    return toReturn;
}

pub fn parseBingoBoards(allocator: *std.mem.Allocator, text: []const u8) anyerror!ArrayList(BingoBoard) {
    var bingoOrderText = std.mem.tokenize(text, "\n");
    var toReturn = ArrayList(BingoBoard).init(allocator);

    _ = bingoOrderText.next();
    var step1 = try std.mem.replaceOwned(u8, allocator, bingoOrderText.rest(), "\n", " ");
    var step2 = std.mem.tokenize(step1, " ");
    var numbersList = ArrayList(usize).init(allocator);

    while (step2.next()) |num| {
        const numf = try std.fmt.parseInt(usize, num, 10);
        try numbersList.append(numf);
    }
    
    var boardInParsing: BingoBoard = .{
        .filledIn = [_][5]bool{ [_]bool{false} ** 5 } ** 5,
        .numbers = [_][5]usize{ [_]usize{0} ** 5 } ** 5,
    };

    var xCount: usize = 0;
    var yCount: usize = 0;
    var boardCount: usize = 0;

    for (numbersList.items) |value| {
        boardInParsing.numbers[xCount][yCount] = value;
        
        xCount += 1;
        if (xCount == 5) {
            xCount = 0;
            yCount += 1;
            if (yCount == 5) {
                yCount = 0;
                try toReturn.append(boardInParsing);
            }
        }
    }

    return toReturn;
}

pub fn loop(allocator: *std.mem.Allocator, drawingOrder: ArrayList(usize), bingoBoards: ArrayList(BingoBoard)) anyerror!usize {
    for (drawingOrder.items) |num| {
        for (bingoBoards.items) |*bingoBoard| {
            if (bingoBoard.fillInNumber(num)) {
                std.debug.print("{any}\n", .{ bingoBoard.filledIn});
                std.debug.print("{any}\n", .{ bingoBoard.numbers});
                return bingoBoard.sumOfUncheckedNumbers() * num;
            }
        }
    }

    return 0;
}

pub fn loop_part2(allocator: *std.mem.Allocator, drawingOrder: ArrayList(usize), bingoBoards: *ArrayList(BingoBoard)) anyerror!usize {
    var currentMax: usize = 0;
    var currentIndex: usize = 0;
    
    for (bingoBoards.items) |*board, index| {
        var numbersDrawn: usize = 0;
        for (drawingOrder.items) |number| {
            if (board.fillInNumber(number)) {
                break;
            } else {
                numbersDrawn += 1;
            }
        }

        if (numbersDrawn > currentMax) {
            currentMax = numbersDrawn;
            currentIndex = index;
        }
    }

    var foundIt: BingoBoard = bingoBoards.items[currentIndex];
    return foundIt.sumOfUncheckedNumbers() * drawingOrder.items[currentMax];
}

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = false
    }){};
    var allocator = &gpa.allocator;

    var drawingOrder: ArrayList(usize) = try parseDrawingOrder(allocator, day4Text);
    var bingoBoards: ArrayList(BingoBoard) = try parseBingoBoards(allocator, day4Text);
    std.debug.print("{}\n", . {loop(allocator, drawingOrder, bingoBoards)});
    std.debug.print("{}\n", .{ loop_part2(allocator, drawingOrder, &bingoBoards)});
}