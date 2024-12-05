const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

fn possibleNum(input: *const []const u8, i: *usize, delim: u8) !i32 {
    var ans: i32 = 0;
    while (i.* < input.len) {
        const cur = input.*[i.*];
        if (cur == delim) {
            break;
        }
        if (cur < '0' or cur > '9') {
            return error.OutOfRange;
        }
        const num: i32 = @intCast(cur - '0');
        ans *= 10;
        ans += num;
        i.* += 1;
    }
    return ans;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator; // autofix
    var ans: i32 = 0;
    var i: usize = 0;
    while (i < input.len) {
        if (i >= 3 and std.mem.eql(u8, "mul(", input[i - 3 .. i + 1])) {
            i += 1;
            const num1 = try possibleNum(&input, &i, ',');
            i += 1;
            if (num1 == -1) {
                continue;
            }
            const num2 = try possibleNum(&input, &i, ')');
            i += 1;
            if (num2 == -1) {
                continue;
            }
            ans += num1 * num2;
        }
        i += 1;
    }
    print("Part 1: {}\n", .{ans});
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator; // autofix
    var ans: i32 = 0;
    var i: usize = 0;
    var do: bool = true;
    while (i < input.len) {
        if (i >= 3 and std.mem.eql(u8, "do()", input[i - 3 .. i + 1])) {
            do = true;
        } else if (i >= 6 and std.mem.eql(u8, "don't()", input[i - 6 .. i + 1])) {
            do = false;
        } else if (do and i >= 3 and std.mem.eql(u8, "mul(", input[i - 3 .. i + 1])) {
            i += 1;
            const num1 = try possibleNum(&input, &i, ',');
            i += 1;
            if (num1 == -1) {
                continue;
            }
            const num2 = try possibleNum(&input, &i, ')');
            i += 1;
            if (num2 == -1) {
                continue;
            }
            ans += num1 * num2;
        }
        i += 1;
    }
    print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file_path = "/home/blade/projects/advent/2024/day3/input.txt";

    const input = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    defer allocator.free(input);

    try part1(allocator, input);
    try part2(allocator, input);
}
