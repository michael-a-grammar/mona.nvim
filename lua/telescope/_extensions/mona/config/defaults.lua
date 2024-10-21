local M = {}

local mt = {
  __call = function(_, included_pickers_name)
    return {
      pickers = {
        [included_pickers_name] = {
          theme = "dropdown",
        },
      },
    }
  end,
}

return setmetatable(M, mt)
