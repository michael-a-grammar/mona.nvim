local M = {}

local mt = {
  __call = function()
    return {
      enable_icons = true,
      log_level = vim.log.levels.WARN,

      elixir = {
        module = {
          goto_test = {
            edit_command = require("mona.vim.edit_commands").rightbelow_vnew,
          },
        },
      },

      extensions = {
        bufferline = false,
        grug_far = false,
      },

      icons = require("mona.config.icons")(),
    }
  end,
}

return setmetatable(M, mt)
