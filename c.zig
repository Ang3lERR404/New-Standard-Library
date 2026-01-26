const std = @import("std.zig");
const builtin = @import("builtin");
const This = @This();
const darwin = @import("c/darwin.zig");
const freebsd = @import("c/freebsd.zig");
const solaris = @import("c/solaris.zig");
const netbsd = @import("c/netbsd.zig");
const dragonfly = @import("c/dragonfly.zig");
const haiku = @import("c/haiku.zig");
const openbsd = @import("c/openbsd.zig");

const math = std.math;
const debug = std.debug;
const heap = std.heap;
const os = std.os;
const posix = std.posix;