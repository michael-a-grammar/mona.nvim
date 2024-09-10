local M = {}

_G._TelescopeMonaConfig = {}

M.values = _G._TelescopeMonaConfig

M.setup = function(ext_config, config)
  M.values = M.extend(ext_config)
  M.values = vim.tbl_deep_extend('force', config, M.values)

  return M.values
end

M.extend = function(opts)
  if not opts then
    return M.values
  end

  return vim.tbl_deep_extend('force', M.values, opts)
end

return M
