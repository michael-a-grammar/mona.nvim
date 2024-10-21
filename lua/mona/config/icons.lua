local M = {}

local mt = {
  __call = function(_)
    return {
      elixir = "",
      mona = "",
    }
  end,
}

return setmetatable(M, mt)
