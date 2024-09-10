return function(tests)
  local factory = function(directory_name, opts, prompt_title)
    opts = opts or {}

    opts.directory_name = directory_name
    opts.prompt_title = prompt_title
    opts.tests = tests

    return require('telescope._extensions.mona.elixir.modules.factory')(opts)
  end

  return {
    project = function(opts)
      return factory('project', opts)
    end,

    application = function(opts)
      return factory('application', opts)
    end,

    buffer_directory = function(opts)
      return factory('buffer', opts, 'Buffer Directory')
    end,
  }
end
