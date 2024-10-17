local M = {}

local function defaults()
  _G._MonaConfig = _G._MonaConfig or require("mona.config.defaults")

  M.values = _G._MonaConfig

  return M
end

function M.extend(opts)
  opts = opts or {}

  M.values = vim.tbl_deep_extend("force", M.values, opts)

  _G._MonaConfig = M.values

  return M
end

defaults()

return M
