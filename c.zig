const nstd = @import("nstd.zig");
const builtin = @import("builtin");
const wasi = @import("c/wasi.zig");

const c = @This();
const mem = nstd.mem;
const posix = nstd.posix;
