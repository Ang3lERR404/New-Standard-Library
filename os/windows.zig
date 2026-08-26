const builtin = @import("builtin");
const std = @import("../std.zig");
const mem = std.mem;
const debug = std.debug;
const math = std.math;
const posix = std.posix;

const nativeArch = builtin.cpu.arch;