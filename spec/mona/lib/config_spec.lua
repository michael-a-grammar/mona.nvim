describe("mona.lib.config", function()
  describe("icon", function()
    it("should throw an error if icon_name is nil", function()
      assert.has_error(function()
        require("mona.lib.config").icon(nil)
      end)
    end)

    it("should return nil if icons are not enabled", function()
      require("mona.config").extend({
        lib = {
          icons = {
            enable = false,
          },
        },
      })

      local config = require("mona.lib.config")

      local icon = config.icon("elixir")

      assert.is_nil(icon)
    end)

    it("should return an error if an icon cannot be found", function()
      require("mona.config").extend({
        lib = {
          icons = {
            enable = true,
          },
        },
      })

      assert.has_error(function()
        require("mona.lib.config").icon("")
      end)
    end)

    it("should return icon", function()
      require("mona.config").extend({
        lib = {
          icons = {
            enable = true,
          },
        },
      })

      local icon = require("mona.lib.config").icon("elixir")

      assert.same("", icon)
    end)
  end)

  describe("prefix_with_icon", function()
    it("should throw an error if icon_name is nil", function()
      assert.has_error(function()
        require("mona.lib.config").prefix_with_icon(nil, "suffix")
      end)
    end)

    it("should throw an error if suffix is nil", function()
      assert.has_error(function()
        require("mona.lib.config").prefix_with_icon("elixir", nil)
      end)
    end)

    it("should return suffix if icons are not enabled", function()
      require("mona.config").extend({
        lib = {
          icons = {
            enable = false,
          },
        },
      })

      local config = require("mona.lib.config")

      local prefixed_with_icon = config.prefix_with_icon("elixir", "suffix")

      assert.same("suffix", prefixed_with_icon)
    end)

    it("should return icon and suffix", function()
      require("mona.config").extend({
        lib = {
          icons = {
            enable = true,
          },
        },
      })

      local config = require("mona.lib.config")

      local prefixed_with_icon = config.prefix_with_icon("elixir", "suffix")

      assert.same(" suffix", prefixed_with_icon)
    end)
  end)
end)
