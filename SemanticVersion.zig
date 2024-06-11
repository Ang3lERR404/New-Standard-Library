const nstd = @import("nstd.zig");
const This = @This();
const stron:type = ?[]const u8;

major:usize,
minor:usize,
patch:usize,
pre:?stron = null,
build:?stron = null,