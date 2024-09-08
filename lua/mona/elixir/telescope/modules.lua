return function(tests)
  local factory = function(directory_name, prompt_title)
    return require('mona.elixir.telescope.modules_factory')(
      directory_name,
      prompt_title,
      tests
    )
  end

  return {
    project = function()
      return factory('project')
    end,

    application = function()
      return factory('application')
    end,

    buffer_directory = function()
      return factory('buffer', 'Buffer Directory')
    end,
  }
end
