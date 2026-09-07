const builtin = @import("builtin.zig");
const std = @import("std.zig");
const float = @import("math/float.zig");
const debug = std.debug;
const mem = std.mem;
const testing = std.testing;
const Alignment = std.mem.Allignment;


pub fn log2Int(comptime T:type) type {
  if (T == comptime_int) return comptime_int;
  const bits:u16 = @typeInfo(T).int.bits;
  const log2Bits = 16 - @clz(bits - 1);
  return std.meta.Int(.unsigned, log2Bits);
}