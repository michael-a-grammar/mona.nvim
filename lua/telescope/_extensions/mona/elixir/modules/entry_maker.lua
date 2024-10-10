local M = {}

local mt = {
  __call = function(_, entry)
    local module = require("mona.ripgrep.results.elixir").module(entry)

    if
      not module
      or not module.column_number
      or not module.module_name
      or not module.line_number
      or not module.path
    then
      return false
    end

    return {
      col = module.column_number,
      display = module.module_name,
      lnum = module.line_number,
      ordinal = module.module_name,
      path = module.path,
      value = entry,
    }
  end,
}

return setmetatable(M, mt)
