local mod_name, _ = ...

return setmetatable({}, {
  __call = function(_, entry)
    local notify = require("mona.notify")(mod_name)

    local picker_name = entry[1]

    if not picker_name or picker_name == "" then
      notify("table value is nil or empty", {
        table = vim.inspect(entry),
      })
      return false
    end

    local picker_display_name = ""

    for picker_display_name_part in string.gmatch(picker_name, "[^_]+") do
      if picker_display_name_part ~= "elixir" then
        picker_display_name =
          string.format("%s %s", picker_display_name, picker_display_name_part)
      end
    end

    local utils = require("telescope._extensions.mona.utils")

    picker_display_name = utils.string.capitalise(picker_display_name)

    return {
      display = picker_display_name,
      ordinal = picker_name,
      value = entry,
    }
  end,
})
