local M = {}

local config = require('telescope._extensions.mona.config')

local included_pickers = require('telescope._extensions.mona.included_pickers')
local modules_factory = require('telescope._extensions.mona.elixir.modules')

local modules = modules_factory(false)
local tests = modules_factory(true)

M = {
  elixir_project_modules = modules.project,
  elixir_application_modules = modules.application,
  elixir_buffer_directory_modules = modules.buffer_directory,
  elixir_project_tests = tests.project,
  elixir_application_tests = tests.application,
  elixir_buffer_directory_tests = tests.buffer_directory,

  [config.included_pickers_name] = included_pickers,
}

config.register_included_pickers(M)

return M
