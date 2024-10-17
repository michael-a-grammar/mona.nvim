local M = {}

local Path = require("plenary.path")

local callable_table = require("mona.constructs.callable_table")
local paths = require("mona.lib.paths")

local result = require("mona.lib.result")(...)

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

M.working_directory = callable_table(function()
  return Path:new((vim.uv or vim.loop).cwd())
end)

M.buffer = callable_table(function()
  local err = result.err.factory("buffer")

  local buffer_path = Path:new(vim.fn.bufname())

  if not paths.exists(buffer_path) then
    return err("buffer path does not exist", {
      buffer_path = buffer_path,
    })
  end

  return result.ok(buffer_path)
end)

function M.working_directory.find_upwards(item_name)
  assert_argument_factory("working_directory.find_upwards")(
    item_name,
    "item_name"
  )

  return paths.find_upwards(M.working_directory(), item_name)
end

function M.buffer.directory()
  return result
    .unwrap(M.buffer)
    .ok(function(buffer_path)
      return buffer_path:parent()
    end)
    .rewrap()
end

return M
