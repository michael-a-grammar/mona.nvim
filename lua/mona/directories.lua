local Path = require('plenary.path')

local M = {}

local get_current_working_directory = function()
  if true then
    return Path:new(Path:new('~/crash'):expand())
  else
    return Path:new(vim.fn.getcwd())
  end
end

local get_buffer_directory = function()
  local bufname_path = Path:new(vim.fn.bufname())

  if not bufname_path.exists() then
    return false
  end

  return bufname_path
end

M.project = function()
  local current_working_directory = get_current_working_directory()

  local git_path = current_working_directory:find_upwards('.git')

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

M.app = function()
  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  local mix_path = buffer_directory:find_upwards('mix.exs')

  if not mix_path:exists() then
    return false
  end

  local project_directory = M.project_directory()

  if mix_path.filename == project_directory then
    return false
  end

  return mix_path.filename
end

M.buffer = function()
  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  return buffer_directory.filename
end

return M
