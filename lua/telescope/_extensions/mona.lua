local modules = require('mona.elixir.telescope.modules')(false)
local tests = require('mona.elixir.telescope.modules')(true)

return require('telescope').register_extension({
  exports = {
    elixir_project_modules = modules.project,

    elixir_application_modules = modules.application,

    elixir_buffer_directory_modules = modules.buffer_directory,

    elixir_project_tests = tests.project,

    elixir_application_tests = tests.application,

    elixir_buffer_directory_tests = tests.buffer_directory,
  },
})
