const std = @import("std");
const Allocator = std.mem.Allocator;

fn lessThan(context: void, lhs: i64, rhs: i64) bool {
    _ = context;
    return lhs < rhs;
}

fn part1(allocator: Allocator, input: []const u8) !void {
    var list1: std.ArrayList(i64) = std.ArrayList(i64).init(allocator);
    defer list1.deinit();
    var list2: std.ArrayList(i64) = std.ArrayList(i64).init(allocator);
    defer list2.deinit();

    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        const a_slice = std.mem.sliceTo(line, ' ');
        const a = try std.fmt.parseInt(i64, a_slice, 10);
        try list1.append(a);

        const b_slice = line[a_slice.len + 3 ..];
        const b = try std.fmt.parseInt(i64, b_slice, 10);
        try list2.append(b);
    }

    std.sort.pdq(i64, list1.items, {}, lessThan);
    std.sort.pdq(i64, list2.items, {}, lessThan);

    var tally: usize = 0;
    for (list1.items, 0..) |a, i| {
        tally += @abs(a - list2.items[i]);
    }
    std.debug.print("Part 1: {}\n", .{tally});
}

fn part2(allocator: Allocator, input: []const u8) !void {
    var list1: std.ArrayList(i64) = .init(allocator);
    defer list1.deinit();
    var list2: std.AutoArrayHashMap(i64, isize) = .init(allocator);
    defer list2.deinit();

    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        const a_slice = std.mem.sliceTo(line, ' ');
        const a = try std.fmt.parseInt(i64, a_slice, 10);
        try list1.append(a);

        const b_slice = line[a_slice.len + 3 ..];
        const b = try std.fmt.parseInt(i64, b_slice, 10);
        const gop = try list2.getOrPut(b);
        if (gop.found_existing) {
            gop.value_ptr.* += 1;
        } else {
            gop.value_ptr.* = 1;
        }
    }

    var tally: usize = 0;
    for (list1.items) |a| {
        tally += @abs(a * (list2.get(a) orelse 0));
    }
    std.debug.print("Part 2: {}\n", .{tally});
}

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try std.fs.cwd().readFileAlloc(allocator, "/home/blade/projects/advent/2024/day1/input.txt", std.math.maxInt(usize));
    defer allocator.free(input);

    try part1(allocator, input);
}
