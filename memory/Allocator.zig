const nstd = @import("../nstd.zig");
const This = @This();
const aptr:type = *anyopaque;

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