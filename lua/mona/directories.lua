local M = {}

local mod_name, _ = ...

return setmetatable({}, {
  __call = function(_, opts)
    opts = opts or {}

    local git_directory_name = opts.git_directory_name or ".git"

    local mix_file_name = opts.mix_file_name or "mix.exs"

    local Path = require("plenary.path")

    local notify_factory = require("mona.notify").factory(mod_name)

    local files = require("mona.files")

    local utils = require("mona.utils")

    local function get_working_directory()
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
      if not notify_message_prefix then
        notify_message_prefix = ""
      end

      local directory = directory_fn()

      if not directory then
        return false
      end

      notify = notify
        or notify_factory(directory_name .. "_" .. child_directory_name)

      local child_directory = Path:new({ directory, child_directory_name })

      if not utils.paths.exists(child_directory) then
        notify(
          string.format(
            "%scan not find %s %s directory",
            notify_message_prefix,
            directory_name,
            child_directory_name
          ),
          {
            directory = directory,
          }
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

      local working_directory = get_working_directory()

      local git_directory = working_directory:find_upwards(git_directory_name)

      if not utils.paths.exists(git_directory) then
        notify("can not find git directory", {
          current_working_directory = working_directory.filename,
        })
        return false
      end

      local project_directory = git_directory:parent()

      local mix_file = Path:new({ project_directory, mix_file_name })

      if not utils.paths.exists(mix_file) then
        notify("can not find mix.exs file", {
          current_working_directory = working_directory.filename,
        })
        return false
      end

      return project_directory.filename
    end

    function M.umbrella_app()
      local buffer_directory = get_buffer_directory()

      if not buffer_directory then
        return false
      end

      local notify = notify_factory("apps")

      local mix_file = buffer_directory:find_upwards(mix_file_name)

      if not utils.paths.exists(mix_file) then
        notify("can not find mix.exs file", {
          buffer_directory = buffer_directory.filename,
        })
        return false
      end

      local umbrella_app_directory = mix_file:parent().filename

      local project_directory = M.project()

      if not project_directory then
        return false
      end

      if umbrella_app_directory == project_directory then
        notify(
          "not within a umbrella app - "
            .. "located app directory matches the project directory",
          {
            buffer_directory = buffer_directory.filename,
          }
        )
        return false
      end

      return umbrella_app_directory
    end

    function M.umbrella_apps()
      return get_child_directory(
        M.project,
        "project",
        "apps",
        "not within a umbrella app - ",
        notify_factory("umbrella_apps")
      )
    end

    function M.project_lib()
      return get_lib_directory(M.project, "project")
    end

    function M.umbrella_app_lib()
      return get_lib_directory(M.umbrella_apps, "umbrella_app")
    end

    function M.project_test()
      return get_test_directory(M.project, "project")
    end

    function M.umberlla_app_test()
      return get_test_directory(M.umbrella_apps, "app")
    end

    function M.buffer()
      local buffer_directory = get_buffer_directory()

      if not buffer_directory then
        return false
      end

      return buffer_directory.filename
    end

    function M.is_within_umbrella_app()
      local buffer_file = files.buffer()

      if not buffer_file then
        return false
      end

      local working_directory = get_working_directory().filename

      local applications_directory = working_directory .. "/apps/"

      return string.match(buffer_file, applications_directory) ~= nil
    end

    return setmetatable(M, {
      __call = function(_)
        local directories = {
          app = M.umbrella_app(),
          apps = M.umbrella_apps(),
          app_lib = M.umbrella_app_lib(),
          app_test = M.umberlla_app_test(),
          buffer = M.buffer(),
          working_directory = get_working_directory().filename,
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

        directories.is_within_umbrella_app = M.is_within_umbrella_app()

        return directories
      end,
    })
  end,
})
