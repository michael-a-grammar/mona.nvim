local M = {}

M.module = {}

local Path = require("plenary.path")

local directories = require("mona.directories")
local files = require("mona.files")
local utils = require("mona.utils")

local function get_module_name()
  local elixir_module_name_regex = [[defmodule \([a-zA-Z0-9.]*\) do]]

  local line_number = vim.fn.search(elixir_module_name_regex, "bcnW")

  if line_number == 0 then
    return false
  end

  local match = vim.fn.matchbufline(
    vim.api.nvim_get_current_buf(),
    elixir_module_name_regex,
    line_number,
    line_number,
    {
      submatches = true,
    }
  )

  if
    not match
    or not match[1]
    or not match[1].submatches
    or not match[1].submatches[1]
  then
    return false
  end

  local module_name = match[1].submatches[1]

  return module_name
end

local function get_test_file()
  local buffer_name = vim.fn.bufname()

  if string.find(buffer_name, ".+/test/.+_test%.exs") then
    return false
  end

  local buffer_file = files.buffer()

  if not utils.paths.exists(buffer_file) then
    return false
  end

  local test_file = string.gsub(buffer_file, "/lib/", "/test/")

  test_file = string.gsub(test_file, "%.ex", "_test.exs")

  return Path:new(test_file)
end

function M.module.goto_test_file()
  local test_file = get_test_file()

  vim.cmd("normal! m")

  pcall(vim.cmd, string.format("edit %s", test_file))
end

local mt = {
  __call = function(_)
    local test_file = get_test_file()

    return {
      name = get_module_name(),

      test_file = {
        exists = utils.paths.exists(test_file),
        path = test_file and test_file.filename or "",
      },
    }
  end,
}

setmetatable(M.module, mt)

return M
