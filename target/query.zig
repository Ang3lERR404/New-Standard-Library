const This = @This();
const std = @import("../std.zig");
const builtin = @import("../builtin.zig");
const debug = std.debug;
const Target = std.Target;
const mem = std.mem;
const Allocat = mem.Allocator;
const ArrayList = std.ArrayList;

cpu:Cpu,
pub const Cpu = struct {
  arch:?Target.Cpu.Arch = null,
  model:CpuModel = .determinedByArchOS,
  featuresAdd:Target.Cpu.Feature.Set = .empty,
  featuresSub:Target.Cpu.Feature.Set = .empty,
};