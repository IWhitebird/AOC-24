const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);

pub fn init(input: []const u8) ![]const []const u8 {
    var letter_matrix = std.ArrayList([]const u8).init(aa.allocator());

    var inputIter = std.mem.tokenizeScalar(u8, input, '\n');

    var line = inputIter.next();
    while (line) |l| : (line = inputIter.next()) {
        try letter_matrix.append(l);
    }

    return try letter_matrix.toOwnedSlice();
}

pub fn part1(input: []const u8) !void {
    var sum: usize = 0;
    const matrix = try init(input);
    for (matrix, 0..) |line, y| {
        var oldx: usize = 0;
        while (std.mem.indexOfScalarPos(u8, line, oldx, 'X')) |x| : (oldx = x + 1) {
            const sx: i32 = @intCast(x);
            const sy: i32 = @intCast(y);

            x_mod: for (0..3) |i| {
                y_mod: for (0..3) |j| {
                    var valid = false;
                    for (1..4) |scale| {
                        const si = @as(i32, @intCast(i)) - 1;
                        const sj = @as(i32, @intCast(j)) - 1;
                        const sscale: i32 = @intCast(scale);

                        const newx = sx + si * sscale;
                        const newy = sy + sj * sscale;

                        // print(" i = {}, j = {}, scale = {}, oldx = {},oldy = {},newx = {}, newy = {} \n", .{ i, j, scale, sx, sy, newx, newy });

                        if (newx < 0 or newx >= line.len) continue :x_mod;
                        if (newy < 0 or newy >= matrix.len) continue :y_mod;

                        switch (scale) {
                            1 => {
                                if (matrix[@intCast(newy)][@intCast(newx)] != 'M')
                                    continue :y_mod;
                            },
                            2 => {
                                if (matrix[@intCast(newy)][@intCast(newx)] != 'A')
                                    continue :y_mod;
                            },
                            3 => {
                                if (matrix[@intCast(newy)][@intCast(newx)] != 'S') {
                                    continue :y_mod;
                                } else {
                                    valid = true;
                                }
                            },
                            else => unreachable,
                        }
                    }
                    if (valid) {
                        sum += 1;
                    }
                }
            }
        }
    }
    print("Part 1: {}\n", .{sum});
}

pub fn part2(input: []const u8) !void {
    var sum: usize = 0;
    const matrix = try init(input);
    for (matrix, 0..) |line, y| {
        var oldx: usize = 0;
        while (std.mem.indexOfScalarPos(u8, line, oldx, 'A')) |x| : (oldx = x + 1) {
            if (x < 1 or x >= line.len - 1) continue;
            if (y < 1 or y >= matrix.len - 1) continue;

            const left_up = matrix[y - 1][x - 1];
            const left_dn = matrix[y + 1][x - 1];
            const right_up = matrix[y - 1][x + 1];
            const right_dn = matrix[y + 1][x + 1];

            if ((left_up == 'M' and left_dn == 'M' and right_up == 'S' and right_dn == 'S') or
                (left_up == 'M' and left_dn == 'S' and right_up == 'M' and right_dn == 'S') or
                (left_up == 'S' and left_dn == 'S' and right_up == 'M' and right_dn == 'M') or
                (left_up == 'S' and left_dn == 'M' and right_up == 'S' and right_dn == 'M'))
                sum += 1;
        }
    }
    print("Part 2: {}\n", .{sum});
}

pub fn main() !void {
    const file_path = "/home/blade/projects/advent/2024/day4/input.txt";
    const input = try std.fs.cwd().readFileAlloc(aa.allocator(), file_path, std.math.maxInt(usize));

    try part1(input);
    try part2(input);
}
