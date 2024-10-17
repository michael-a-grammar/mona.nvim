local M = {}

local result = require("mona.lib.result")(...)

function M.module_name(opts)
  opts = opts or {}

  local err = result.err.factory("module_name")

  local module_name_regex = [[defmodule \([a-zA-Z0-9.]*\) do]]

  local line_number = vim.fn.search(module_name_regex, "bcnW")

  if line_number == 0 then
    return err("can not find module name")
  end

  local match = vim.fn.matchbufline(
    vim.api.nvim_get_current_buf(),
    module_name_regex,
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
    return err("can not find module name", {
      match = match,
    })
  end

  local module_name = match[1].submatches[1]

  if opts.append_test then
    return module_name .. "Test"
  elseif opts.remove_test then
    return string.gsub(module_name, "Test$", "")
  end

  return result.ok(module_name)
end

function M.is_module()
  return not result.is_err(M.module_name())
end

function M.is_test_module()
  return result
    .unwrap(function()
      return M.module_name()
    end)
    .with({
      ok = function(module_name)
        return string.match(module_name, "Test$")
      end,

      err = function(_)
        return false
      end,
    })
end

return M
