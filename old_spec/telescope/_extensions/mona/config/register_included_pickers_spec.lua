describe(
  "telescope._extensions.mona.config.register_included_pickers",
  function()
    local config = require("telescope._extensions.mona.config")

    before_each(function()
      config.reset()
    end)

    it("should register a picker", function()
      local pickers = {
        ["picker name"] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      local expected_picker_name = config.included_pickers[1][1]

      local expected_picker = config.included_pickers[1][2]()

      assert.equals(expected_picker_name, "picker name")
      assert.equals(expected_picker, "picker function")
    end)

    it("should not register the included pickers picker", function()
      local pickers = {
        [config.included_pickers_name] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      assert.same({}, config.included_pickers)
    end)

    it("should be persisted", function()
      local pickers = {
        ["picker name"] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      config = require("telescope._extensions.mona.config")

      local expected_picker_name = config.included_pickers[1][1]

      local expected_picker = config.included_pickers[1][2]()

      assert.equals(expected_picker_name, "picker name")
      assert.equals(expected_picker, "picker function")
    end)
  end
)
