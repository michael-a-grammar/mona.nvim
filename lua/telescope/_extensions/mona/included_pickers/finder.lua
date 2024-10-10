local M = {}

local mt = {
  __call = function(_, opts)
    local finders = require("telescope.finders")

    local entry_maker =
      require("telescope._extensions.mona.included_pickers.entry_maker")

    return finders.new_table({
      entry_maker = entry_maker,
      results = opts.included_pickers,
    })
  end,
}

return setmetatable(M, mt)
