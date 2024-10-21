local M = {}

local Path = require("plenary.path")

local notify_factory = require("mona.notify")("directories")

local files = require("mona.files")
local utils = require("mona.utils")

local git_directory_name = _G.TEST and "_git" or ".git"

local function get_current_working_directory()
  return Path:new(vim.loop.cwd())
end

local function get_buffer_directory()
  local buffer_file = files.buffer()

  if not buffer_file then
    return false
  end

  local buffer_directory = Path:new(buffer_file):parent()

  return buffer_directory
end

local function get_child_directory(
  directory_fn,
  directory_name,
  child_directory_name,
  notify_message_prefix,
  notify
)
  notify = notify
    or notify_factory(directory_name .. "_" .. child_directory_name)

  local directory = directory_fn()

  if not directory then
    return false
  end

  local child_directory = Path:new({ directory, child_directory_name })

  if not utils.paths.exists(child_directory) then
    notify.warn(
      string.format(
        "%scan not find %s %s directory, %s directory: %s",
        notify_message_prefix,
        directory_name,
        child_directory_name,
        directory_name,
        directory
      )
    )
    return false
  end

  return child_directory.filename
end

local function get_lib_directory(directory_fn, directory_name)
  return get_child_directory(directory_fn, directory_name, "lib")
end

local function get_test_directory(directory_fn, directory_name)
  return get_child_directory(directory_fn, directory_name, "test")
end

function M.project()
  local notify = notify_factory("project")

  local current_working_directory = get_current_working_directory()

  local git_directory =
    current_working_directory:find_upwards(git_directory_name)

  if not utils.paths.exists(git_directory) then
    notify.warn(
      "can not find git directory, current working directory: "
        .. current_working_directory.filename
    )
    return false
  end

  local project_directory = git_directory:parent()
  local mix_file = Path:new({ project_directory, "mix.exs" })

  if not utils.paths.exists(mix_file) then
    notify.warn(
      "can not find mix.exs file, current working directory: "
        .. current_working_directory.filename
    )
    return false
  end

  return project_directory.filename
end

function M.application()
  local notify = notify_factory("application")

  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  local mix_file = buffer_directory:find_upwards("mix.exs")

  if not utils.paths.exists(mix_file) then
    notify.warn(
      "can not find mix.exs file, buffer directory: "
        .. buffer_directory.filename
    )
    return false
  end

  local application_directory = mix_file:parent().filename

  local project_directory = M.project()

  if not project_directory then
    return false
  end

  if application_directory == project_directory then
    notify.warn(
      "not within a umbrella application - "
        .. "located application directory matches the project directory, buffer directory: "
        .. buffer_directory.filename
    )
    return false
  end

  return application_directory
end

function M.applications()
  return get_child_directory(
    M.project,
    "project",
    "apps",
    "not within a umbrella application - ",
    notify_factory("applications")
  )
end

function M.project_lib()
  return get_lib_directory(M.project, "project")
end

function M.application_lib()
  return get_lib_directory(M.application, "application")
end

function M.project_test()
  return get_test_directory(M.project, "project")
end

function M.application_test()
  return get_test_directory(M.application, "application")
end

function M.buffer()
  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return false
  end

  return buffer_directory.filename
end

local mt = {
  __call = function(_)
    local directories = {
      application = M.application(),
      applications = M.applications(),
      application_lib = M.application_lib(),
      application_test = M.application_test(),
      buffer = M.buffer(),
      current_working_directory = get_current_working_directory().filename,
      project = M.project(),
      project_lib = M.project_lib(),
      project_test = M.project_test(),
    }

    for directory_name, directory_path in pairs(directories) do
      directories[directory_name] = {
        exists = utils.paths.exists(directory_path),
        path = directory_path,
      }
    end

    return directories
  end,
}

return setmetatable(M, mt)
