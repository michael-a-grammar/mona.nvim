local M = {}

M.modules = function(directory, tests)
   local glob = tests and "*_test.exs" or "*.ex"

   local regexp =
      string.format("defmodule ([a-zA-Z.]*%s) do$", tests and "Test" or "")

   return require("mona.ripgrep.args.factory")({
      directory = directory,
      glob = glob,
      replace = "$1",
      regexp = regexp,
   }).default()
end

return M
