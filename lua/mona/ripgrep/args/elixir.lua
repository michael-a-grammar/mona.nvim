local M = {}

function M.modules(directory, tests)
  local factory = require("mona.ripgrep.args.factory")

  local glob = tests and "*_test.exs" or "*.ex"

  local regexp =
    string.format("defmodule ([a-zA-Z0-9.]*%s) do$", tests and "Test" or "")

  return factory({
    directory = directory,
    glob = glob,
    replace = "$1",
    regexp = regexp,
  })
end

function M.module(directory, module_name)
  local factory = require("mona.ripgrep.args.factory")

  local regexp = string.format("defmodule (%s) do$", module_name)

  return factory({
    directory = directory,
    replace = "$1",
    regexp = regexp,
  })
end

return M
