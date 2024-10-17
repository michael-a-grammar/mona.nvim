local M = {}

local elixir_paths = require("mona.elixir.paths")
local vim_paths = require("mona.vim.paths")

local result = require("mona.lib.result")(...)

function M.is_module()
  return result
    .unwrap(function()
      return vim_paths.buffer()
    end)
    .with({
      ok = function(buffer_path)
        return elixir_paths.is_module(buffer_path)
      end,

      err = function(_)
        return false
      end,
    })
end

function M.is_test_module()
  return result
    .unwrap(function()
      return vim_paths.buffer()
    end)
    .with({
      ok = function(buffer_path)
        return elixir_paths.is_test_module(buffer_path)
      end,

      err = function(_)
        return false
      end,
    })
end

function M.to_module_path()
  return result
    .unwrap(function()
      return vim_paths.buffer()
    end)
    .with({
      ok = function(buffer_path)
        return result.ok(elixir_paths.to_module_path(buffer_path))
      end,
    })
end

function M.to_test_module_path()
  return result
    .unwrap(function()
      return vim_paths.buffer()
    end)
    .with({
      ok = function(buffer_path)
        return result.ok(elixir_paths.to_test_module_path(buffer_path))
      end,
    })
end

return M
