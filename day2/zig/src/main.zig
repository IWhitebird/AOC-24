//! https://adventofcode.com/2024/day/2

const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try std.fs.cwd().readFileAlloc(allocator, "/home/blade/projects/advent/2024/day2/input.txt", std.math.maxInt(usize));
    defer allocator.free(input);

    var safe: usize = 0;
    var safe_dampened: usize = 0;

    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        if (line.len == 0) break;

        var base_nums: std.ArrayList(u32) = std.ArrayList(u32).init(allocator);
        defer base_nums.deinit();
        var nums: std.ArrayList(u32) = std.ArrayList(u32).init(allocator);
        defer nums.deinit();

        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |num_slice| {
            try base_nums.append(try std.fmt.parseInt(u32, num_slice, 10));
        }

        try nums.ensureTotalCapacity(base_nums.items.len);

        var dampened: i32 = -1;
        while (dampened < base_nums.items.len) : ({
            dampened += 1;
            nums.clearRetainingCapacity();
        }) {
            for (0.., base_nums.items) |j, num| {
                if (j == dampened) continue;
                nums.appendAssumeCapacity(num);
            }

            std.debug.assert(nums.items.len > 1);
            const increasing = nums.items[0] < nums.items[1];

            var i: u32 = 0;
            while (i < nums.items.len - 1) : (i += 1) {
                const diff = @as(i32, @intCast(nums.items[i + 1])) - @as(i32, @intCast(nums.items[i]));
                if (increasing and diff >= 1 and diff <= 3) continue;
                if (!increasing and diff >= -3 and diff <= -1) continue;
                break;
            } else {
                if (dampened == -1) safe += 1;
                safe_dampened += 1;
                break;
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{safe});
    std.debug.print("Part 2: {}\n", .{safe_dampened});
}
