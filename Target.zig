cpu:Cpu,
os:Os,
abi:Abi,
ofmt:ObjectFormat,
dynamicLinker:DynamicLinker = DynamicLinker.none,

pub const Query = @import("target/query.zig");

pub const Os = struct {
  tag:Tag,
  versionRange:VersionRange,
  pub const Tag = enum {
    freestanding,
    other,
    contiki,
    fuchisa,
    hermit,
    managarm,
    haiku,
    hurd,
    illummos,
    linux,
    plan9,
    rtems,
    serenity,
    dragonfly,
    freebsd,
    netbsd,
    openbsd,
    driverkit,
    ios,
    maccatalyst,
    macos,
    tvos,
    visionos,
    watchos,
    windows,
    uefi,
    @"3ds",
    ps3,
    ps4,
    ps5,
    psp,
    vita,
    emscripten,
    wasi,
    amdhsa,
    amdpal,
    cuda,
    mesa3d,
    nvcl,
    opencl,
    opengl,
    vulkan,
    pub const Isop = enum {
      darwin,
      bsd
    };

    pub inline fn is(iso:Isop, tag:Tag) bool {
      return switch (iso) {
        .darwin => switch (tag) {
          .driverkit, .ios, .maccatalyst, .macos, .tvos,
          .visionos, .watchos => true,
          else => false
        },
        .bsd => tag.is(.darwin) or switch(tag) {
          .freebsd, .openbsd, netbsd, .dragonfly => true,
          else => false
        },
        else => false
      };
    }

    pub fn exeFileExt(tag:Tag, arch:Cpu.Arch) SlicedString {
      return switch(tag) {
        .windows => ".exe",
        .uefi => ".efi",
        .plan9 => arch.plan9Ext(),
        else => switch (arch) {
          .wasm32, .wasm64 => ".wasm",
          else => ""
        }
      };
    }

    pub fn staticLibExt(tag:Tag, abi:Abi) SlicedString {
      return switch (abi) {
        .msvc, .itanium => ".lib",
        else => switch(tag) {
          .windows, uefi => ".lib",
          else => ".a"
        }
      };
    }

    pub fn dynamicLibExt(tag:Tag) SlicedString {
      return switch (tag) {
        .windows, .uefi => ".dll",
        .driverkit, .ios, .maccatalyst,
        .macos, .tvos, .visionos, .watchos => ".dylib",
        else => ".so"
      };
    }

    pub fn libPrefix(tag:Os.Tag, abi:Abi) SlicedString {
      return switch(abi) {
        .msvc, .itanium => "",
        else => switch (tag) {
          .windows, .uefi => "",
          else => "lib"
        }
      };
    }

    pub fn defaultVersionRange(tag:Tag, arch:Cpu.Arch, abi:Abi) Os {
      return .{
        .tag = tag,
        .versionRange = .default(arch, tag, abi)
      };
    }

    pub inline fn versionRangeTag(tag:Tag) @typeInfo(TaggedVersionRange).@"union".tag_type.? {
      return switch (tag) {
        .freestanding, .other,
        .managarm, .haiku, .illumos,
        .plan9, .serenity, .ps3,
        .ps4, .ps5, .emscripten,
        .mesa3d => .none,

        .contiki, .fuchisa, .hermit, .rtems,
        .dragonfly, .freebsd, .netbsd, .openbsd,
        .driverkit, .ios, .maccatalyst, .macos,
        .tvos, .visionos, .watchos, .uefi,
        .@"3ds", .psp, .vita, .wasi,
        .amdhsa, .amdpal, .cuda, .nvcl,
        .opencl, .opengl, .vulkan => .semver,

        .hurd => .hurd,
        .linux => .linux,
        .windows => .windows
      };
    }
  };

  pub const WindowsVersion = enum(u32) {
    nt4 = 0x04000000,
    win2k = 0x05000000,
    xp = 0x05010000,
    ws2003 = 0x005020000,
    vista = 0x06000000,
    win7 = 0x06010000,
    win8 = 0x06020000,
    win81 = 0x06030000,
    win10 = 0x0A000000,
    win10Th2 = 0x0A000001,
    win10Rs1 = 0x0A000002,
    win10Rs2 = 0x0A000003,
    win10Rs3 = 0x0A000004,
    win10Rs4 = 0x0A000005,
    win10Rs5 = 0x0A000006,
    win1019h1 = 0x0A000007,
    win10Vb = 0x0A000008,
    win10Mn = 0x0A000009,
    win10Fe = 0x0A00000A,
    win10Ni = 0x0A00000B,
    win10Cu = 0x0A00000C,
    win11Zn = 0x0A00000E,
    win11Ga = 0x0A00000F,
    win11Ge = 0x0A000010,
    win11Dt = 0x0A000011,
    _,

    pub const latest = WindowsVersion.win11Dt;
    pub const knownWin10BuildNumbers = [_]u32{
      10240, 10586, 14393, 15063, 16299, 17134,
      17763, 18362, 18363, 19041, 19042, 19043,
      19044, 19045, 22000, 22621, 22631, 26100
    };

    pub inline fn isAtLeast(max:WindowsVersion, min:WindowsVersion) bool {
      return @intFromEnum(max) >= @intFromEnum(min);
    }

    pub const Range = struct {
      min:WindowsVersion,
      max:WindowsVersion,

      pub inline fn includesVersion(range:Range, ver:WindowsVersion) bool {
        return @intFromEnum(ver) >= @intFromEnum(range.min) and
               @intFromEnum(ver) <= @intFromEnum(range.max);
      }

      pub inline fn isAtLeast(range:Range, min:WindowsVersion) ?bool {
        if (@intFromEnum(range.min) >= @intFromEnum(min)) return true;
        if (@intFromEnum(range.max) < @intFromEnum(min)) return false;
        return null;
      }

      pub fn parse(std:[]const u8) !WindowsVersion {
        return meta.stringToEnum(WindowsVersion, str) orelse
          @enumFromInt(fmt.parseInt(u32, str, 0) catch
            return error.InvalidOSVersion);
      }

      pub fn format(wv:WindowsVersion, w:*Writer) Writer.Error!void {
        if (enums.tagName(WindowsVersion, wv)) |name| {
          var vecs:[2][]const u8 = .{".", name};
          return w.writeVecAll(&vecs);
        } else {
          return w.print("@enumFromInt(0x{X:0>8})", .{mv});
        }
      }
    };

    pub const HurdVersionRange = struct {
      range:SemanticVersion.Range,
      glibc:SemanticVersion,
    };
  };
};

const SlicedString:type = [:0]const u8;
const This = @This();
const std = @import("std.zig");
const builtin = @import("builtin.zig");
const mem = std.mem;
const debug = std.debug;
const SemanticVersion = std.SemanticVersion;
const Allocat = mem.Allocat;
const assert = debug.assert;