local M = {}

local bufferline_integration =
  require("mona.integrations.base_integration")("bufferline", false)

local priority = 0

local function increment_group_priority()
  priority = priority + 1

  return priority
end

local function make_bufferline_group_factory(defaults)
  return function(group_name, opts)
    local config = require("mona.config")

    local mona_icon = config.icon("mona")

    local group = vim.tbl_deep_extend("keep", opts, {
      auto_close = true,
      icon = mona_icon and string.format(" %s ", mona_icon) or "",
      name = config.prefix_with_icon("elixir", group_name),
      priority = increment_group_priority(),
    })

    return vim.tbl_deep_extend("force", group, defaults)
  end
end

M.groups = bufferline_integration(function()
  return function(opts)
    opts = opts or {}

    local defaults = opts.defaults or {}

    opts["defaults"] = nil

    local make_bufferline_group = make_bufferline_group_factory(defaults)

    local groups = vim.tbl_deep_extend("keep", opts, {
      mix = make_bufferline_group("Mix", {
        matcher = function(buf)
          return buf.name:match("mix%.exs$")
        end,
      }),

      tests = make_bufferline_group("Tests", {
        matcher = function(buf)
          return buf.name:match("%_test%.exs$")
        end,
      }),

      config = make_bufferline_group("Config", {
        matcher = function(buf)
          return buf.path:match("/config/") and buf.name:match("%.ex$")
            or buf.name:match("%.exs$")
              and not buf.name:match("mix%.exs$")
              and not buf.name:match("%_test%.exs$")
        end,
      }),

      elixir = make_bufferline_group("Elixir", {
        matcher = function(buf)
          return buf.name:match("%.ex$")
            or buf.name:match("%.exs$")
              and not buf.name:match("mix%.exs$")
              and not buf.name:match("%_test%.exs$")
              and not buf.path:match("/config/")
        end,
      }),
    })

    return {
      groups = vim.tbl_values(groups),
      increment_group_priority = increment_group_priority,
    }
  end
end)

return M
