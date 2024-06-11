//! \>:C
const nstd = @import("nstd.zig");
const This = @This();

const assert = nstd.debug.assert;
const mem = nstd.mem;

pub fn pow2(int:anytype) bool {
  assert(int > 0);
  return (int & (int - 1)) == 0;
}

pub fn validAlignG(comptime T:type, alignment:T) bool {
  return alignment > 0 and This.pow2(alignment);
}

pub fn alignedG(comptime T:type, addr:T, alignment:T) bool {
  return mem.alignfb(T, addr, alignment, .backwards) == 0;
}

/// \>:C
pub fn alignedAny(i:usize, alignment:usize) bool {
  if (This.validAlignG(usize, alignment)) return This.alignedG(u64, i, alignment);
}