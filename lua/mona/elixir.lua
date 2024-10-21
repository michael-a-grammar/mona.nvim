local M = {}

M.module = {}

function M.module.name()
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

function M.module.goto_test_file(opts)
  opts = opts or {}

  local files = require("mona.files")

  local test_file, test_file_exists = files.test()

  if not test_file_exists then
    if opts.prompt_to_create then
    end

    return false
  end

  local edit_command = require("mona.vim.edit_commands").find(opts)

  vim.cmd("normal! m")

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, string.format("%s %s", edit_command, test_file))
end

local mt = {
  __call = function(_)
    return {
      module = {
        goto_test_file = M.module.goto_test_file,
        name = M.module.name(),
      },
    }
  end,
}

setmetatable(M, mt)

return M
