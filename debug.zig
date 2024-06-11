const nstd = @import("nstd.zig");
const builtin = @import("builtin");

pub fn assert(ok:bool) void {
  if (!ok) unreachable;
}