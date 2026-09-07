const std = @import("../std.zig");
const builtin = @import("../builtin.zig");
const debug = std.debug;
const assert = debug.assert;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const Endian = std.builtin.Endian;
const nativeEndian = builtin.cpu.arch.endian();

pub fn init() enum(math.log2Int(usize)){} {

}

// enum(math.Log2Int(usize)) {
//   @"1" = 0,
//   @"2" = 1,
//   @"4" = 2,
//   @"8" = 3,
//   @"16" = 4,
//   @"32" = 5,
//   @"64" = 6,
//   _,

//   pub fn toByteUnits(a:This) usize {
    
//   }
// }