local callable_table = require("mona.constructs.callable_table")

local assert_argument = require("mona.constructs.assert_argument")(...)

local M = callable_table(function(builder_fn)
  assert_argument(builder_fn, "builder_fn")

  local option_prefixes = require("mona.lib.shell_commands.option_prefixes")

  local factory = require("mona.lib.shell_commands.factory")({
    options = {
      {
        name = "case-sensitive",
        prefix = option_prefixes.long,
      },

      {
        name = "trim",
        prefix = option_prefixes.long,
      },

      {
        name = "with-filename",
        prefix = option_prefixes.long,
      },

      {
        name = "word-regexp",
        prefix = option_prefixes.long,
      },

      {
        name = "vimgrep",
        prefix = option_prefixes.long,
      },

      {
        name = "glob",
        requires_arg = true,
        prefix = option_prefixes.long,
      },

      {
        name = "regexp",
        requires_arg = true,
        prefix = option_prefixes.long,
      },

      {
        name = "replace",
        requires_arg = true,
        prefix = option_prefixes.long,
      },
    },
  })

  builder_fn(factory)

  return factory.make()
end)

function M.defaults(builder_fn)
  assert_argument.factory("defaults")(builder_fn, "builder_fn")

  return M(function(ripgrep)
    assert_argument(ripgrep, "ripgrep")

    return builder_fn(
      ripgrep.case_sensitive().trim().with_filename().word_regexp().vimgrep()
    )
  end)
end

return M
