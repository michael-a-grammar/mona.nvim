local M = {}

local function defaults()
  M.included_pickers_name = "pickers"

  _G._TelescopeMonaConfig = _G._TelescopeMonaConfig
    or require("telescope._extensions.mona.config.defaults")(
      M.included_pickers_name
    )

  _G._TelescopeMonaPickers = _G._TelescopeMonaPickers or {}

  M.values = _G._TelescopeMonaConfig
  M.included_pickers = _G._TelescopeMonaPickers

  return M
end

local function deep_extend_tables(table1, table2)
  return vim.tbl_deep_extend("force", table1, table2)
end

local function extend_config_values(opts)
  if not opts then
    return false
  end

  M.values = deep_extend_tables(M.values, opts)
end

local function get_theme_config(picker_opts, picker_config, config)
  local theme

  for _, opts in ipairs({ config, picker_config, picker_opts }) do
    if opts and opts.theme then
      theme = opts.theme
    end
  end

  if theme then
    local themes = require("telescope.themes")

    local theme_fn = themes["get_" .. theme]

    if theme_fn then
      return theme_fn()
    end
  end

  return {}
end

function M.extend(extension_config, user_config)
  extend_config_values(user_config)
  extend_config_values(extension_config)

  _G._TelescopeMonaConfig = M.values

  return M
end

function M.merge(opts)
  opts = opts or {}

  local picker_config

  if opts.picker_name and M.values.pickers then
    picker_config = M.values.pickers[opts.picker_name] or {}
  else
    picker_config = {}
  end

  local theme_config = get_theme_config(opts, picker_config, M.values)

  local config = deep_extend_tables(
    deep_extend_tables(
      deep_extend_tables(M.values, picker_config),
      theme_config
    ),
    opts
  )

  return config
end

function M.register_included_pickers(pickers)
  for picker_name, picker in pairs(pickers) do
    if picker_name ~= M.included_pickers_name then
      table.insert(M.included_pickers, {
        picker_name,
        picker,
      })
    end
  end

  return M.included_pickers
end

function M.reset()
  _G._TelescopeMonaConfig = nil
  _G._TelescopeMonaPickers = nil

  defaults()
end

defaults()

return M
