const builtin = @import("builtin");
const nstd = @import("nstd.zig");
const Dir = nstd.iteration.direction;
const is = nstd.is;
const Types = nstd.builtin.Type;

pub const Allocator = @import("memory/Allocator.zig");

pub const pageSize = switch(builtin.cpu.arch) {
  .wasm32, .wasm64 => 64*1024,
  .aarch64 => switch(builtin.os.tag) {
    .macos, .ios, .watchos, .tvos, .visionos => 16 * 1024,
    else => 4*1024
  },
  .sparc64 => 8*1024,
  else => 4*1024
};

pub fn CopyPAttribs(comptime source:type, comptime size:Types.Pointer.Size, comptime child:type) type {
  const info = @typeInfo(source).Pointer;
  return @Type(.{
    .Pointer = .{
      .size = size,
      .is_const = info.is_const,
      .is_volatile = info.is_volatile,
      .is_allowzero = info.is_allowzero,
      .alignment = info.alignment,
      .address_space = info.address_space,
      .child = child,
      .sentinel = null
    }
  });
}

/// \>:C\
/// nope\
/// nuh-uhh\
/// I see you\
/// that's disgusting-
pub fn alignfb(comptime T:type, addr:T, alignment:T, dir:Dir) T {
  is.validAlignG(T, alignment);
  return switch (dir) {
    .backwards => addr & ~(alignment - 1),
    .forwards => (addr & ~(alignment - 1)) + (alignment - 1)
  };
}

