local M = {}

local modules = function(directory_name)
  local directory = require('mona.directories')[directory_name]()

  if not directory then
    return false
  end

  return require('mona.elixir.telescope.factories.modules')({
    prompt_title = ' ' .. directory_name .. ' Modules',

    ripgrep_args = require('mona.ripgrep.args.elixir')
      .modules(directory)
      :with_rg_command(),
  })
end

M.project = function()
  return modules('project')
end

M.app = function()
  return modules('app')
end

M.buffer = function()
  return modules('buffer')
end

return M
