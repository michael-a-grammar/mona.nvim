local M = {}

local mt = {
  __call = function(_)
    return {
      directories = require("mona.directories")(),
      files = require("mona.files")(),
      mona = require("mona"),

      config = {
        defaults = require("mona.config.defaults")(),
        global = _G._MonaConfig,
      },

      elixir = {
        module = require("mona.elixir")(),
      },

      vim = {
        edit_commands = require("mona.vim.edit_commands"),
      },
    }
  end,
}

return setmetatable(M, mt)
