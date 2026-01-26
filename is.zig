const std = @import("std.zig");
const builtin = @import("builtin");
const root = @import("root");
const c = std.c;

const Is = enum {
  windows, darwin
};

pub fn is(i:Is) bool {
  return switch(i) {
    .windows => builtin.os.tag == .windows,
    .darwin => builtin.os.tag.isDarwin(),
    else => false
  };
}