const std = @import("std");
const fio = @import("fio.zig");

pub fn fio2str(o: fio.FIOBJ) ?[]const u8 {
    if (o == 0) return null;
    const x: fio.fio_str_info_s = fio.fiobj_obj2cstr(o);
    if (x.data == 0)
        return null; // TODO: should we return an error? Actually, looking at fiobj_obj2cstr, this is unreachable
    return std.mem.span(x.data);
}

pub fn str2fio(s: []const u8) fio.fio_str_info_s {
    return .{
        .data = toCharPtr(s),
        .len = s.len,
        .capa = s.len,
    };
}

pub fn toCharPtr(s: []const u8) [*c]u8 {
    return @intToPtr([*c]u8, @ptrToInt(s.ptr));
}

//
// JSON helpers
//

// 1MB JSON buffer
var jsonbuf: [1024 * 1024]u8 = undefined;
var mutex: std.Thread.Mutex = .{};

/// use default 1MB buffer, mutex-protected
pub fn stringify(
    value: anytype,
    options: std.json.StringifyOptions,
) ?[]const u8 {
    mutex.lock();
    defer mutex.unlock();
    var fba = std.heap.FixedBufferAllocator.init(&jsonbuf);
    var string = std.ArrayList(u8).init(fba.allocator());
    if (std.json.stringify(value, options, string.writer())) {
        return string.items;
    } else |_| { // error
        return null;
    }
}

/// use default 1MB buffer, mutex-protected
pub fn stringifyArrayList(
    comptime T: anytype,
    list: *std.ArrayList(T),
    options: std.json.StringifyOptions,
) !?[]const u8 {
    mutex.lock();
    defer mutex.unlock();
    var fba = std.heap.FixedBufferAllocator.init(&jsonbuf);
    var string = std.ArrayList(u8).init(fba.allocator());
    var writer = string.writer();
    try writer.writeByte('[');
    var first: bool = true;
    for (list.items) |user| {
        if (!first) try writer.writeByte(',');
        first = false;
        try std.json.stringify(user, options, string.writer());
    }
    try writer.writeByte(']');
    return string.items;
}

/// provide your own buf, NOT mutex-protected!
pub fn stringifyBuf(
    buffer: []u8,
    value: anytype,
    options: std.json.StringifyOptions,
) ?[]const u8 {
    var fba = std.heap.FixedBufferAllocator.init(buffer);
    var string = std.ArrayList(u8).init(fba.allocator());
    if (std.json.stringify(value, options, string.writer())) {
        return string.items;
    } else |_| { // error
        return null;
    }
}
