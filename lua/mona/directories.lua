local Path = require('plenary.path')

local M = {}

local git_directory_name = _G.TEST and '_git' or '.git'

local get_current_working_directory = function()
  return Path:new(vim.fn.getcwd())
end

local get_buffer_directory = function()
  local bufname_path = Path:new(vim.fn.bufname()):parent()

  if not bufname_path:exists() then
    return false
  end

  return bufname_path
end

M.project = function()
  local current_working_directory = get_current_working_directory()

  local git_path = current_working_directory:find_upwards(git_directory_name)

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

M.application = function()
  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  local mix_path = buffer_directory:find_upwards('mix.exs')

  if not mix_path or not mix_path:exists() then
    return false
  end

  local application_directory = mix_path:parent().filename

  local project_directory = M.project()

  if application_directory == project_directory then
    return false
  end

  return application_directory
end

M.buffer = function()
  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  return buffer_directory.filename
end

return M
