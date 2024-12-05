const std = @import("std");
const print = std.debug.print;
const fs = std.fs;
const Array = std.ArrayList;
const Map = std.AutoHashMap;

var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);

pub fn init(input: []const u8) !struct { Map(i32, Array(i32)), [][]i32 } {
    var l_r = Map(i32, Array(i32)).init(aa.allocator());
    var inputs = Array([]i32).init(aa.allocator());

    var inputIter = std.mem.tokenizeScalar(u8, input, '*');

    const rules = inputIter.next() orelse return error.@"Rules not found";
    const query = inputIter.next() orelse return error.@"Query not found";

    var rulesIter = std.mem.tokenizeScalar(u8, rules, '\n');

    while (rulesIter.next()) |line| {
        var lineIter = std.mem.tokenizeScalar(u8, line, '|');

        const s1 = lineIter.next() orelse return error.@"s1 not found";
        const s2 = lineIter.next() orelse return error.@"s2 not found";

        const num1: i32 = try std.fmt.parseInt(i32, s1, 10);
        const num2: i32 = try std.fmt.parseInt(i32, s2, 10);

        const lr = try l_r.getOrPutValue(num1, Array(i32).init(aa.allocator()));

        try lr.value_ptr.append(num2);
    }

    var inpuIter = std.mem.tokenizeScalar(u8, query, '\n');
    while (inpuIter.next()) |line| {
        var lineIter = std.mem.tokenizeScalar(u8, line, ',');

        var row = Array(i32).init(aa.allocator());
        defer row.deinit();

        while (lineIter.next()) |letter| {
            const num: i32 = try std.fmt.parseInt(i32, letter, 10);
            try row.append(num);
        }

        try inputs.append(try row.toOwnedSlice());
    }

    return .{ l_r, try inputs.toOwnedSlice() };
}

fn mySorter(context: struct { Map(i32, Array(i32)) }, a: i32, b: i32) bool {
    const l_r: Map(i32, Array(i32)) = context.@"0";
    const akey = l_r.getKey(a) orelse -1;

    if (akey != -1) {
        const akey_arr = l_r.get(akey) orelse Array(i32).init(aa.allocator());

        for (akey_arr.items) |val| {
            if (val == b) {
                return true;
            }
        }
    }

    return false;
}

pub fn part1(input: []const u8) !void {
    const result = try init(input);
    const l_r: Map(i32, Array(i32)) = result.@"0";
    const inputs: [][]i32 = result.@"1";

    var ans: i32 = 0;

    for (inputs) |row| {
        const check = std.sort.isSorted(i32, row, .{l_r}, mySorter);
        if (check) {
            ans = ans + row[row.len / 2];
        }
    }

    print("Part 1: {} \n", .{ans});
}

pub fn part2(input: []const u8) !void {
    const result = try init(input);
    const l_r: Map(i32, Array(i32)) = result.@"0";
    const inputs: [][]i32 = result.@"1";

    var ans: i32 = 0;

    for (inputs) |row| {
        const check = std.sort.isSorted(i32, row, .{l_r}, mySorter);
        if (!check) {
            std.mem.sort(i32, row, .{l_r}, mySorter);
            ans = ans + row[row.len / 2];
        }
    }

    print("Part 2: {} \n", .{ans});
}

pub fn main() !void {
    const file_path = "/home/blade/projects/advent/2024/day5/input.txt";
    const input = try std.fs.cwd().readFileAlloc(aa.allocator(), file_path, std.math.maxInt(usize));

    try part1(input);
    try part2(input);
}
