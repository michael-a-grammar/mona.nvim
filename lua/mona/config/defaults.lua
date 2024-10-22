local M = {}

local mt = {
  __call = function()
    local icons = require("mona.config.icons")

    return {
      enable_icons = true,

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

      icons = {
        elixir = icons.elixir,
        mona = icons.mona,
      },
    }
  end,
}

return setmetatable(M, mt)
