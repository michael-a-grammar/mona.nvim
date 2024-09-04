return function(opts)
  local args = {}

  args.with_rg_command = function(self)
    table.insert(self, 1, 'rg')

    return self
  end

  local insert_arg = function(arg, exclude_prefix)
    local prefix = (exclude_prefix and '') or '--'

    table.insert(args, prefix .. arg)
  end

  local insert_if = function(condition, arg, exclude_prefix)
    if condition then
      insert_arg(arg, exclude_prefix)
    end
  end

  local insert_arg_with_value = function(arg)
    local key = string.gsub(arg, '-', '_')

    local arg_value = opts[key]

    insert_if(arg_value, arg)
    insert_if(arg_value, arg_value, true)
  end

  return {
    default = function()
      insert_arg('case-sensitive')
      insert_arg('trim')
      insert_arg('vimgrep')
      insert_arg('with-filename')
      insert_arg('word-regexp')

      insert_arg_with_value('glob')
      insert_arg_with_value('replace')
      insert_arg_with_value('regexp')

      insert_arg(opts.directory, true)

      return args
    end,
  }
end
