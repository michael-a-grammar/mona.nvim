local callable_table = require("mona.constructs.callable_table")

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

return callable_table(function(shell_command_name)
  local M, values = {}, {}

  function M.insert(value)
    assert_argument_factory("insert")(value, "value")

    table.insert(values, value)

    return M
  end

  function M.insert_option(option, prefix)
    assert_argument_factory("insert_option")(option, "option")

    prefix = prefix or require("mona.lib.shell_commands.option_prefixes").none

    return M.insert(prefix .. option)
  end

  function M.insert_option_with_arg(option, arg, prefix)
    assert_argument_factory.multiple("insert_option_with_arg")({
      { option, "option" },
      { arg, "arg" },
    })

    M.insert_option(option, prefix)

    return M.insert(arg)
  end

  function M.values()
    return values
  end

  function M.join_values()
    return vim.iter(values):join(" ")
  end

  if shell_command_name and shell_command_name ~= "" then
    M.insert(shell_command_name)
  end

  return M
end)
