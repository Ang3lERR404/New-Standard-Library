const This = @This();
const builtin = @import("builtin.zig");
const std = @import("std.zig");
const math = std.math;
const debug = std.debug;
const mem = std.mem;
const Allocat = mem.Allocator;
const Align = mem.Alignment;

userDt:?*anyopaque,
vtab:*const VTab,

pub const Threaded = @import("io/threaded.zig");
pub const fiber = @import("io/fiber.zig");
pub const Dispatch = @import("io/dispatch.zig");
pub const Kqueue = @import("io/kqueue.zig");
pub const uring = @import("io/uring.zig");
pub const Reader = @import("io/reader.zig");
pub const Writer = @import("io/writer.zig");
pub const net = @import("io/net.zig");
pub const Dir = @import("io/dir.zig");
pub const File = @import("io/file.zig");
pub const Terminal = @import("io/terminal.zig");
pub const RwLock = @import("io/rwlock.zig");
pub const Semaphore = @import("io/Semaphore.zig");

pub const VTab = struct {
};

pub const Operation = union(enum) {
  fRWStream:FileRWStream,
  dIOCtrl:deviceIoCtrl,
  netReceive:NetReceive,

  pub const Tag = @typeInfo(Operation).@"union".tag_type;

  pub const FileRWStream = struct {
    read:ReadStream,
    write:WriteStream,
  };

  pub const ReadStream = struct {
    file: File,
    data: []const []u8,
    pub const errors = common;
    pub const Result = errors!usize;
  };

  pub const WriteStream = struct {
    file:File,
    header:[]const u8 = &.{},
    data:[]const []const u8,
    splat:usize = 1,

    pub const errors = common;
    pub const Result = errors!usize;
  };

  pub const deviceIoCtrl = switch (builtin.os.tag) {
    
  };
};

pub const common = error {
  InOut,
  SysRes,
  isDir,
  ConnectionReset,
  CannotRead,
  socketDisconnect,
  WouldBlock,
  AccessDenied,
  LockViolation,
  Unexpected,
  DiskQuota,
  FileTooBig,
  NoSpaceLeft,
  DeviceBusy,
  PermissionDenied,
  BrokenPipe,
  CannotWrite,
  NoDevice,
  FileBusy,
  EndOfStream
};

pub const UnexpectedErrors = error {
  Unexpected
};