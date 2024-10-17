local M = {}

local function set_defaults()
  if not _G._TelescopeMonaConfig then
    local picker_names =
      require("telescope._extensions.mona.config.picker_names")

    local picker_groups =
      require("telescope._extensions.mona.config.picker_groups")

    _G._TelescopeMonaConfig = require(
      "telescope._extensions.mona.config.defaults"
    )(picker_names, picker_groups)
  end

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

local function get_theme_config(
  picker_opts,
  picker_config,
  picker_group_config,
  config
)
  local theme

  for _, opts in ipairs({
    config,
    picker_group_config,
    picker_config,
    picker_opts,
  }) do
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

  local function get_picker_config(opt_and_config_group_fn)
    local opt, config_group = opt_and_config_group_fn()

    if opt and config_group then
      return config_group[opt] or {}
    else
      return {}
    end
  end

  local picker_group_config = get_picker_config(function()
    return opts.picker_group_name, M.values.picker_groups
  end)

  local picker_config = get_picker_config(function()
    return opts.picker_name, M.values.picker
  end)

  local theme_config =
    get_theme_config(opts, picker_config, picker_group_config, M.values)

  local merged_config = M.values

  for _, config in ipairs({
    picker_group_config,
    picker_config,
    theme_config,
    opts,
  }) do
    merged_config = deep_extend_tables(merged_config, config)
  end

  return merged_config
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

  set_defaults()
end

set_defaults()

return M
