const strc:type = []const u8;
const strcnt0:type = ?[:0]const u8;
const ptrMdl:type = *const Model;

cpu: Cpu,
os: Os,
abi: Abi,
ofmt: ObjectFormat,
dynamic_linker: DynamicLinker,

pub const Query = @import("Target/Query.zig");

pub const Tag = enum {
  freestanding, ananas, cloudabi, dragonfly, freebsd, fuchsia, ios, kfreebsd,
  linux, lv2, macos, netbsd, openbsd, solaris, uefi, windows, zos, haiku,
  minix, rtems, nacl, aix, cuda, nvcl, amdhsa, ps4, ps5, elfiamcu, tvos, watchos,
  driverkit, visionos, mesa3d, contiki, amdpal, hermit, hurd, wasi, emscripten,
  shadermodel, liteos, serenity, opencl, glsl450, vulkan, plan9, illumos, other
};

pub const Gos = enum {
  darwin, bsd, solarish
};
pub const Garch = enum {
  x86, arm, aarch, thumb, wasm, riscv, mips, ppc, sparc, spirv, bpf, nvptx
};

pub const Abi = enum {
  none, gnu, gnuabin32, gnuabi64, gnueabi, gnueabihf, gnuf32, gnuf64, gnusf, gnux32,
  gnuilp32, code16, eabi, eabihf, android, musl, musleabi, musleabihf, muslx32, msvc,
  itanium, cygnus, coreclr, simulator, macabi, pixel, vertex, geometry, hull, domain,
  compute, library, raygeneration, intersection, anyhit, closesthit, miss, callable,
  mesh, amplification, ohos,

  pub fn default(arch:Arch) Abi {

  }
};
///temporary
pub const Cpu = struct {
  pub const Arch = enum {
    arm, armeb, aarch64, aarch64Be, aarch6432, arc, avr, bpfel, bpfeb, csky, dxil, hexagon, loongarch32,
    loongarch64, m68k, mips, mipsel, mips64, mips64el, msp430, powerpc, powerpcle, powerpc64, powerpc64le,
    r600, amdgcn, riscv32, riscv64, sparc, sparc64, sparcel, s390x, tce, tcele, thumb, thumbeb, x86, x8664,
    xcore, xtensa, nvptx, nvptx64, le32, le64, amdil, amdil64, hsail, hsail64, spir, spir64, spirv, spirv32, spirv64,
    kalimba, shave, lanai, wasm32, wasm64, renderscript32, renderscript64, ve, spu2,

    pub inline fn is(arch:Arch) Garch {
      return switch (arch) {
        .x86, .x8664 => Garch.x86,
        .arm, .armeb => Garch.arm,
        .aarch64, .aarch64Be, .aarch6432 => Garch.aarch,
        .thumb, .thumbeb => Garch.thumb,
        .wasm32, .wasm64 => Garch.wasm,
        .riscv32, .riscv64 => Garch.riscv,
        .mips, .mipsel, .mips64, .mips64el => Garch.mips,
        .powerpc, .powerpcle, .powerpc64, .powerpc64le => Garch.ppc,
        .sparc, .sparcel, .sparc64 => Garch.sparc,
        .spirv32, .spirv64 => Garch.spirv,
        .bpfel, .bpfeb => Garch.bpf,
        .nvptx, .nvptx64 => Garch.nvptx
      };
    }

    pub fn parseCPUModel(arch:Arch, cpuName:strc) !*const Model {

    }
  };

  pub const Model = struct {
    name:strc,
    llvmName:strcnt0,
    features:Feature.Set,

    pub fn toCpu(model:ptrMdl, arch:Arch) Cpu {
      var features = model.features;
      features.populateDeps(arch.allFeatures());
      return .{
        .arch = arch,
        .model = model,
        // well well- dooDoDO-DoDoooo OoooooOoOoOoOoOooooo..
      };
    }
  };
};
///temporary
pub const ObjectFormat = struct {};
///temporary
pub const DynamicLinker = struct {};
///temporary
pub const VersionRange = struct {};

pub const Os = struct {
  tag: Tag,
  versionRange: VersionRange,

  pub inline fn os(tag:Tag) Gos {
    return switch (tag) {
      .ios, .macos, .watchos, .tvos, .visionos => Gos.darwin,
      .kfreebsd, .freebsd, .openbsd, .netbsd, .dragonfly => Gos.bsd,
      .solaris, .illumos => Gos.solarish,
      .linux => {}
    };
  }
};
