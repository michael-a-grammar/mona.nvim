local capitalise = function(str)
  return (str:gsub('^%l', string.upper))
end

return function(opts)
  if not opts then
    return false
  end

  local directory = require('mona.directories')[opts.directory_name]()

  if not directory then
    return false
  end

  opts.prompt_title = ' '
    .. (opts.prompt_title or capitalise(opts.directory_name))
    .. (opts.tests and ' Tests' or ' Modules')

  opts.ripgrep_args = require('mona.ripgrep.args.elixir')
    .modules(directory, opts.tests)
    :with_rg_command()

  return require('telescope._extensions.mona.elixir.modules.picker')(opts)
end
