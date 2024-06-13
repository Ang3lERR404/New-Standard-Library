const nstd = @import("../nstd.zig");
const This = @This();
const aptr:type = *anyopaque;

const assert = nstd.debug.assert;
const math = nstd.math;
const debug = nstd.debug;
const mem = nstd.mem;

pub const errors = error{
  OutOfMemory
};

ptr:aptr,
table:*const Table,

pub const Table = struct {
  alloc:*const fn(ctx:aptr, len:usize, ptrAlign:u8, retAdr:usize) ?[*]u8,
  resize:*const fn(ctx:aptr, buff:[]u8, bAlign:u8, nLen:usize, retAdr:usize) bool,
  free:*const fn(ctx:aptr, buff:[]u8, bAlign:u8, retAdr:usize) void
};

pub fn noResize (this:aptr, buff:[]u8, log2Balign:u8, nLen:usize, retAdr:usize) bool {
  _ = this;
  _ = buff;
  _ = log2Balign;
  _ = nLen;
  _ = retAdr;
  return false;
}

pub fn noFree (this:aptr, buff:[]u8, log2Balign:u8, retAdr:usize) void {
  _ = this;
  _ = buff;
  _ = log2Balign;
  _ = retAdr;
}

pub inline fn rawAlloc(this:This, len:usize, ptrAlign:u8, retAdr:usize) ?[*]u8 {
  return this.table.alloc(this.ptr, len, ptrAlign, retAdr);
}

pub inline fn rawResize(this:This, buff:[]u8, log2Balign:u8, nLen:usize, retAdr:usize) bool {
  return this.table.resize(this.ptr, buff, log2Balign, nLen, retAdr);
}

pub inline fn rawFree(this:This, buff:[]u8, log2Balign:u8, retAdr:usize) void {
  this.table.free(this.ptr, buff, log2Balign, retAdr);
}

pub fn allocWSAA(this:This, comptime size:usize, comptime alignment:29, n:usize, retAdr:usize) errors![*]align(alignment) u8 {
  const bCount = math.mul(usize, size, n) catch return errors;
  comptime debug.assert(alignment <= mem.pageSize);

  if (bCount == 0) {
    const ptr = comptime mem.alignfb(usize, math.minmax(usize, .max), alignment, .forwards);
    return @as([*]align(alignment) u8, @ptrFromInt(ptr));
  }

  const Bptr = this.rawAlloc(bCount, log2a(alignment));
}