const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

pub fn main() !void {
    const gpa = std.heap.page_allocator;

    // Open the file
    const cwd = fs.cwd();
    var file = try cwd.openFile("input.txt", .{ .mode = .read_only });
    defer file.close();

    // Use a buffered reader
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    // Vectors to store parsed values
    var v1 = std.ArrayList(i32).init(gpa);
    var v2 = std.ArrayList(i32).init(gpa);
    defer v1.deinit();
    defer v2.deinit();

    // Read lines from the file
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var tokenizer = std.mem.tokenize([]u8, line, " ");
        var parsed: [2]?i32 = .{ null, null };
        var idx: usize = 0;

        while (tokenizer.next()) |token| {
            if (idx >= 2) break;
            parsed[idx] = std.fmt.parseInt(i32, token, 10) catch |err| {
                std.log.err("Error parsing token: {s}", .{std.fmt.formatError(err)});
                return;
            };
            idx += 1;
        }

        if (parsed[0] != null and parsed[1] != null) {
            try v1.append(parsed[0].?);
            try v2.append(parsed[1].?);
        }
    }

    // Sort both vectors
    std.mem.sort(i32, v1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, v2.items, {}, std.sort.asc(i32));

    // Calculate the result
    var ans1: i32 = 0;
    for (0..v1.items.len) |i| {
        ans1 += @abs(v1.items[i] - v2.items[i]);
    }

    // Print the result
    print("Ans for part 1 -> {d}\n", .{ans1});
}
