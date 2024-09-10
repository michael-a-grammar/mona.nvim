local config = require('telescope._extensions.mona.config')

local factory = function(tests)
  return require('telescope._extensions.mona.elixir.modules')(tests)
end

local modules = factory(false)
local tests = factory(true)

return require('telescope').register_extension({
  setup = config.setup,

  exports = {
    elixir_project_modules = modules.project,

    elixir_application_modules = modules.application,

    elixir_buffer_directory_modules = modules.buffer_directory,

    elixir_project_tests = tests.project,

    elixir_application_tests = tests.application,

    elixir_buffer_directory_tests = tests.buffer_directory,
  },
})
