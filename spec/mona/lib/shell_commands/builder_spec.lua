describe("mona.lib.shell_commands.builder", function()
  local option_prefixes = require("mona.lib.shell_commands.option_prefixes")

  it("should not throw an error if shell_command_name is nil", function()
    assert.has_no_error(function()
      require("mona.lib.shell_commands.builder")(nil)
    end)
  end)

  it("should insert shell_command_name", function()
    local builder =
      require("mona.lib.shell_commands.builder")("shell_command_name")

    local values = builder.values()

    local expected_values = {
      "shell_command_name",
    }

    assert.same(expected_values, values)
  end)

  describe("insert", function()
    it("should throw an error if value is nil", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      assert.has_error(function()
        builder.insert(nil)
      end)
    end)

    it("should insert value", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      local values = builder.insert("value").values()

      local expected_values = {
        "shell_command_name",
        "value",
      }

      assert.same(expected_values, values)
    end)
  end)

  describe("insert_option", function()
    it("should throw an error if option is nil", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      assert.has_error(function()
        builder.insert_option(nil, option_prefixes.long)
      end)
    end)

    it(
      "should insert option and not throw an error if prefix is nil",
      function()
        local builder =
          require("mona.lib.shell_commands.builder")("shell_command_name")

        local values = builder.insert_option("option", nil).values()

        local expected_values = {
          "shell_command_name",
          "option",
        }

        assert.same(expected_values, values)
      end
    )

    it("should insert prefix and option", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      local values =
        builder.insert_option("option", option_prefixes.long).values()

      local expected_values = {
        "shell_command_name",
        "--option",
      }

      assert.same(expected_values, values)
    end)
  end)

  describe("insert_option_with_arg", function()
    it("should throw an error if option is nil", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      assert.has_error(function()
        builder.insert_option_with_arg(nil, "arg", option_prefixes.long)
      end)
    end)

    it("should throw an error if arg is nil", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      assert.has_error(function()
        builder.insert_option_with_arg("option", nil, option_prefixes.long)
      end)
    end)

    it(
      "should insert option and arg and not throw an error if prefix is nil",
      function()
        local builder =
          require("mona.lib.shell_commands.builder")("shell_command_name")

        local values =
          builder.insert_option_with_arg("option", "arg", nil).values()

        local expected_values = {
          "shell_command_name",
          "option",
          "arg",
        }

        assert.same(expected_values, values)
      end
    )

    it("should insert prefix, option and arg", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      local values = builder
        .insert_option_with_arg("option", "arg", option_prefixes.long)
        .values()

      local expected_values = {
        "shell_command_name",
        "--option",
        "arg",
      }

      assert.same(expected_values, values)
    end)
  end)

  describe("values", function()
    it(
      "should return an empty table if no values have been inserted",
      function()
        local builder = require("mona.lib.shell_commands.builder")()

        local values = builder.values()

        assert.same({}, values)
      end
    )

    it("should return a table", function()
      local builder =
        require("mona.lib.shell_commands.builder")("shell_command_name")

      local values = builder
        .insert("value")
        .insert_option("option", option_prefixes.long)
        .insert_option_with_arg("option", "arg", option_prefixes.long)
        .values()

      local expected_values = {
        "shell_command_name",
        "value",
        "--option",
        "--option",
        "arg",
      }

      assert.same(expected_values, values)
    end)
  end)

  describe("join_values", function()
    it(
      "should return an empty string if no values have been inserted",
      function()
        local builder = require("mona.lib.shell_commands.builder")()

        local joined_values = builder.join_values()

        assert.same("", joined_values)
      end
    )

    it(
      "should return values joined as a string, seperated by a space",
      function()
        local builder =
          require("mona.lib.shell_commands.builder")("shell_command_name")

        local joined_values = builder
          .insert("value")
          .insert_option("option", option_prefixes.long)
          .insert_option_with_arg("option", "arg", option_prefixes.long)
          .join_values()

        assert.same(
          "shell_command_name value --option --option arg",
          joined_values
        )
      end
    )
  end)
end)
