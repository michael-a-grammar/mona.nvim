local M = {}

local mt = {
  __call = function(_, opts)
    opts = opts or {}

    local directories = {}

    local git_directory_name = opts.git_directory_name or ".git"
    local mix_file_name = opts.mix_file_name or "mix.exs"

    local Path = require("plenary.path")

    local notify_factory = require("mona.notify")("directories")

    local files = require("mona.files")
    local utils = require("mona.utils")

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

    function directories.project()
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
      local mix_file = Path:new({ project_directory, mix_file_name })

      if not utils.paths.exists(mix_file) then
        notify.warn(
          "can not find mix.exs file, current working directory: "
            .. current_working_directory.filename
        )
        return false
      end

      return project_directory.filename
    end

    function directories.application()
      local notify = notify_factory("application")

      local buffer_directory = get_buffer_directory()

      if not buffer_directory then
        return false
      end

      local mix_file = buffer_directory:find_upwards(mix_file_name)

      if not utils.paths.exists(mix_file) then
        notify.warn(
          "can not find mix.exs file, buffer directory: "
            .. buffer_directory.filename
        )
        return false
      end

      local application_directory = mix_file:parent().filename

      local project_directory = directories.project()

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

    function directories.applications()
      return get_child_directory(
        directories.project,
        "project",
        "apps",
        "not within a umbrella application - ",
        notify_factory("applications")
      )
    end

    function directories.project_lib()
      return get_lib_directory(directories.project, "project")
    end

    function directories.application_lib()
      return get_lib_directory(directories.application, "application")
    end

    function directories.project_test()
      return get_test_directory(directories.project, "project")
    end

    function directories.application_test()
      return get_test_directory(directories.application, "application")
    end

    function directories.buffer()
      local buffer_directory = get_buffer_directory()

      if not buffer_directory then
        return false
      end

      return buffer_directory.filename
    end

    local directories_mt = {
      __call = function(_)
        local directory_paths = {
          application = directories.application(),
          applications = directories.applications(),
          application_lib = directories.application_lib(),
          application_test = directories.application_test(),
          buffer = directories.buffer(),
          current_working_directory = get_current_working_directory().filename,
          project = directories.project(),
          project_lib = directories.project_lib(),
          project_test = directories.project_test(),
        }

        for directory_name, directory_path in pairs(directory_paths) do
          directories[directory_name] = {
            exists = utils.paths.exists(directory_path),
            path = directory_path,
          }
        end

        return directory_paths
      end,
    }

    return setmetatable(directories, directories_mt)
  end,
}

return setmetatable(M, mt)
