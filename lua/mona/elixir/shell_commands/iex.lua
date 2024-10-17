local callable_table = require("mona.constructs.callable_table")

local assert_argument = require("mona.constructs.assert_argument")(...)

return callable_table(function(builder_fn)
  assert_argument(builder_fn, "builder_fn")

  local option_prefixes = require("mona.shell_commands.option_prefixes")

  local factory = require("mona.shell_commands.factory")({
    name = "iex",

    options = {
      {
        name = "r",
        requires_arg = true,
        prefix = option_prefixes.short,
      },

      {
        name = "S",
        requires_arg = true,
        prefix = option_prefixes.short,
      },
    },
  })

  builder_fn(factory)

  return factory.make(true)
end)
