const builtin = @import("builtin");
const nstd = @import("nstd.zig");
const Dir = nstd.iteration.direction;
const is = nstd.is;

pub const pageSize = switch(builtin.cpu.arch) {
  .wasm32, .wasm64 => 64*1024,
  .aarch64 => switch(builtin.os.tag) {
    .macos, .ios, .watchos, .tvos, .visionos => 16 * 1024,
    else => 4*1024
  },
  .sparc64 => 8*1024,
  else => 4*1024
};

/// \>:C
pub fn alignfb(comptime T:type, addr:T, alignment:T, dir:Dir) T {
  is.validAlignG(T, alignment);
  return switch (dir) {
    .backwards => {
      return addr & ~(alignment - 1);
    },
    .forwards => {
      return (addr & ~(alignment - 1)) + (alignment - 1);
    }
  };
}