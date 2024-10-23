local M = {}

local function defaults()
  _G._MonaConfig = _G._MonaConfig or require("mona.config.defaults")()

  M.values = _G._MonaConfig

  return M
end

function M.extend(opts)
  opts = opts or {}

  M.values = vim.tbl_deep_extend("force", M.values, opts)

  _G._MonaConfig = M.values

  return M
end

function M.log_level_value(log_level_name)
  log_level_name = log_level_name
      and log_level_name ~= ""
      and string.upper(log_level_name)
    or false

  local config_log_level_value = M.values.log_level

  for log_level, log_level_value in pairs(vim.log.levels) do
    if
      log_level_value == config_log_level_value
      or log_level_name == log_level
    then
      return log_level_value
    end
  end

  return vim.log.levels.WARN
end

function M.icon(icon_name)
  if not M.values.enable_icons then
    return false
  end

  local icon = M.values.icons[icon_name]

  if icon then
    return icon
  end

  return false
end

function M.is_extension_enabled(extension_name)
  local notify = require("mona.notify")("config", "is_extension_enabled")

  local extension_is_enabled = M.values.extensions[extension_name]

  if extension_is_enabled == nil then
    notify("can not find extension", {
      extension_name = extension_name,
    })
    return false
  end

  return extension_is_enabled
end

defaults()

return M
