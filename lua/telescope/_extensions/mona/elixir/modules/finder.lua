return function(opts)
  local finders = require('telescope.finders')

  opts.entry_maker = function(entry)
    local module = require('mona.ripgrep.results.elixir').module(entry)

    return {
      col = module.column_number,
      display = module.module_name,
      lnum = module.line_number,
      ordinal = module.module_name,
      path = module.path,
      value = entry,
    }
  end

  return finders.new_oneshot_job(opts.ripgrep_args, opts)
end
