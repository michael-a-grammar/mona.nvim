local M = {}

local grug_far_extension =
  require("mona.extensions.base_extension")("grug_far", true, "grug-far")

M.module = grug_far_extension("module", function(plugin)
  return function(opts)
    local module_name = require("mona").elixir.module.name()

    opts = vim.tbl_deep_extend("force", opts or {}, {
      prefills = {
        filesFilter = "*.{ex,exs}",
        search = module_name,
      },
    })

    return plugin.open(opts)
  end
end)

return M
