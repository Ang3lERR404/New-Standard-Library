const nstd = @import("nstd.zig");
const builtinOD = @import("builtin");

const mem = nstd.mem;
const testing = nstd.testing;
const elf = nstd.elf;
const os = nstd.os;
const nativeOS = builtinOD.os.tag;
const posix = nstd.posix;