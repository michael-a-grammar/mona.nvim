describe("telescope._extensions.mona.config.reset", function()
  local config = require("telescope._extensions.mona.config")

  before_each(function()
    config.reset()
  end)

  it("should reset persisted config", function()
    config.values = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "ivy",
        },
      },
    }

    local user_config = {
      extensions = {
        mona = {
          user_config_value = "a user config value",
        },
      },
    }

    local user_extension_config = {
      extensions = {
        mona = {
          user_extension_config_value = "a user extension config value",
        },
      },
    }

    config.extend(user_extension_config, user_config)

    local expected_reset_config = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "dropdown",
        },
      },
    }

    config = require("telescope._extensions.mona.config")

    config.reset()

    local reset_config = config.values

    assert.same(expected_reset_config, reset_config)
  end)
end)
