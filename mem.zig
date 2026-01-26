const std = @import("std.zig");
const builtin = @import("builtin");
const debug = std.debug;
const assert = debug.assert;
const math = std.math;
const This = @This();
const testing = std.testing;
const NativeEndian = builtin.cpu.arch.endian();

pub const byteSizeInBits = 8;
pub const Allocator = @import("mem/Allocator.zig");
pub const Alignment = enum(math.log2Int(usize)) {
  
};