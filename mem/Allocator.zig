const std = @import("../std.zig");
const builtin = @import("builtin");
const assert = std.debug.assert;
const math = std.math;
const mem = std.mem;
const This = @This();
const Alignment = std.mem.Alignment;
const io = std.io;

pub const errors = error{
  OutOfMemory,
  IncorrectPtrType
};
pub const log2Align = math.Log2Int(usize);

ptr:*anyopaque,
vtable:*const vTable,

pub const vTable = struct {
  alloc:*const fn (*anyopaque, len:usize, alignment:Alignment, retAddr:usize) ?[*]u8,
  resize:*const fn (*anyopaque, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) bool,
  remap:*const fn(*anyopaque, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) ?[*]u8,
  free:*const fn(*anyopaque, memory:[]u8, alignment:Alignment, retAddr:usize) void,
};

pub fn noResize(this:*anyopaque, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) bool {
  _ = this;
  _ = memory;
  _ = alignment;
  _ = newLen;
  _ = retAddr;
  return false;
}
pub fn noRemap(this:*anyopaque, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) ?[*]u8 {
  _ = this;
  _ = memory;
  _ = alignment;
  _ = newLen;
  _ = retAddr;
  return null;
}
pub fn noFree(this:*anyopaque, memory:[]u8, alignment:Alignment, retAddr:usize) void {
  _ = this;
  _ = memory;
  _ = alignment;
  _ = retAddr;
}

pub inline fn rawAlloc(a:This, len:usize, alignment:Alignment, retAddr:usize) ?[*]u8 {
  return a.vtable.alloc(a.ptr, len, alignment, retAddr);
}

pub inline fn rawResize(a:This, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) bool {
  return a.vtable.resize(a.ptr, memory, alignment, newLen, retAddr);
}

pub inline fn rawRemap(a:This, memory:[]u8, alignment:Alignment, newLen:usize, retAddr:usize) ?[*]u8 {
  return a.vtable.remap(a.ptr, memory, alignment, newLen, retAddr);
}

pub inline fn rawFree(a:This, memory:[]u8, alignment:Alignment, retAddr:usize) void {
  return a.vtable.free(a.ptr, memory, alignment, retAddr);
}

pub fn create(a:This, comptime T:type) errors!*T{
  if (@sizeOf(T) == 0) return @as(*T, @ptrFromInt(math.maxInt(usize)));
  const ptr:*T = @ptrCast(try a.allocBytesWithAlignment(@alignOf(T), @sizeOf(T), @returnAddress()));
  return ptr;
}

pub fn destroy(a:This, ptr:anytype) !void {
  const info = @typeInfo(@TypeOf(ptr)).pointer;
  if (info.size != .one) {

  }
  const T = info.child;
}