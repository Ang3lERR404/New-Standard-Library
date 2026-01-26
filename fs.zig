const std = @import("std.zig");
const builtin = @import("builtin");
const root = @import("root");
const mem = std.mem;
const base64 = std.base64;
const crypto = std.crypto;
const posix = std.posix;
const os = std.os;
const debug = std.debug;

const nativeOs = builtin.os.tag;
const windows = os.windows;

pub const AtomicFile = @import("fs/AtomicFile.zig");
pub const Dir = @import("fs/Dir.zig");
pub const File = @import("fs/File.zig");
pub const path = @import("fs/path.zig");
pub const wasi = @import("fs/wasi.zig");

pub const hasExecBit = switch (nativeOs) {
  .windows, .wasi => false,
  else => true
};

