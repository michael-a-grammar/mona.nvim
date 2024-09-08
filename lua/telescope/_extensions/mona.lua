return require('telescope').register_extension({
  exports = {
    elixir_project_modules = require('mona.elixir.telescope.modules').project,

    elixir_application_modules = require('mona.elixir.telescope.modules').application,

    elixir_buffer_directory_modules = require('mona.elixir.telescope.modules').buffer_directory,
  },
})
