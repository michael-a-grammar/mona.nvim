local M = {}

local assert_argument = require("mona.constructs.assert_argument")(...)

local ripgrep_default_args = require("mona.ripgrep.args.factory").defaults

function M.module(module_name, directory, test_module)
  assert_argument.multiple({
    { module_name, "module_name" },
    { directory, "directory" },
    { test_module, "test_module" },
  })

  return ripgrep_default_args(function(ripgrep)
    assert_argument(ripgrep, "ripgrep")

    return ripgrep
      .glob(test_module and "*_test.exs" or "*.ex")
      .replace(module_name)
      .regexp(string.format("defmodule %s do$", module_name))
      .insert(directory)
  end)
end

function M.modules(_, directory, test_modules)
  assert_argument.multiple({
    { directory, "directory" },
    { test_modules, "test_modules" },
  })

  return ripgrep_default_args(function(ripgrep)
    assert_argument(ripgrep, "ripgrep")

    return ripgrep
      .glob(test_modules and "*_test.exs" or "*.ex")
      .replace("$1")
      .regexp(
        string.format(
          "defmodule ([a-zA-Z0-9.]*%s) do$",
          test_modules and "Test" or ""
        )
      )
      .insert(directory)
  end)
end

return M
