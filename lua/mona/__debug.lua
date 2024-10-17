local M = {}

local mt = {
  __call = function(_)
    return {
      directories = require("mona.directories")(),
      files = require("mona.files")(),

      elixir = {
        module = require("mona.elixir").module(),
      },
    }
  end,
}

return setmetatable(M, mt)
