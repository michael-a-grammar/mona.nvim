return function(opts)
  opts = opts or {}

  local pickers = require('telescope.pickers')
  local config = require('telescope._extensions.mona.config')
  local finder = require('telescope._extensions.mona.elixir.modules.finder')

  local final_opts = (function()
    if config.values.theme then
      local theme = require('telescope.themes')['get_' .. config.values.theme]()

      return vim.tbl_deep_extend('force', config.values, theme)
    end

    return vim.deepcopy(config.values)
  end)()

  final_opts = vim.tbl_deep_extend('force', final_opts, opts)

  return pickers
    .new(final_opts, {
      finder = finder(final_opts),
      previewer = config.values.grep_previewer(final_opts),
      sorter = config.values.file_sorter(final_opts),
    })
    :find()
end
