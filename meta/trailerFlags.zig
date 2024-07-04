const nstd = @import("../nstd.zig");
const meta = nstd.meta;
const testing = nstd.testing;
const assert = nstd.debug.assert;
const Type = nstd.builtin.Type;

pub fn TrailerFlags(comptime Fields:type) type {
  const tInfo = @typeInfo(Fields);
  return struct {
    bits:Int,

    pub const bCount = tInfo.Struct.fields.len;
    pub const Int = meta.Int(.unsigned, bCount);

    pub const FEnum = meta.FieldEnum(Fields);
  };
}