const std = @import("std");
const print = std.debug.print;
test {
  print("{any}\n", .{30.0 / (12.0/10.0)});
}