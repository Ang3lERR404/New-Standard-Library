const builtin = @import("builtin");
const std = @import("std.zig");
const root = @import("root");
const math = std.math;
const mem = std.mem;
const io = std.io;
const posix = std.posix;
const fs = std.fs;
const testing = std.testing;
const os = std.os;
const File = fs.File;
const win = os.windows;
const native = .{
  .arch = builtin.cpu.arch,
  .os = builtin.os.tag,
  .endian = builtin.cpu.arch.endian()
};

pub fn fullPanic(comptime panicFn:fn([]const u8, ?usize) noreturn) type {
  return struct {
    pub const call = panicFn;
    pub fn sentinelMismatch(expected:anytype, found:@TypeOf(expected)) noreturn {
      @branchHint(.cold);

    }
  };
}

// pub fn panicExtra(retAddr:?usize, comptime f:[]const u8, args:anytype) noreturn {
//   @branchHint(.cold);
//   const 
// }

pub fn assert(ok:bool) void {
  if (!ok) unreachable;
}