local M

local config = require("telescope._extensions.mona.config")

local picker_names = require("telescope._extensions.mona.config.picker_names")

local picker_groups = require("telescope._extensions.mona.config.picker_groups")

local included_pickers_picker =
  require("telescope._extensions.mona.included_pickers.picker")

local elixir_modules_factory =
  require("telescope._extensions.mona.elixir.modules.factory")

local function wrap_pickers(pickers, picker_group_name)
  for picker_name, picker in pairs(pickers) do
    M[picker_name] = function(opts)
      opts = opts or {}

      opts.picker_name = picker_name
      opts.picker_group_name = picker_group_name

      picker(opts)
    end
  end
end

local module_pickers = {
  elixir_project_modules = elixir_modules_factory.project,
  elixir_umbrella_app_modules = elixir_modules_factory.umbrella_app,
  elixir_buffer_directory_modules = elixir_modules_factory.buffer_directory,
}

local test_module_pickers = {
  -- TODO: Rename to `test_modules`
  elixir_project_tests = elixir_modules_factory.tests.project,
  elixir_umbrella_app_tests = elixir_modules_factory.tests.umbrella_app,
  elixir_buffer_directory_tests = elixir_modules_factory.tests.buffer_directory,
  elixir_test_modules = elixir_modules_factory.test_modules,
}

local other_pickers = {
  [picker_names.included_pickers] = included_pickers_picker,
}

wrap_pickers(module_pickers, picker_groups.modules)
wrap_pickers(test_module_pickers, picker_groups.test_modules)
wrap_pickers(other_pickers, picker_groups.other)

config.register_included_pickers(M)

return M
