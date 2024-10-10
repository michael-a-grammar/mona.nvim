local M = {}

local mt = {
  __call = function(_, entry)
    local utils = require("telescope._extensions.mona.utils")

    local picker_name = entry[1]
    local picker_display_name = ""

    for picker_display_name_part in string.gmatch(picker_name, "[^_]+") do
      if picker_display_name_part ~= "elixir" then
        picker_display_name = picker_display_name
          .. " "
          .. utils.string.capitalise(picker_display_name_part)
      end
    end

    return {
      display = picker_display_name,
      ordinal = picker_name,
      value = entry,
    }
  end,
}

return setmetatable(M, mt)
