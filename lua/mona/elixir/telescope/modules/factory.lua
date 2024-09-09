local capitalise = function(str)
  return (str:gsub('^%l', string.upper))
end

return function(directory_name, prompt_title, tests)
  prompt_title = ' '
    .. (prompt_title or capitalise(directory_name))
    .. (tests and ' Tests' or ' Modules')

  local directory = require('mona.directories')[directory_name]()

  if not directory then
    return false
  end

  return require('mona.elixir.telescope.modules.picker')({
    prompt_title = prompt_title,

    ripgrep_args = require('mona.ripgrep.args.elixir')
      .modules(directory, tests)
      :with_rg_command(),
  })
end
