const std = @import("std.zig");
const builtin = @import("builtin");
const root = @import("root");

const mem = std.mem;
const fs = std.fs;
const math = std.math;
const debug = std.debug;
const heap = std.heap;
const os = std.os;

const nativeOs = builtin.os.tag;
const pageSizeMin = heap.pageSizeMin;
const maxPathBytes = fs.maxPathBytes;

pub const useLibC = builtin.link_libc or switch (nativeOs) {
  .windows, .wasi => true,
  else => false
};

pub const system = if (useLibC)
  std.c
else switch (nativeOs) {
  .linux => os.linux,
  .plan9 => os.plan9,
  else => struct {
    pub const uContextT = void;
    pub const pidT = void;
    pub const pollfd = void;
    pub const fdT = void;
    pub const uidT = void;
    pub const gidT = void;
  }
};

pub const iovec = extern struct {
  base:[*]u8,
  len:usize
};
pub const iovecConst = extern struct {
  base:[*]const u8,
  len:usize
};
pub const accMode = enum(u2) {
  readOnly = 0,
  writeOnly = 1,
  readWrite = 2
};
pub const tcsa = enum(c_uint) {
  now, drain, flush, _
};
pub const winsize = extern struct {
  row:u16,
  col:u16,
  xPixel:u16,
  yPixel:u16
};
pub const lock = struct {
  pub const sh = 1;
  pub const ex = 2;
  pub const nb = 4;
  pub const un = 8;
};

pub const log = enum(u2) {
  emerg = 0,
  alert = 1,
  crit = 2,
  err = 3,
  warn = 4,
  notice = 5,
  info = 6,
  debug = 7
};

pub const socketT = if (nativeOs == .windows) os.windows.ws232.socket else fdt;

pub fn errno(rc:anytype) system.E {
  if (useLibC)
    return if (rc == -1) @enumFromInt(std.c._errno().*) else .success;
  const signed:isize = @bitCast(rc);
  const int = if (signed > -4096 and signed < 0) -signed else 0;
  return @enumFromInt(int);
}