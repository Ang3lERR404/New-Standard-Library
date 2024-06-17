const nstd = @import("nstd.zig");
const debug = nstd.debug;
const mem = nstd.mem;
const math = nstd.math;
const testing = nstd.testing;
const is = nstd.is;
const iteration = nstd.iteration;
const root = @import("root");

pub const aptr:type = *anyopaque;

pub fn Int(comptime signedness:nstd.builtin.Signedness, comptime bitCount:u16) type {
  return @Type(.{
    .Int = .{
      .signedness = signedness,
      .bits = bitCount
    }
  });
}