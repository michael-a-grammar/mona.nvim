return function(opts)
  if not opts then
    return false
  end

  local async_oneshot_finder = require('telescope.finders.async_oneshot_finder')

  local entry_maker =
    require('telescope._extensions.mona.elixir.modules.entry_maker')

  return async_oneshot_finder({
    fn_command = function()
      return {
        command = 'rg',
        args = opts.vimgrep_arguments,
      }
    end,

    entry_maker = entry_maker,
  })
end
