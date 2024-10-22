local M = {}

local function defaults()
  _G._MonaConfig = _G._MonaConfig or require("mona.config.defaults")()

  M.values = _G._MonaConfig
end

function M.extend(opts)
  opts = opts or {}

  M.values = vim.tbl_deep_extend("force", M.values, opts)

  return M
end

function M.is_extension_enabled(extension_name)
  local notify = require("mona.notify")("config", "is_extension_enabled")

  local extension_is_enabled = M.values.extensions[extension_name]

  if extension_is_enabled == nil then
    notify.warn("can not find extension, extension name: " .. extension_name)
    return false
  end

  return extension_is_enabled
end

defaults()

return M
