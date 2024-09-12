local M = {}

_G._TelescopeMonaConfig = _G._TelescopeMonaConfig or {}
_G._TelescopeMonaPickers = _G._TelescopeMonaPickers or {}

M.values = _G._TelescopeMonaConfig
M.included_pickers = _G._TelescopeMonaPickers

M.included_pickers_name = 'pickers'

local deep_extend_tables = function(table1, table2)
  return vim.tbl_deep_extend('force', table1, table2)
end

local deep_copy_config_values = function()
  return vim.deepcopy(M.values)
end

local extend_config_values = function(opts)
  if not opts then
    return
  end

  M.values = deep_extend_tables(M.values, opts)
end

local get_theme_config = function()
  return require('telescope.themes')['get_' .. M.values.theme]()
end

M.setup = function(ext_config, config)
  extend_config_values(config)
  extend_config_values(ext_config)

  return M
end

M.merge = function(opts)
  local config

  if M.values.theme then
    local theme_config = get_theme_config()

    config = deep_extend_tables(M.values, theme_config)
  else
    config = deep_copy_config_values()
  end

  return deep_extend_tables(config, opts)
end

M.register_included_pickers = function(pickers)
  for picker_name, picker in pairs(pickers) do
    if picker_name ~= M.included_pickers_name then
      table.insert(M.included_pickers, {
        picker_name,
        picker,
      })
    end
  end
end

return M
