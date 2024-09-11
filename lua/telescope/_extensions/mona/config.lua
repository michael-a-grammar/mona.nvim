local M = {}

_G._TelescopeMonaConfig = {} or _G._TelescopeMonaConfig

M.values = _G._TelescopeMonaConfig

local extend_config_values = function(opts)
  if not opts then
    return M
  end

  M.values = vim.tbl_deep_extend('force', M.values, opts)
end

M.setup = function(ext_config, config)
  extend_config_values(config)
  extend_config_values(ext_config)

  return M
end

return M
