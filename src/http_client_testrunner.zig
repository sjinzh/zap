const std = @import("std");

const seconds_between_steps: usize = 3;

pub fn main() !void {
    const a = std.heap.page_allocator;

    // Bearer Single
    var p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Bearer",
        "ABCDEFG",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Bearer",
        "invalid",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    // Bearer Multi
    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Bearer",
        "ABCDEFG",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Bearer",
        "invalid",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    // Basic
    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Basic",
        "QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Basic",
        "invalid",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Basic",
        "QWxsYWRkaW46b3BlbnNlc2FtZQ==",
    }, a);
    _ = try p.spawnAndWait();

    std.time.sleep(seconds_between_steps * std.time.ns_per_s);

    p = std.ChildProcess.init(&.{
        "./zig-out/bin/http_client",
        "http://127.0.0.1:3000/test",
        "Basic",
        "QWxsYWRkaW46b3BlbnNlc2FtZQ==-invalid",
    }, a);
    _ = try p.spawnAndWait();

    // std.time.sleep(seconds_between_steps * std.time.ns_per_s);
}
