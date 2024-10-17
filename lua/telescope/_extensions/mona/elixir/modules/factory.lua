local M = {
  tests = {},
}

local mod_name, _ = ...

local function modules_vimgrep_arguments(directory, test_modules)
  return require("mona.ripgrep.args.elixir.modules")(directory, test_modules)
end

local function module_vimgrep_arguments(module_name)
  return function(directory, test_modules)
    return require("mona.ripgrep.args.elixir.module")(
      module_name,
      directory,
      test_modules
    )
  end
end

local function make(
  directory_name,
  directory_fn,
  vimgrep_arguments_fn,
  test_modules,
  opts
)
  opts = opts or {}

  local notify = require("mona.notify")(mod_name)

  local directories = require("mona.paths.directories")()

  local directory = directory_fn(directories)

  if not directory then
    notify("can not find directory", {
      directory_name = directory_name,
    })
    return false
  end

  local title = require("mona.config").prefix_with_icon(
    "elixir",
    (opts.prompt_title or directory_name)
  )

  local title_suffix = test_modules and " Tests" or " Modules"

  opts.prompt_title = title .. title_suffix

  opts.vimgrep_arguments = vimgrep_arguments_fn(directory, test_modules)

  return require("telescope._extensions.mona.elixir.modules.picker")(opts)
end

local function project_modules(test_modules, opts)
  return make("Project", function(directories)
    return directories.project()
  end, modules_vimgrep_arguments, test_modules, opts)
end

local function umbrella_app_modules(test_modules, opts)
  return make("Umbrella App", function(directories)
    return directories.umbrella_app()
  end, modules_vimgrep_arguments, test_modules, opts)
end

local function buffer_directory_modules(test_modules, opts)
  return make("Buffer Directory", function(directories)
    return directories.buffer()
  end, modules_vimgrep_arguments, test_modules, opts)
end

local function modules_or_test_modules(test_modules, opts)
  local module_name = require("mona.elixir.module").name({
    append_test = not test_modules,
    remove_test = test_modules,
  })

  if not module_name then
    return false
  end

  local is_within_umbrella_app =
    require("mona.paths.directories")().is_within_umbrella_app()

  local directory_name = is_within_umbrella_app and "Umbrella App" or "Project"

  local directory_fn = function(directories)
    return is_within_umbrella_app and directories.umbrella_app()
      or directories.project()
  end

  local vimgrep_arguments_fn = module_vimgrep_arguments(module_name)

  return make(
    directory_name,
    directory_fn,
    vimgrep_arguments_fn,
    not test_modules,
    opts
  )
end

local function test_modules_from_module(opts)
  return modules_or_test_modules(false, opts)
end

local function modules_from_test_module(opts)
  return modules_or_test_modules(true, opts)
end

for key, value in pairs({
  project = project_modules,
  umbrella_app = umbrella_app_modules,
  buffer_directory = buffer_directory_modules,
}) do
  ---@diagnostic disable-next-line: assign-type-mismatch
  M[key] = function(opts)
    return value(false, opts)
  end

  M.tests[key] = function(opts)
    return value(true, opts)
  end
end

function M.test_modules(opts)
  local elixir_module = require("mona.elixir.module")

  if elixir_module.is_module() then
    return test_modules_from_module(opts)
  elseif elixir_module.is_test_module() then
    return modules_from_test_module(opts)
  end

  return false
end

return M
