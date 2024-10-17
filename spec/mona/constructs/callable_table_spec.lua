describe("mona.constructs.callable_table", function()
  it("should throw an error if call_fn is nil", function()
    assert.has_error(function()
      require("mona.constructs.callable_table")(nil)
    end)
  end)

  it("should return a metatable containing a __call function", function()
    local callable_table = require("mona.constructs.callable_table")(
      function() end
    )

    local __call = getmetatable(callable_table).__call

    assert.is_function(__call)
  end)

  it(
    "should return a metatable containing a __call function which delegates to call_fn",
    function()
      local callable_table = require("mona.constructs.callable_table")(
        function(addend1, addend2)
          return addend1 + addend2
        end
      )

      local callable_table_result = callable_table(1, 2)

      assert.same(3, callable_table_result)
    end
  )
end)
