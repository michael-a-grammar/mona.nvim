local M = {}

local bufferline_extension =
  require("mona.extensions.base_extension")("bufferline", false)

local function make_bufferline_group(group_name, opts, defaults)
  local group_opts = opts[group_name] or {}

  local get_opt = function(opt_name)
    return group_opts[opt_name] or opts[opt_name] or defaults[opt_name]
  end

  return {
    auto_close = get_opt("auto_close"),
    icon = "  ",
    name = " Tests",
    priority = 1,

    highlight = {
      sp = opts.tests.icon,
    },

    matcher = function(buf)
      return buf.name:match("_test%.exs")
    end,
  }
end

M.groups = bufferline_extension("groups", function()
  return function(opts)
    opts = opts or {}

    return {
      make_bufferline_group("Tests", opts, {}),
    }
  end
end)

return M
