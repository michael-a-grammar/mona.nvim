local callable_table = require("mona.constructs.callable_table")
local message_formatter = require("mona.constructs.message_formatter")

local assert_argument = require("mona.constructs.assert_argument")(...)

local function title()
  return require("mona.lib.config").prefix_with_icon("mona", "mona.nvim")
end

return callable_table(function(mod_name)
  assert_argument(mod_name)

  local M = callable_table(function(message, metadata, fn_name, opts)
    assert_argument(message, "message")

    opts = opts or {}

    local log_level_value =
      require("mona.vim.config").log_level_value(opts.log_level_name)

    message = message_formatter(mod_name, message, fn_name, metadata)

    local notify_once = vim.F.if_nil(opts.notify_once, false)

    local notify_fn = notify_once and vim.notify_once or vim.notify

    notify_fn(message, log_level_value, {
      title = title(),
    })

    return nil
  end)

  function M.factory(fn_name)
    return function(message, metadata, opts)
      return M(message, metadata, fn_name, opts)
    end
  end

  return M
end)
