local mod_name, _ = ...

return setmetatable({}, {
  __call = function(_, entry)
    local module = require("mona.ripgrep.results.elixir.module")(entry)

    if not module then
      require("mona.notify")(mod_name)("could not parse ripgrep output")
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
})
