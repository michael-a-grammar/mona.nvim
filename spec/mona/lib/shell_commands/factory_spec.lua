describe("mona.lib.shell_commands.factory", function()
  local option_prefixes = require("mona.lib.shell_commands.option_prefixes")

  it("should not throw an error if opts is nil", function()
    assert.has_no_error(function()
      require("mona.lib.shell_commands.factory")(nil)
    end)
  end)

  it("should insert the opts name", function()
    local factory = require("mona.lib.shell_commands.factory")({
      name = "name",
    })

    local shell_commands = factory.make(true)

    assert.same("name", shell_commands)
  end)

  describe("insert", function()
    it("should throw an error if value is nil", function()
      local factory = require("mona.lib.shell_commands.factory")({
        name = "name",
      })

      assert.has_error(function()
        factory.insert(nil)
      end)
    end)

    it("should insert value", function()
      local factory = require("mona.lib.shell_commands.factory")({
        name = "name",
      })

      local shell_commands = factory.insert("value").make()

      local expected_shell_commands = {
        "name",
        "value",
      }

      assert.same(expected_shell_commands, shell_commands)
    end)
  end)

  describe("make", function()
    it(
      "should return an empty table if no values have been inserted and joined is falsy",
      function()
        local factory = require("mona.lib.shell_commands.factory")()

        local shell_commands = factory.make()

        assert.same({}, shell_commands)
      end
    )

    it(
      "should return an empty string if no values have been inserted and joined is truthy",
      function()
        local factory = require("mona.lib.shell_commands.factory")()

        local shell_commands = factory.make(true)

        assert.same("", shell_commands)
      end
    )

    it("should return a table if joined is falsy", function()
      local factory = require("mona.lib.shell_commands.factory")({
        name = "name",
      })

      local shell_commands = factory.insert("value").make()

      local expected_shell_commands = {
        "name",
        "value",
      }

      assert.same(expected_shell_commands, shell_commands)
    end)

    it(
      "should return values joined as a string, seperated by a space if joined is truthy",
      function()
        local factory = require("mona.lib.shell_commands.factory")({
          name = "name",
        })

        local shell_commands = factory.insert("value").make(true)

        assert.same("name value", shell_commands)
      end
    )
  end)

  describe("dynamically created functions", function()
    it("should throw an error if a opts option name is nil", function()
      assert.has_error(function()
        local factory = require("mona.lib.shell_commands.factory")({
          options = {
            {},
          },
        })
      end)
    end)

    it("should create a function for each opts option name", function()
      local factory = require("mona.lib.shell_commands.factory")({
        options = {
          {
            name = "shell_command_1",
          },

          {
            name = "shell_command_2",
          },

          {
            name = "shell_command_3",
          },
        },
      })

      assert.is_function(factory.shell_command_1)
      assert.is_function(factory.shell_command_2)
      assert.is_function(factory.shell_command_3)
    end)

    it("should normalise created function names", function()
      local factory = require("mona.lib.shell_commands.factory")({
        options = {
          {
            name = "shell-command-1",
          },
        },
      })

      assert.is_function(factory.shell_command_1)
    end)

    describe("dynamically created function", function()
      it("should throw an error if opts option require_arg is true and arg is nil", function()
        local factory = require("mona.lib.shell_commands.factory")({
          options = {
            {
              name = "shell-command-1",
              prefix = option_prefixes.long,
            },

            {
              name = "shell-command-2",
              prefix = option_prefixes.short,
            },

            {
              name = "shell_command_3",
              requires_arg = true,
              prefix = option_prefixes.none,
            },
          },
        })

        factory.shell_command_1()
        factory.shell_command_2()

        assert.has_error(function()
          factory.shell_command_3(nil)
        end)
      end)

      it("should insert name of opts option", function()
        local factory = require("mona.lib.shell_commands.factory")({
          options = {
            {
              name = "shell-command-1",
            },

            {
              name = "shell-command-2",
            },

            {
              name = "shell_command_3",
            },
          },
        })

        factory.shell_command_1()
        factory.shell_command_2()
        factory.shell_command_3()

        local shell_commands = factory.make()

        local expected_shell_commands = {
          "shell-command-1",
          "shell-command-2",
          "shell_command_3",
        }

        assert.same(expected_shell_commands, shell_commands)
      end)

      it("should insert prefix of opts option", function()
        local factory = require("mona.lib.shell_commands.factory")({
          options = {
            {
              name = "shell-command-1",
              prefix = option_prefixes.long,
            },

            {
              name = "shell-command-2",
              prefix = option_prefixes.short,
            },

            {
              name = "shell_command_3",
              prefix = option_prefixes.none,
            },
          },
        })

        factory.shell_command_1()
        factory.shell_command_2()
        factory.shell_command_3()

        local shell_commands = factory.make()

        local expected_shell_commands = {
          "--shell-command-1",
          "-shell-command-2",
          "shell_command_3",
        }

        assert.same(expected_shell_commands, shell_commands)
      end)

      it("should insert arg if opts option require_arg is true", function()
        local factory = require("mona.lib.shell_commands.factory")({
          options = {
            {
              name = "shell-command-1",
              prefix = option_prefixes.long,
            },

            {
              name = "shell-command-2",
              prefix = option_prefixes.short,
            },

            {
              name = "shell_command_3",
              requires_arg = true,
              prefix = option_prefixes.none,
            },
          },
        })

        factory.shell_command_1()
        factory.shell_command_2()
        factory.shell_command_3("shell command 3 arg")

        local shell_commands = factory.make()

        local expected_shell_commands = {
          "--shell-command-1",
          "-shell-command-2",
          "shell_command_3",
          "shell command 3 arg",
        }

        assert.same(expected_shell_commands, shell_commands)
      end)
    end)
  end)
end)
