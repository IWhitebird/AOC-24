const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

fn is_safe(line: std.ArrayList(i32)) !i32 {
    var safe: i32 = 1;
    var last: i32 = -1;
    var inc: i32 = -1;
    for (line.items) |cur| {
        // print("{},", .{cur});
        if (last != -1) {
            if (@abs(last - cur) > 3 or last == cur) {
                safe = 0;
            }
            if (inc == -1) {
                if (last < cur) {
                    inc = 1;
                } else {
                    inc = 0;
                }
            } else if (inc == 1) {
                if (last > cur) {
                    safe = 0;
                    break;
                }
            } else {
                if (last < cur) {
                    safe = 0;
                    break;
                }
            }
        }
        last = cur;
    }
    // print("\n", .{});
    return safe;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    var ans: i32 = 0;
    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        var individuals = std.mem.tokenizeScalar(u8, line, ' ');
        var arr: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
        defer arr.deinit();
        while (individuals.next()) |individual| {
            const cur = try std.fmt.parseInt(i32, individual, 10);
            try arr.append(cur);
        }
        ans += try is_safe(arr);
    }
    print("Part 1: {}\n", .{ans});
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    var ans: i32 = 0;
    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        var individuals = std.mem.tokenizeScalar(u8, line, ' ');
        var arr: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
        defer arr.deinit();
        while (individuals.next()) |individual| {
            const cur = try std.fmt.parseInt(i32, individual, 10);
            try arr.append(cur);
        }
        for (0..arr.items.len) |i| {
            var clone_arr = try arr.clone();
            defer clone_arr.deinit();
            _ = clone_arr.orderedRemove(i);
            if (try is_safe(clone_arr) == 1) {
                ans += 1;
                break;
            }
        }
    }
    print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const file_path = "/home/blade/projects/advent/2024/day2/input.txt";
    const input = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    defer allocator.free(input);

    try part1(allocator, input);
    try part2(allocator, input);
}
