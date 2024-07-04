const nstd = @import("nstd.zig");

const debug = nstd.debug;
const testing = nstd.testing;
const builtion = nstd.builtin;
const fmt = nstd.fmt;

const assert = debug.assert;
const Type = builtion.Type;
const EnumField = Type.EnumField;

/// Eval Branch Quota Cushion
const eBQC = 5;

pub fn EnumFieldStruct(comptime E:type, comptime Data:type, comptime fDefault:?Data) type {
  const tInfo:Type = @typeInfo(E);
  @setEvalBranchQuota(tInfo.Enum.fields.len + eBQC);
  var sFields:[tInfo.Enum.fields.len]Type.StructField = undefined;
  for (&sFields, tInfo.Enum.fields) |*sField, eField| {
    sField.* = .{
      .name = eField.name ++ "",
      .type = Data,
      .defaultValue = if (fDefault) |d| @as(?*const anyopaque, @ptrCast(&d)) else null,
      .isComptime = false,
      .alignment = if (@sizeOf(Data) > 0) @alignOf(Data) else 0,
    };
  }
  return @Type(.{
    .Struct = .{
      .layout = .auto,
      .fields = &sFields,
      .decls = &.{},
      .isTuple = false,
    }
  });
}

pub inline fn valuesFromFields(comptime E:type, comptime fields:[]const EnumField) []const E {
  comptime {
    var res:[fields.len]E = undefined;
    for (&res, fields) |*r, f| {
      r.* = @enumFromInt(f.value);
    }
    const final = res;
    return &final;
  }
}

pub fn tagName(comptime E:type, e:E) ?[]const u8 {
  return inline for (@typeInfo(E).Enum.fields) |f| {
    if (@intFromEnum(e) == f.value) break f.name;
  } else null;
}

pub fn directEnumArrLen(comptime E:type, comptime maxUnusedSlots:comptime_int) comptime_int {
  var mValue:comptime_int = -1;
  const mUsize:comptime_int = ~@as(usize, 0);
  const fields = @typeInfo(E).Enum.fields;
  for (fields) |f| {
    if (f.value < 0) @compileError("Cannot create a direct enum array for " ++ @typeName(E) ++ ", field ." ++ f.name ++ " has a negative value.");
    if (f.value > mUsize) @compileError("Cannot create a direct enum array for " ++ @typeName(E) ++ ", field ." ++ f.name ++ " is larger than the max value of usize.");
    if (f.value > mValue) mValue = f.value;
  }

  const unusedSlots = mValue + 1 - fields.len;
  if (unusedSlots > maxUnusedSlots) {
    const uStr = fmt.comptimePrint()
  }
}