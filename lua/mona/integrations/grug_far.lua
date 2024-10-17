local M = {
  module = {},
}

local grug_far_integration =
  require("mona.integrations.base_integration")("grug_far", true, "grug-far")

local function make_grug_far(plugin, title, search_fn, opts)
  local module_name = require("mona.elixir.module").name()

  if not module_name then
    return nil
  end

  opts = vim.tbl_deep_extend("force", opts or {}, {
    staticTitle = require("mona.config").prefix_with_icon("mona", title),

    prefills = {
      filesFilter = "*.{ex,exs}",
      search = search_fn(module_name),
    },
  })

  return plugin.open(opts)
end

M.module.name = grug_far_integration(function(plugin)
  return function(opts)
    return make_grug_far(
      plugin,
      "Find and Replace Module",
      function(module_name)
        return module_name
      end,
      opts
    )
  end
end)

M.module.imports = grug_far_integration(function(plugin)
  return function(opts)
    return make_grug_far(
      plugin,
      "Find and Replace Module Imports",
      function(module_name)
        return "(alias|require|import|use) " .. module_name
      end,
      opts
    )
  end
end)

return M
