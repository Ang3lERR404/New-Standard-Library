const std = @import("std.zig");
const builtin = @import("builtin");
const assert = std.debug.assert;
const math = std.math;

pub var randomSeed:u32 = 0;

pub const FailingAllocator = @import("testing/FailingAllocator.zig");
pub const fAllocat = fAllocatInstance.allocate();
var fAllocatInstance = FailingAllocator.init(bAllocatInstance.allocator(), .{
  .failIdx = 0
});