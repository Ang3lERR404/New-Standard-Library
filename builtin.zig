const nstd = @import("nstd.zig");
const builtin = @import("builtin");
const root = @import("root");
const str:type = [:0]const u8;

pub const subSystem:?nstd.Target.subSystem = blk: {

};

pub const Type = union(enum) {
  Type:void, Void:void, Bool:void,
  NoReturn:void, Int:Int,
  Float:Float, Pointer:Pointer,
  Array:Array, Struct:Struct,
  ComptimeFloat:void, ComptimeInt:void,
  Undefined:void, Null:void, Optional:Optional,
  ErrorUnion:ErrorUnion, ErrorSet:ErrorSet,
  Enum:Enum, Union:Union, Fn:Fn, Opaque:Opaque,
  Frame:Frame, AnyFrame:AnyFrame, Vector:Vector,
  EnumLiteral:void,

  pub const Int = struct {
    signedness:Signedness,
    bits:u16
  };

  pub const Float = struct {
    signedness:Signedness,
    bits:u16
  };

  pub const Pointer = struct {
    size:Size,
    isConst:bool,
    isVolatile:bool,
    isAllowZero:bool,
    alignment:u16,
    addressSpace:AddressSpace,
    child:type,

    sentinel:?*const anyopaque,

    pub const Size = enum(u2) {
      One, Many, Slice, C
    };
  };

  pub const Array = struct {
    len:comptime_int,
    child:type,

    sentinel:?*const anyopaque
  };

  pub const ContainerLayout = enum(u2) {
    auto, @"extern", @"packed"
  };

  pub const StructField = struct {
    name:str,
    type:type,
    defaultValue:?*const anyopaque,
    isComptime:bool,
    alignment:comptime_int
  };

  pub const Struct = struct {
    layout:ContainerLayout,
    backingInteger:?type = null,
    fields:[]const StructField,
    decls:[]const Declaration,
    isTuple:bool
  };

  pub const Optional = struct {
    child:type
  };

  pub const ErrorUnion = struct {
    errorSet:type,
    payload:type
  };

  pub const Error = struct {
    name:str
  };

  pub const ErrorSet = ?[]const Error;

  pub const EnumField = struct {
    name:str,
    value:comptime_int
  };

  pub const Enum = struct {
    tagType:type,
    fields:[]const EnumField,
    decls:[]const Declaration,
    isExhaustive:bool
  };

  pub const UnionField = struct {
    name:str,
    type:type,
    alignment:comptime_int
  };

  pub const Union = struct {
    layout:ContainerLayout,
    tagType:?type,
    fields:[]const EnumField,
    decls:[]const Declaration,
  };

  pub const Fn = struct {
    callingConvention:CallingConvention,
    isGeneric:bool,
    isVarArgs:bool,
    returnType:type,
    params:[]const Param,

    pub const Param = struct {
      isGeneric:bool,
      isNoAlias:bool,
      type:?type
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
    name:str
  };
};

// I hate c.
// because it doesn't make sense.
// and is honestly, more work.

pub const FloatMode = enum {
  strict, optimized
};

pub const Endian = enum {
  big, little
};

pub const Signedness = enum {
  ///Negative
  signed,

  ///Non-Negative
  unsigned
};

pub const OutputMode = enum {
  Exe, Lib, Obj
};

pub const LinkMode = enum {
  static, dynamic
};

pub const WasiExecModel = enum {
  command, reactor
};

pub const CallModifier = enum {
  /// Equivalent to function call syntax.
  auto,

  /// Equivalent to async keyword used with function call syntax.
  asyncKW,

  /// Prevents tail call optimization. This guarantees that the return
  /// address will point to the callsite, as opposed to the callsite's
  /// callsite. If the call is otherwise required to be tail called
  /// or inlined, a compile error is emitted instead.
  neverTail,

  /// Guarantees that the call will not be inlined. If the call is
  /// otherwise required to be inlined, a compile error is emitted instead.
  neverInline,

  /// Asserts that the function call will not suspend. This allows a
  /// non async function to call an async function.
  noAsync,

  /// Guarantees that the call will be generated with tail call optimization.
  /// If this is not possible, a compile error is emitted instead.
  alwaysTail,

  /// Guarantees that the call will be inlined at the callsite.
  /// If this is not possible, a compile error is emitted instead.
  alwaysInline,

  /// Evaluates the call at compile time. If the call cannot be completed at
  /// compile time, a compile error is emitted instead.
  compileTime
};

pub const VaListAarch64 = extern struct {
  stack:*anyopaque,
  grTop:*anyopaque,
  vrTop:*anyopaque,
  grOffs:c_int,
  vrOffs:c_int
};

pub const VaListHexagon = extern struct {
  gpr:c_int,
  fpr:c_int,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaListPowerPc = extern struct {
  gpr:u8,
  fpr:u8,
  reserved:c_ushort,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaListS390x = extern struct {
  gpOffset:c_uint,
  fpOffset:c_uint,
  overflowArgArea:*anyopaque
};

pub const VaListx86_64 = extern struct {
  gpOffset:c_uint,
  fpOffset:c_uint,
  overflowArgArea:*anyopaque,
  regSaveArea:*anyopaque
};

pub const VaList = switch (builtin.cpu.arch) {
  .aarch64, .aarch64_be => switch (builtin.os.tag) {
    .windows => *u8,
    .ios, .macos, .tvos, .watchos, .visionos => *u8,
    else => @compileError("Disabled, due to miscompilations") //VaListAarch64
  },

  .arm => switch (builtin.os.tag) {
    .ios, .macos, .tvos, .watchos, .visionos => *u8,
    else => *anyopaque
  },

  .amdgcn, .powerpc64, .powerpc64le,
  .x86 => *u8,
  .avr, .riscv32, .riscv64,
  .bpfel, .bpfeb, .mips, .mipsel,
  .mips64, .mips64el,
  .sparc, .sparcel, .sparc64,
  .spirv32, .spirv64,
  .wasm32, .wasm64 => *anyopaque,

  .hexagon => if (builtin.target.isMusl()) VaListHexagon else *u8,

  .powerpc, .powerpcle => switch (builtin.os.tag) {
    .ios, .macos, .tvos, .watchos, .visionos, .aix => *u8,
    else => VaListPowerPc
  },

  .x86_64 => switch (builtin.os.tag) {
    .windows => @compileError("Disabled, due to miscompilations"), // *u8,
    else => VaListx86_64
  },

  else => @compileError("VaList not supported yet for this target")
};

pub const PreFetchOptions = struct {
  rw:RW = .read,
  locality:u2 = 3,
  cache:Cache = .data,

  pub const RW = enum(u1) {
    read, write
  };

  pub const Cache = enum(u1) {
    instruction, data
  };
};

pub const ExportOptions = struct {
  name:[]const u8,
  linkage:GlobalLinkage = .strong,
  section:?[]const u8 = null,
  visibility:SymbolVisibility = .default
};

pub const ExternOptions = struct {
  name:[]const u8,
  libraryName:?[]const u8 = null,
  linkage:GlobalLinkage = .strong,
  isThreadLocal:bool = false
};

pub const CompilerBackend = enum(u64) {
  other = 0,
  stage1 = 1,
  stage2Llvm = 2,
  stage2C = 3,
  stage2Wasm = 4,
  stage2Arm = 5,
  stage2X8664 = 6,
  stage2Aarch64 = 7,
  stage2X86 = 8,
  stage2Riscv64 = 9,
  stage2Sparc64 = 10,
  stage2Spirv64 = 11,
  _
};

pub const TestFn = struct {
  name:[]const u8,
  func:*const fn () anyerror!void
};

pub const PanicFn = fn([]const u8, ?*StackTrace, ?usize) noreturn;

pub const panic:PanicFn = if (@hasDecl(root, "panic"))
    root.panic
  else if (@hasDecl(root, "os") and @hasDecl(root.os, "panic"))
    root.os.panic
  else
    defaultPanic;

pub fn defaultPanic(msg:[]const u8, errReturnTrace:?*StackTrace, retAddr:?usize) noreturn {
  @setCold(true);
  
  // >:C
  if (builtin.zig_backend == .stage2_wasm or
      builtin.zig_backend == .stage2_arm or
      builtin.zig_backend == .stage2_aarch64 or
      builtin.zig_backend == .stage2_x86 or
      (builtin.zig_backend == .stage2_x86_64 and (builtin.target.ofmt != .elf and builtin.target.ofmt != .macho)) or
      builtin.zig_backend == .stage2_sparc64 or
      builtin.zig_backend == .stage2_spirv64) while (true) @breakpoint();

  if (builtin.zig_backend == .stage2_riscv64) {
    asm volatile ("ecall"
    :
    : [number] "{a7}" (64),
      [arg1] "{a0}" (1),
      [arg2] "{a1}" (@intFromPtr(msg.ptr)),
      [arg3] "{a2}" (msg.len),
    : "memory");
    nstd.posix.exit(127);
  }
}
