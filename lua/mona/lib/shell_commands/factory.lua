local callable_table = require("mona.constructs.callable_table")

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

local error = require("mona.constructs.error")(...)

return callable_table(function(opts)
  opts = opts or {}
  opts.name = opts.name or ""
  opts.options = opts.options or {}

  local M = {}

  local builder = require("mona.lib.shell_commands.builder")(opts.name)

  function M.insert(value)
    assert_argument_factory("insert")(value, "value")

    builder.insert(value)

    return M
  end

  function M.make(joined)
    if joined then
      return builder.join_values()
    end

    return builder.values()
  end

  vim.iter(opts.options):each(function(option)
    if not option.name then
      error("option requires a name")
    end

    local key = string.gsub(option.name, "%-", "_")

    if option.requires_arg then
      M[key] = function(arg)
        assert_argument_factory(key)(arg, "arg")

        builder.insert_option_with_arg(option.name, arg, option.prefix)

        return M
      end
    else
      M[key] = function()
        builder.insert_option(option.name, option.prefix)

        return M
      end
    end
  end)

  return M
end)
