return require('telescope').register_extension({
  exports = {
    elixir_project_modules = require('mona.elixir.telescope.project_modules'),
  },
})
