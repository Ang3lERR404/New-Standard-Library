const root = @import("root");
const std = @import("std.zig");
const builtin = @import("builtin");
const debug = std.debug;
const math = std.math;
const mem = std.mem;
const elf = std.elf;
const fs = std.fs;
const dl = @import("dynamic-library.zig"); 
const maxPathBytes = fs.maxPathBytes;
const posix = std.posix;
const nativeOs = builtin.os.tag;

const assert = debug.assert;