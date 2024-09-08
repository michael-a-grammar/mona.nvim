local M = {}

local capitalise = function(str)
  return (str:gsub('^%l', string.upper))
end

local modules = function(directory_name, prompt_title)
  prompt_title = prompt_title or capitalise(directory_name)

  local directory = require('mona.directories')[directory_name]()

  if not directory then
    return false
  end

  return require('mona.elixir.telescope.factories.modules')({
    prompt_title = ' ' .. prompt_title .. ' Modules',

    ripgrep_args = require('mona.ripgrep.args.elixir')
      .modules(directory)
      :with_rg_command(),
  })
end

M.project = function()
  return modules('project')
end

M.application = function()
  return modules('application')
end

M.buffer_directory = function()
  return modules('buffer', 'Buffer Directory')
end

return M
