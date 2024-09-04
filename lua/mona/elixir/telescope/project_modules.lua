return function()
  local project_directory = require('mona.directories').project_directory()

  if not project_directory then
    return false
  end

  local config = require('telescope.config')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')

  local config_values = config.values

  return pickers
    :new({
      prompt_title = ' Project Modules',

      finder = finders.new_oneshot_job(
        require('mona.ripgrep.args.elixir')
          .project_modules(project_directory)
          :with_rg_command(),
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
