local Path = require('plenary.path')

local M = {}

local cwd = function()
  return Path:new(vim.fn.getcwd())
end

M.project_directory = function()
  local path = cwd()

  local git_path = path:find_upwards('.git')

  if git_path == nil then
    return false
  end

  local project_path = git_path:parent()
  local mix_path = Path:new(project_path.filename .. '/mix.exs')

  if not mix_path:exists() then
    return false
  end

  return project_path.filename
end

return M
