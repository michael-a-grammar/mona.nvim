describe("mona.lib.ripgrep.parsed_result_spec", function()
  local result = require("mona.lib.result")("")

  it("should throw an error if ripgrep_output is nil", function()
    assert.has_error(function()
      require("mona.lib.ripgrep.parsed_result")(nil)
    end)
  end)

  it("should return an err if ripgrep_output is an empty string", function()
    local parsed_result = require("mona.lib.ripgrep.parsed_result")("")

    local is_err = result.is_err(parsed_result)

    assert.is_true(is_err)
  end)

  it("should return an err if ripgrep_output cannot be parsed", function()
    local parsed_result =
      require("mona.lib.ripgrep.parsed_result")("invalid ripgrep output")

    local is_err = result.is_err(parsed_result)

    assert.is_true(is_err)
  end)

  it(
    "should return an err if path cannot be parsed from ripgrep_output",
    function()
      local parsed_result =
        require("mona.lib.ripgrep.parsed_result")(":1:1:file_name")

      local is_err = result.is_err(parsed_result)

      local expected_invalid_parsed_result_fields = {
        "path",
      }

      assert.is_true(is_err)

      assert.same(
        expected_invalid_parsed_result_fields,
        parsed_result.err.metadata.invalid_parsed_result_fields
      )
    end
  )

  it(
    "should return an err if line number cannot be parsed from ripgrep_output",
    function()
      local parsed_result = require("mona.lib.ripgrep.parsed_result")(
        "path:line number:1:file_name"
      )

      local is_err = result.is_err(parsed_result)

      local expected_invalid_parsed_result_fields = {
        "line_number",
      }

      assert.is_true(is_err)

      assert.same(
        expected_invalid_parsed_result_fields,
        parsed_result.err.metadata.invalid_parsed_result_fields
      )
    end
  )

  it(
    "should return an err if column number cannot be parsed from ripgrep_output",
    function()
      local parsed_result = require("mona.lib.ripgrep.parsed_result")(
        "path:1:column number:file_name"
      )

      local is_err = result.is_err(parsed_result)

      local expected_invalid_parsed_result_fields = {
        "column_number",
      }

      assert.is_true(is_err)

      assert.same(
        expected_invalid_parsed_result_fields,
        parsed_result.err.metadata.invalid_parsed_result_fields
      )
    end
  )

  it(
    "should return an err if file name cannot be parsed from ripgrep_output",
    function()
      local parsed_result =
        require("mona.lib.ripgrep.parsed_result")("path:1:1:")

      local is_err = result.is_err(parsed_result)

      local expected_invalid_parsed_result_fields = {
        "file_name",
      }

      assert.is_true(is_err)

      assert.same(
        expected_invalid_parsed_result_fields,
        parsed_result.err.metadata.invalid_parsed_result_fields
      )
    end
  )

  it("should return an ok if ripgrep_output can be parsed", function()
    local parsed_result =
      require("mona.lib.ripgrep.parsed_result")("path:1:1:file_name")

    local is_ok = result.is_ok(parsed_result)

    local expected_parsed_result = {
      ok = {
        path = "path",
        line_number = 1,
        column_number = 1,
        file_name = "file_name",
      },
    }

    assert.is_true(is_ok)
    assert.same(expected_parsed_result, parsed_result)
  end)
end)
