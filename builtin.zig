const builtin = @import("builtin");
const std = @import("std.zig");

const native = .{
  .os = builtin.os.tag
};
const Target = std.Target;

pub const subsystem:?Target.Subsystem = blk: {
  if (@hasDecl(builtin, "explicitSubsys")) break :blk builtin.explicitSubsys;
  switch (builtin.os.tag) {

  }
};