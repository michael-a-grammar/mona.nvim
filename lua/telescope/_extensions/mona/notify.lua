local M = {}

local mt = {
  __call = function(_, mod_name_suffix, fn_name)
    return require("mona.notify").for_module("telescope._extensions.mona")(
      mod_name_suffix,
      fn_name
    )
  end,
}

return setmetatable(M, mt)
