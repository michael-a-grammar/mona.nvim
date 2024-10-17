describe("mona.vim.config", function()
  describe("log_level_value", function()
    it("should throw an error if a log level value cannot be found", function()
      require("mona.config").extend({
        vim = {
          log_level_value = "",
        },
      })

      assert.has_error(function()
        require("mona.vim.config").log_level_value()
      end)
    end)

    it(
      "should return the default log level value if log_level_name is nil",
      function() end
    )
  end)
end)
