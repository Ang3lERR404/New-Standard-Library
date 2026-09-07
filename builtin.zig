const std = @import("std.zig");

const root = @import("root");
pub const asmb = @import("builtin/assembly.zig");
const This = @This();

pub const StackTrace = struct {
  idx:usize,
  cmdAddrs: []usize
};
pub const GlobalLinkage = enum(u2) {
  internal,
  strong,
  weak,
  linkOnce
};

pub const SymbolVisibility = enum(u2) {
  default,
  hidden,
  protected
};

pub const AtomicOrder = enum{
  unordered,
  monotonic,
  aquire,
  release,
  acqRel,
  seqCst
};

pub const ReduceOp = enum {
  And,
  Or,
  Xor,
  Min,
  Max,
  Add,
  Mul
};

pub const AtomicRmwOp = enum {
  XChng,
  Add,
  Sub,
  And,
  Nand,
  Or,
  Xor,
  Max,
  Min
};

pub const CodeModel = enum {
  default,
  extreme,
  kernel,
  large,
  medany,
  medium,
  medlow,
  medmid,
  normal,
  small,
  tiny
};

pub const OptimizeMode = enum {
  Debug,
  ReleaseSafe,
  ReleaseFast,
  ReleaseSmall
};

pub const CallingConvention = union(enum(u8)) {
  pub const This1 = @This();
  pub const Tag = @typeInfo(CallingConvention).@"union".tag_type.?;
  pub const c = This.target.cCallingConvention().?;

  pub const winapi:CallingConvention = switch(This.target.cpu.arch) {
    .x8664 => .{.x8664win = .{}},
    .x86 => .{.x86stdcall = .{}},
    .aarch64 => .{.aarch64AAPCSwin = .{}},
    .thumb => .{.armAAPCSVFP = .{}},
    else => unreachable
  };

  pub const kernel:CallingConvention = switch(This.target.cpu.arch) {
    .amdgcn => .amgGcnKernel,
    .nvptx, .nvptx64 => .nvptxKernel,
    .spirv32, .spirv64 => .spirvKernel,
    else => unreachable
  };

  auto,
  async,
  naked,
  @"inline",

  pub const x8664 = struct {
    sysV:This1.CommonOptions,
    x32:This1.CommonOptions,
    win:This1.CommonOptions,
    regcallv3SysV:This1.CommonOptions,
    regcallv4Win:This1.CommonOptions,
    interrupt:This1.CommonOptions
  };

  pub const CommonOptions = struct {
    incomingStackAlignment:?u64 = null
  };
};

pub const Type = union(enum) {
  type,
  void,
  bool,
  noreturn,
  int:Int,
  float:Float,
  pointer:Pointer,
  array:Array,
  @"struct":Struct,
  comptime_float,
  comptime_int,
  undefined,
  null,
  optional:Optional,
  errorUnion:ErrorUnion,
  errorSet:ErrorSet,
  @"enum":Enum,
  @"union":Union,
  @"fn":Fn,
  @"opaque":Opaque,
  frame:Frame,
  @"anyframe":AnyFrame,
  vector:Vector,
  enumLiteral,

  pub const Int = struct {
    signedness:Signedness,
    bits:u16
  };

  pub const Float = struct {
    bits:u16
  };

  pub const Pointer = struct {
    size:Size,
    alignment:?usize,
    addressSpace:AddressSpace,
    child:type,
    is:Is,

    sentinelPtr:?*const anyopaque,

    pub inline fn sentinel(comptime ptr:Pointer) ?ptr.child {
      const sp:*const ptr.child = @ptrCast(@alignCast(ptr.sentinelPtr orelse return null));
      return sp.*;
    }

    pub const Size = enum(u2) {
      one,
      many,
      slice,
      c
    };

    pub const Attributes = struct {
      @"const": bool = false,
      @"volatile":bool = false,
      allowedZero:bool = false,
      @"addrspace":?AddressSpace = null,
      @"align":?usize = null
    };
  };

  pub const Array = struct {
    len: comptime_int,
    child:type,
    sentinelPtr:?*const anyopaque,
    pub fn sentinel(comptime arr:Array) ?arr.child {
      const sp:*const arr.child = @ptrCast(@alignCast(arr.sentinelPtr orelse return null));
      return sp.*;
    }
  };

  pub const ContainerLayout = enum(u2) {
    auto,
    @"extern",
    @"packed"
  };

  pub const StructField = struct {
    name:[:0]const u8,
    type:type,
    defaultValuePtr:?*const anyopaque,
    is:Is,
    alignment:?usize,
    pub inline fn defaultValue(comptime sf:StructField) ? sf.type {
      const dp:*const sf.type = @ptrCast(@alignCast(sf.defaultValuePtr orelse return null));
      return dp.*;
    }
    pub const Attributes = struct {
      @"align":?usize = null,
      defaultValuePtr:?*const anyopaque = null
    };
  };

  pub const Struct = struct {
    layout: ContainerLayout,
    backingInt:?type = null,
    fields:[]const StructField,
    decls:[]const Declaration,
    is:Is
  };

  pub const Optional = struct {
    child:type
  };

  pub const ErrorUnion = struct {
    errorSet:type,
    payload:type
  };

  pub const Error = struct {
    name:[:0]const u8
  };

  pub const ErrorSet = ?[]const Error;

  pub const EnumField = struct {
    name:[:0]const u8,
    value:comptime_int
  };

  pub const Enum = struct {
    tagType:type,
    fields:[]const EnumField,
    decls:[]const Declaration,
    is:Is,
    pub const Mode = enum {
      exhaustive,
      nonexhaustive,
    };
  };

  pub const UnionField = struct {
    name:[:0]const u8,
    type:type,
    alignment:?usize,
    pub const Attributes = struct {
      @"align": ?usize = null
    };
  };

  pub const Union = struct {
    layout:ContainerLayout,
    tagType:?type,
    fields:[]const UnionField,
    decls:[]const Declaration
  };

  pub const Fn = struct {
    callingConv:CallingConvention,
    is:Is,
    returnType:?type,
    params:[]const Param,

    pub const Param = struct {
      is:Is,
      type:?type,
      pub const Attributes = struct {
        @"noalias":bool = false
      };
    };

    pub const Attributes = struct {
      @"callconv":CallingConvention = .auto,
      varargs:bool = false
    };
  };

  pub const Opaque = struct {
    decls:[]const Declaration
  };

  pub const Frame = struct {
    function:*const anyopaque
  };

  pub const AnyFrame = struct {
    child:?type
  };

  pub const Vector = struct {
    len:comptime_int,
    child:type
  };

  pub const Declaration = struct {
    name:[:0]const u8
  };

  pub const Is = struct {
    @"const":bool,
    @"volatile":bool,
    @"allowedZero":bool,
    @"comptime":bool,
    generic:bool,
    varArgs:bool,
    @"noalias":bool,
    exhaustive:bool,
    tuple:bool
  };
};

pub const Endian = enum {
  big,
  little,

  pub const native = This.target.cpu.arch.endian();
  pub const foreign:Endian = @enumFromInt(1 - @intFromEnum(native));
};

pub const Signedness = enum(u1) {
  signed,
  unsigned
};

pub const OutputMode = enum {
  Exe,
  Lib,
  Obj
};

pub const LinkMode = enum {
  static,
  dynamic
};

pub const UnwindTables = enum {
  none,
  sync,
  async
};

pub const WasiExecModel = enum {
  command,
  reactor
};

pub const CallModifier = enum {
  auto,
  neverTail,
  neverInline,
  noSuspend,
  alwaysTail,
  alwaysInline,
  compileTime
};

pub const VaListAarch64 = extern struct {
  stack:*anyopaque,
  grTop:*anyopaque,
  vrTop:*anyopaque,
  grOffs:i16,
  vrOffs:i16
};

pub const VaListAlpha = extern struct {
  base:*anyopaque,
  offset:i16
};

pub const VaListArm = extern struct {
  ap:*anyopaque
};

pub const VaListHexagon = extern struct {
  gpr:u32,
  fpr:u32,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaListPowerPc = extern struct {
  gpr:u8,
  fpr:u8,
  reserved:u16,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaListS390x = extern struct {
  currentSavedRegAreaPointer:*anyopaque,
  savedRegAreaEndPointer:*anyopaque,
  overflowAreaPointer:*anyopaque
};

pub const VaListSh = extern struct {
  vaNextO:*anyopaque,
  vaNextOLimit:*anyopaque,
  vaNextFp:*anyopaque,
  vaNextFpLimit:*anyopaque,
  vaNextStack:*anyopaque
};

pub const VaListx8664 = extern struct {
  gpOffset:u16,
  fpOffset:u16,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaListXtensa = extern struct {
  vaStk:*i16,
  vaReg:*i16,
  vaNdx:i16
};

pub const VaList = switch (builtin.cpu.arch) {
  
};