return function(opts)
  local config = require('telescope.config')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')

  local config_values = config.values

  return pickers
    :new({
      prompt_title = opts.prompt_title,

      finder = finders.new_oneshot_job(
        opts.ripgrep_args,
        {
          entry_maker = function(entry)
            local module = require('mona.ripgrep.results.elixir').module(entry)

            return {
              col = module.column_number,
              display = module.module_name,
              lnum = module.line_number,
              ordinal = module.module_name,
              path = module.path,
              value = entry,
            }
          end,
        }
      ),

      previewer = config_values.grep_previewer({}),
      sorter = config_values.generic_sorter({}),
    })
    :find()
end
