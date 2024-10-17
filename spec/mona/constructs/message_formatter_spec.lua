describe("mona.constructs.message_formatter", function()
  it("should throw an error if mod_name is nil", function()
    assert.has_error(function()
      require("mona.constructs.message_formatter")(
        nil,
        "message",
        "fn_name",
        { metadata = "metadata" }
      )
    end)
  end)

  it("should throw an error if message is nil", function()
    assert.has_error(function()
      require("mona.constructs.message_formatter")(
        "mod_name",
        nil,
        "fn_name",
        { metadata = "metadata" }
      )
    end)
  end)

  it("should return a string containing mod_name and message", function()
    local message =
      require("mona.constructs.message_formatter")("mod_name", "message")

    assert.same("[mod_name]: message", message)
  end)

  it(
    "should return a string containing mod_name, fn_name and message",
    function()
      local message = require("mona.constructs.message_formatter")(
        "mod_name",
        "message",
        "fn_name"
      )

      assert.same("[mod_name.fn_name]: message", message)
    end
  )

  it(
    "should return a string containing mod_name, message and metadata",
    function()
      local message = require("mona.constructs.message_formatter")(
        "mod_name",
        "message",
        nil,
        { metadata = "metadata" }
      )

      assert.same(
        [[[mod_name]: message, metadata: {
  metadata = "metadata"
}]],
        message
      )
    end
  )

  it(
    "should return a string containing mod_name, fn_name, message and metadata",
    function()
      local message = require("mona.constructs.message_formatter")(
        "mod_name",
        "message",
        "fn_name",
        { metadata = "metadata" }
      )

      assert.same(
        [[[mod_name.fn_name]: message, metadata: {
  metadata = "metadata"
}]],
        message
      )
    end
  )
end)
