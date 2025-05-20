const root = @import("root");
const nstd = @import("nstd.zig");
const builtinOD = @import("builtin");
const dll = @import("dynamically-linked-library.zig");

const debug = nstd.debug;
const math = nstd.math;
const elf = nstd.elf;
const fs = nstd.fs;