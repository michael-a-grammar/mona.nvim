describe("mona.config", function()
  describe("extend", function()
    it("should not throw an error if opts is nil", function()
      assert.has_no_error(function()
        require("mona.config").extend(nil)
      end)
    end)

    it(
      "should extend exisiting dictionary-like tables on key collision",
      function()
        local config = require("mona.config")

        config.values = {
          dictionary = {
            config_dictionary_value = "a config dictionary value",
          },
        }

        local user_config = {
          dictionary = {
            user_config_dictionary_value = "a user config dictionary value",
          },
        }

        local expected_extended_config = {
          dictionary = {
            config_dictionary_value = "a config dictionary value",
            user_config_dictionary_value = "a user config dictionary value",
          },
        }

        local extended_config = config.extend(user_config).values

        assert.same(expected_extended_config, extended_config)
      end
    )

    it("should replace exisiting primitive values on key collision", function()
      local config = require("mona.config")

      config.values = {
        string = "a config string value",
        integer = 1,
        boolean = false,

        array = {
          "a config array value",
        },

        dictionary = {
          dictionary_value = "a config dictionary value",
        },
      }

      local user_config = {
        string = "a user config string value",
        integer = 2,
        boolean = true,

        array = {
          "a user config array value",
        },

        dictionary = {
          dictionary_value = "a user config dictionary value",
        },
      }

      local expected_extended_config = {
        string = "a user config string value",
        integer = 2,
        boolean = true,

        array = {
          "a user config array value",
        },

        dictionary = {
          dictionary_value = "a user config dictionary value",
        },
      }

      local extended_config = config.extend(user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it("should add values from user_config on key missing", function()
      local config = require("mona.config")

      config.values = {}

      local user_config = {
        string = "a user config string value",
      }

      local expected_extended_config = {
        string = "a user config string value",
      }

      local extended_config = config.extend(user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it("should preserve values from config on key missing", function()
      local config = require("mona.config")

      config.values = {
        string = "a config string value",
      }

      local user_config = {
        string = "a config string value",
      }

      local expected_extended_config = {
        string = "a config string value",
      }

      local extended_config = config.extend(user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it("should be persisted", function()
      local config = require("mona.config")

      config.values = {
        string = "a config string value",
      }

      local user_config = {
        dictionary = {
          dictionary_value = "a user config dictionary value",
        },
      }

      config.extend(user_config)

      local expected_extended_config = {
        string = "a config string value",

        dictionary = {
          dictionary_value = "a user config dictionary value",
        },
      }

      local extended_config = require("mona.config").values

      assert.same(expected_extended_config, extended_config)
    end)
  end)
end)
