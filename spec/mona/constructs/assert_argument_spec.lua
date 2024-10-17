describe("mona.constructs.assert_argument", function()
  it("should throw an error if mod_name is nil", function()
    assert.has_error(function()
      require("mona.constructs.assert_argument")(nil)
    end)
  end)

  it("should throw an error if argument_name is nil", function()
    local assert_argument =
      require("mona.constructs.assert_argument")("mod_name")

    assert.has_error(function()
      assert_argument("argument", nil)
    end)
  end)

  it(
    "should throw an error with a message containing mod_name and argument_name if argument is nil",
    function()
      local assert_argument =
        require("mona.constructs.assert_argument")("mod_name")

      local ok, message = pcall(function()
        assert_argument(nil, "argument_name")
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "argument_name"))
    end
  )

  it(
    "should throw an error with a message containing mod_name, fn_name and argument_name if argument is nil",
    function()
      local assert_argument =
        require("mona.constructs.assert_argument")("mod_name")

      local ok, message = pcall(function()
        assert_argument(nil, "argument_name", "fn_name")
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "fn_name"))
      assert.is_not_nil(string.match(message, "argument_name"))
    end
  )

  describe("multiple", function()
    it("should throw an error if an argument_name is nil", function()
      local assert_argument =
        require("mona.constructs.assert_argument")("mod_name")

      assert.has_error(function()
        assert_argument.multiple({
          { "argument1", "argument_name1" },
          { "argument2", nil },
          { "argument3", "argument_name3" },
          { "argument4", "argument_name4" },
        }, "fn_name")
      end)
    end)

    it(
      "should throw an error with a message containing mod_name and argument_name if an argument is nil",
      function()
        local assert_argument =
          require("mona.constructs.assert_argument")("mod_name")

        local ok, message = pcall(function()
          assert_argument.multiple({
            { "argument1", "argument_name1" },
            { nil, "argument_name2" },
            { "argument3", "argument_name3" },
            { "argument4", "argument_name4" },
          })
        end)

        message = tostring(message)

        assert.is_false(ok)

        assert.is_not_nil(string.match(message, "mod_name"))
        assert.is_not_nil(string.match(message, "argument_name2"))
      end
    )

    it(
      "should throw an error with a message containing mod_name, fn_name and argument_name if an argument is nil",
      function()
        local assert_argument =
          require("mona.constructs.assert_argument")("mod_name")

        local ok, message = pcall(function()
          assert_argument.multiple({
            { "argument1", "argument_name1" },
            { nil, "argument_name2" },
            { "argument3", "argument_name3" },
            { "argument4", "argument_name4" },
          }, "fn_name")
        end)

        message = tostring(message)

        assert.is_false(ok)

        assert.is_not_nil(string.match(message, "mod_name"))
        assert.is_not_nil(string.match(message, "fn_name"))
        assert.is_not_nil(string.match(message, "argument_name2"))
      end
    )
  end)

  describe("factory", function()
    it("should throw an error if fn_name is nil", function()
      assert.has_error(function()
        require("mona.constructs.assert_argument")("mod_name").factory(nil)
      end)
    end)

    it("should capture fn_name", function()
      local assert_argument = require("mona.constructs.assert_argument")(
        "mod_name"
      ).factory("fn_name")

      local ok, message = pcall(function()
        assert_argument(nil, "argument_name")
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "fn_name"))
      assert.is_not_nil(string.match(message, "argument_name"))
    end)

    describe("multiple", function()
      it("should throw an error if fn_name is nil", function()
        assert.has_error(function()
          require("mona.constructs.assert_argument")("mod_name").factory.multiple(
            nil
          )
        end)
      end)

      it("should capture fn_name", function()
        local assert_argument = require("mona.constructs.assert_argument")(
          "mod_name"
        ).factory.multiple("fn_name")

        local ok, message = pcall(function()
          assert_argument({
            { "argument1", "argument_name1" },
            { nil, "argument_name2" },
            { "argument3", "argument_name3" },
            { "argument4", "argument_name4" },
          })
        end)

        message = tostring(message)

        assert.is_false(ok)

        assert.is_not_nil(string.match(message, "mod_name"))
        assert.is_not_nil(string.match(message, "fn_name"))
        assert.is_not_nil(string.match(message, "argument_name2"))
      end)
    end)
  end)
end)
