return function(opts)
  local pickers = require('telescope.pickers')

  local finder = require('telescope._extensions.mona.elixir.modules.finder')
  local config = require('telescope._extensions.mona.config')

  local config_values = config.extend(opts)

  config_values.finder = finder(config_values)

  if config_values.theme then
    config_values =
      require('telescope.themes')['get_' .. config_values.theme](config_values)
  end

  return pickers
    :new(config_values, {
      previewer = config_values.grep_previewer(config_values),
      sorter = config_values.generic_sorter(config_values),
    })
    :find()
end
