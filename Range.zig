const nstd = @import("nstd.zig");
const aptr = nstd.meta.aptr;


pub fn Range(comptime T:type) type {
  return struct{
    pub const errors = error{
      OutOfRange
    };
    const This = @This();

    ///Fixed minimum
    fxdMin:T,

    ///Fixed maximum
    fxdMax:T,
    cat:nstd.mem.Allocator,

    pub fn calc(this:*This, min:T, max:T) errors![*]T {
      return switch(true) {
        min < this.fxdMin, max > this.fxdMax => errors.OutOfRange,
        else => {

        }
      };
    }
  };
}

// ptr:aptr,
// table:*const Table,

// pub const Table = struct {
//   minimum:usize,
//   maximum:usize,
//   calc:*const fn(ctx:aptr, min:usize, max:usize) errors![*]usize,
// };

// pub inline fn rawCalc(this:This, min:usize, max:usize) errors![*]usize {
//   return try this.table.calc(this.ptr, min, max);
// }