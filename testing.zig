const std = @import("std");
const nstd = @import("nstd.zig");
const itr = nstd.iteration;

pub const errors = error {
  TestUnexpectedResult
};

pub fn expect(ok:bool) errors!void {
  if (!ok) return errors.TestUnexpectedResult;
}

pub fn expectAll(oks:[]const bool, itdr:itr.direction) errors!void {
  var i:usize = undefined;
  switch (itdr) {
    .forwards => {
      i = 0;
      while (i < oks.len) : (i += 1) {
        const ok = oks[i];
        if (!ok) {
          std.debug.print("Failed test {any}\n", .{i});
          return errors.TestUnexpectedResult;
        }
        std.debug.print("Passed test {any}\n", .{i});
      }
    },
    .backwards => {
      i = oks.len - 1;
      while (i > 0) : (i -= 1) {
        const ok = oks[i];
        if (!ok) {
          std.debug.print("Failed test {any}\n", .{i});
          return errors.TestUnexpectedResult;
        }
        std.debug.print("Passed test {any}\n", .{i});
      }
    }
  }
}