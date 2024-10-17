describe("mona.constructs.error", function()
  it("should throw an error if mod_name is nil", function()
    assert.has_error(function()
      require("mona.constructs.error")(nil)
    end)
  end)

  it("should throw an error if error_message is nil", function()
    local error = require("mona.constructs.error")("mod_name")

    assert.has_error(function()
      error(nil, { metadata = "metadata" })
    end)
  end)

  it(
    "should throw an error with a message containing mod_name, error_message and metadata",
    function()
      local error = require("mona.constructs.error")("mod_name")

      local metadata = { metadata = "metadata" }

      local ok, message = pcall(function()
        error("error_message", metadata)
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "error_message"))
      assert.is_not_nil(string.match(message, [[metadata = "metadata"]]))
    end
  )

  it(
    "should throw an error with a message containing mod_name, fn_name, error_message and metadata",
    function()
      local error = require("mona.constructs.error")("mod_name")

      local metadata = { metadata = "metadata" }

      local ok, message = pcall(function()
        error("error_message", metadata, "fn_name")
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "fn_name"))
      assert.is_not_nil(string.match(message, "error_message"))
      assert.is_not_nil(string.match(message, [[metadata = "metadata"]]))
    end
  )

  describe("factory", function()
    it("should throw an error if fn_name is nil", function()
      assert.has_error(function()
        require("mona.constructs.error")("mod_name").factory(nil)
      end)
    end)

    it("should capture fn_name", function()
      local error =
        require("mona.constructs.error")("mod_name").factory("fn_name")

      local metadata = { metadata = "metadata" }

      local ok, message = pcall(function()
        error("error_message", metadata)
      end)

      message = tostring(message)

      assert.is_false(ok)

      assert.is_not_nil(string.match(message, "mod_name"))
      assert.is_not_nil(string.match(message, "fn_name"))
      assert.is_not_nil(string.match(message, "error_message"))
      assert.is_not_nil(string.match(message, [[metadata = "metadata"]]))
    end)
  end)
end)
