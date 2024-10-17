local callable_table = require("mona.constructs.callable_table")
local message_formatter = require("mona.constructs.message_formatter")

return callable_table(function(mod_name)
  assert(mod_name)

  local M = callable_table(function(argument, argument_name, fn_name)
    assert(argument_name)

    local message =
      message_formatter(mod_name, "argument is nil or false", fn_name, {
        argument_name = argument_name,
      })

    assert(argument, message)
  end)

  function M.multiple(arguments_and_argument_names, fn_name)
    assert(arguments_and_argument_names)

    vim
      .iter(arguments_and_argument_names)
      :each(function(argument_and_argument_name)
        local argument = argument_and_argument_name[1]
        local argument_name = argument_and_argument_name[2]

        M(argument, argument_name, fn_name)
      end)
  end

  M.factory = callable_table(function(fn_name)
    assert(fn_name)

    return function(argument, argument_name)
      return M(argument, argument_name, fn_name)
    end
  end)

  function M.factory.multiple(fn_name)
    assert(fn_name)

    return function(arguments_and_argument_names)
      assert(arguments_and_argument_names)

      return M.multiple(arguments_and_argument_names, fn_name)
    end
  end

  return M
end)
