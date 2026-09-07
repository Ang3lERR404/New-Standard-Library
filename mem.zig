const std = @import("std.zig");
const builtin = @import("builtin.zig");
const debug = std.debug;
const assert = debug.assert;
const math = std.math;
const This = @This();
const testing = std.testing;
const Endian = std.builtin.Endian;
const nativeEndian = builtin.cpu.arch.endian();

pub const byteSizeinBits = 8;
pub const Allocator = @import("mem/Allocator.zig");
pub const Alignment = @import("mem/Alignment.zig");