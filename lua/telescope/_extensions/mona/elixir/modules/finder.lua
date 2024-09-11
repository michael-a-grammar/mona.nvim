return function(opts)
  local async_oneshot_finder = require('telescope.finders.async_oneshot_finder')

  return async_oneshot_finder({
    fn_command = function()
      return {
        command = 'rg',
        args = opts.vimgrep_arguments,
      }
    end,

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
  })
end
