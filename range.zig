const std = @import("std.zig");
const builtin = @import("builtin.zig");
const This = @This();
const debug = std.debug;
const assert = debug.assert;

T:type,
ptr:*anyopaque,
vtab:VTab,

pub const VTab = struct {
  min:This.T,
  max:This.T,
  includes: *const fn(range:VTab, ext:This.T) bool,
  isWithin: *const fn(range:VTab, min:This.T) ?bool
};

fn init(comptime t:type) This {
  return This{
    .T = t,
    .ptr = &This,
    .vtab = VTab{
      .max = 0,
      .min = 0,
      .includes = This.includes,
      .isWithin = This.isWithin
    }
  };
}

pub inline fn rawIncludes(r:This, ext:This.T) bool {
  return r.vtab.includes(r.ptr, ext);
}

pub inline fn rawIsWithin(r:This, min:This.T) ?bool {
  return r.vtab.isWithin(r.ptr, min);
}

pub inline fn includes(this:*This, ext:This.T) bool {
  return @intFromEnum(ext) >= @intFromEnum(this.vtab.min) and
         @intFromEnum(ext) <= @intFromEnum(this.vtab.max);
}

pub inline fn isWithin(this:*This, min:This.T) ?bool {
  if (@intFromEnum(this.*.vtab.min) >= @intFromEnum(min)) return true;
  if (@intFromEnum(this.*.vtab.max) < @intFromEnum(min)) return false;
  return null;
}