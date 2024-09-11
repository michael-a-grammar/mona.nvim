return function(tests)
  local capitalise = function(str)
    return (str:gsub('^%l', string.upper))
  end

  local factory = function(directory_name, opts)
    opts = opts or {}

    local directory = require('mona.directories')[directory_name]()

    if not directory then
      return false
    end

    opts.prompt_title = ' '
      .. (opts.prompt_title or capitalise(directory_name))
      .. (tests and ' Tests' or ' Modules')

    opts.vimgrep_arguments =
      require('mona.ripgrep.args.elixir').modules(directory, tests)

    return require('telescope._extensions.mona.elixir.modules.picker')(opts)
  end

  return {
    project = function(opts)
      return factory('project', opts)
    end,

    application = function(opts)
      return factory('application', opts)
    end,

    buffer_directory = function(opts)
      opts = opts or {}

      opts.prompt_title = opts.prompt_title or 'Buffer Directory'

      return factory('buffer', opts)
    end,
  }
end
