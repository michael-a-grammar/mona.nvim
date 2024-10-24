local M = {}

local config = require("mona.config")

local elixir_icon = config.icon("elixir")
local mona_icon = config.icon("mona")

local bufferline_extension =
  require("mona.extensions.base_extension")("bufferline", false)

local function make_bufferline_group(group_name, defaults)
  return vim.tbl_deep_extend("keep", defaults, {
    auto_close = true,
    icon = mona_icon and string.format(" %s ", mona_icon) or "",
    name = elixir_icon and string.format("%s %s", elixir_icon, group_name)
      or group_name,
  })
end

M.groups = bufferline_extension("groups", function()
  return function(opts)
    local priority = 0

    local function increment_priority()
      priority = priority + 1
      return priority
    end

    opts = vim.tbl_deep_extend("force", opts or {}, {
      config = make_bufferline_group("Config", {
        priority = increment_priority(),

        matcher = function(buf)
          return buf.path:match("/config/")
        end,
      }),

      mix = make_bufferline_group("Mix", {
        priority = increment_priority(),

        matcher = function(buf)
          return buf.name:match("mix%.exs")
        end,
      }),

      tests = make_bufferline_group("Tests", {
        priority = increment_priority(),

        matcher = function(buf)
          return buf.name:match("_test%.exs")
        end,
      }),

      elixir = make_bufferline_group("Elixir", {
        priority = increment_priority(),

        matcher = function(buf)
          return buf.name:match("%.ex$") or buf.name:match("%.exs$")
        end,
      }),
    })

    return {
      values = vim.tbl_values(opts),
      increment_priority = increment_priority,
    }
  end
end)

return M
