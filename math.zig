//! General purpose math functions
//! 
//! Enums:
//! ```zig
//! const MinMax = enum{};
//! ```
//! 
//! Methods:
//! ```zig
//! minmax:*const fn(comptime T:type, mm:MinMax) comptime_int;
//! ```
const std = @import("std");
const nstd = @import("nstd.zig");

const expectAll = nstd.testing.expectAll;

pub const MinMax = enum {
  min,
  max
};

/// Gives the minimum or maximum integer of a given type.
pub fn minmax(comptime T:type, mm:MinMax) comptime_int {
  const info = @typeInfo(T);
  const bitCount = info.Int.bits;
  return switch (mm) {
    .min => {
      if (info.Int.signedness == .unsigned) return 0;
      if (bitCount == 0) return 0;
      return -(1 << (bitCount - 1));
    },
    .max => {
      if (bitCount == 0) return 0;
      return (1 << (bitCount - @intFromBool(info.Int.signedness == .signed)));
    }
  };
}

test minmax {
  const arT = &[_]type{
    u0, u1, u8, u16, u32, u64, u128,
    i0, i1, i8, i16, i32, i64, i128,
  };
  inline for (0..arT.len) |i| {
    const ar = arT[i];
    const g = minmax(ar, .max);
    std.debug.print("Testing minmax({any}, .max), {any}\n", .{ar, g});
    if (i % 2 == 1) std.debug.print("\n", .{});
  }
  inline for (0..arT.len) |i| {
    const ar = arT[i];
    const g = minmax(ar, .min);
    std.debug.print("Testing minmax({any}, .min), {any}\n", .{ar, g});
    if (i % 2 == 1) std.debug.print("\n", .{});
  }
}