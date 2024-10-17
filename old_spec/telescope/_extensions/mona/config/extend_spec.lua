describe("telescope._extensions.mona.config.extend", function()
  local config = require("telescope._extensions.mona.config")

  before_each(function()
    config.reset()
  end)

  describe("merging user config with the user extension config", function()
    it("should extend exisiting dictionaries on key collision", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local user_config = {
        extensions = {
          mona = {
            dictionary = {
              user_config_value = "a user config value",
            },
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {
            dictionary = {
              user_extension_config_value = "a user extension config value",
            },
          },
        },
      }

      local expected_extended_config = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },

        extensions = {
          mona = {
            dictionary = {
              user_config_value = "a user config value",
              user_extension_config_value = "a user extension config value",
            },
          },
        },
      }

      local extended_config =
        config.extend(user_extension_config, user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it("should replace exisiting primitive values on key collision", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local user_config = {
        extensions = {
          mona = {
            string = "a user config string value",
            integer = 1,
            boolean = false,

            array = {
              "a user config array value",
            },
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {
            string = "a extension config string value",
            integer = 2,
            boolean = true,

            array = {
              "a extension config array value",
            },
          },
        },
      }

      local expected_extended_config = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },

        extensions = {
          mona = {
            string = "a extension config string value",
            integer = 2,
            boolean = true,

            array = {
              "a extension config array value",
            },
          },
        },
      }

      local extended_config =
        config.extend(user_extension_config, user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it("should merge values from the user config on key missing", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local user_config = {
        user_config_value = "a user config value",

        extensions = {
          mona = {
            user_config_value = "a user config value",
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {},
        },
      }

      local expected_extended_config = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },

        user_config_value = "a user config value",

        extensions = {
          mona = {
            user_config_value = "a user config value",
          },
        },
      }

      local extended_config =
        config.extend(user_extension_config, user_config).values

      assert.same(expected_extended_config, extended_config)
    end)

    it(
      "should preserve values from the user extension config on key missing",
      function()
        config.values = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local user_config = {
          extensions = {
            mona = {},
          },
        }

        local user_extension_config = {
          user_extension_config_value = "a user extension config value",

          extensions = {
            mona = {
              user_extension_config_value = "a user extension config value",
            },
          },
        }

        local expected_extended_config = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },

          user_extension_config_value = "a user extension config value",

          extensions = {
            mona = {
              user_extension_config_value = "a user extension config value",
            },
          },
        }

        local extended_config =
          config.extend(user_extension_config, user_config).values

        assert.same(expected_extended_config, extended_config)
      end
    )
  end)

  it("should be persisted", function()
    config.values = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "dropdown",
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

    local expected_extended_config = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "dropdown",
        },
      },

      extensions = {
        mona = {
          user_config_value = "a user config value",
          user_extension_config_value = "a user extension config value",
        },
      },
    }

    local extended_config = require("telescope._extensions.mona.config").values

    assert.same(expected_extended_config, extended_config)
  end)
end)
