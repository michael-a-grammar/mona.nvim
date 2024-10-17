describe("mona.lib.ripgrep.shell_commands", function()
  it("should throw an error if builder_fn is nil", function()
    assert.has_error(function()
      require("mona.lib.ripgrep.shell_commands")(nil)
    end)
  end)

  it("should return a table", function()
    local values = require("mona.lib.ripgrep.shell_commands")(function(ripgrep)
      ripgrep.case_sensitive().trim().with_filename().word_regexp().vimgrep()
    end)

    local expected_values = {
      "--case-sensitive",
      "--trim",
      "--with-filename",
      "--word-regexp",
      "--vimgrep",
    }

    assert.same(expected_values, values)
  end)

  describe("defaults", function()
    it("should throw an error if builder_fn is nil", function()
      assert.has_error(function()
        require("mona.lib.ripgrep.shell_commands").defaults(nil)
      end)
    end)

    it("should return a table", function()
      local values = require("mona.lib.ripgrep.shell_commands").defaults(
        function(ripgrep)
          ripgrep
            .glob("*.ex")
            .replace("$1")
            .regexp("defmodule ([a-zA-Z0-9.]*) do$")
        end
      )

      local expected_values = {
        "--case-sensitive",
        "--trim",
        "--with-filename",
        "--word-regexp",
        "--vimgrep",
        "--glob",
        "*.ex",
        "--replace",
        "$1",
        "--regexp",
        "defmodule ([a-zA-Z0-9.]*) do$",
      }

      assert.same(expected_values, values)
    end)
  end)
end)
