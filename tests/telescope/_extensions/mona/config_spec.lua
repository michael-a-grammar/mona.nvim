describe('telescope._extensions.mona.config', function()
  local config = require('telescope._extensions.mona.config')

  before_each(function()
    config.reset()
  end)

  describe('setup', function()
    describe('merging user config with the user extension config', function()
      it('should merge the default extension config', function()
        local user_config = {}
        local user_extension_config = {}

        local expected_result = {
          pickers = {
            [config.included_pickers_name] = {
              theme = 'dropdown',
            },
          },
        }

        local result = config.setup(user_extension_config, user_config).values

        assert.same(expected_result, result)
      end)

      it('should extend exisiting dictionaries on key collision', function()
        local user_config = {
          extensions = {
            mona = {
              dictionary = {
                user_config_value = 'a user config value',
              },
            },
          },
        }

        local user_extension_config = {
          extensions = {
            mona = {
              dictionary = {
                user_extension_config_value = 'a user extension config value',
              },
            },
          },
        }

        local expected_result = {
          pickers = {
            [config.included_pickers_name] = {
              theme = 'dropdown',
            },
          },

          extensions = {
            mona = {
              dictionary = {
                user_config_value = 'a user config value',
                user_extension_config_value = 'a user extension config value',
              },
            },
          },
        }

        local result = config.setup(user_extension_config, user_config).values

        assert.same(expected_result, result)
      end)

      it(
        'should replace exisiting primitive values on key collision',
        function()
          local user_config = {
            extensions = {
              mona = {
                string = 'a user config string value',
                integer = 1,
                boolean = false,

                array = {
                  'a user config array value',
                },
              },
            },
          }

          local user_extension_config = {
            extensions = {
              mona = {
                string = 'a extension config string value',
                integer = 2,
                boolean = true,

                array = {
                  'a extension config array value',
                },
              },
            },
          }

          local expected_result = {
            pickers = {
              [config.included_pickers_name] = {
                theme = 'dropdown',
              },
            },

            extensions = {
              mona = {
                string = 'a extension config string value',
                integer = 2,
                boolean = true,

                array = {
                  'a extension config array value',
                },
              },
            },
          }

          local result = config.setup(user_extension_config, user_config).values

          assert.same(expected_result, result)
        end
      )

      it('should merge values from the user config on key missing', function()
        local user_config = {
          user_config_value = 'a user config value',

          extensions = {
            mona = {
              user_config_value = 'a user config value',
            },
          },
        }

        local user_extension_config = {
          extensions = {
            mona = {},
          },
        }

        local expected_result = {
          pickers = {
            [config.included_pickers_name] = {
              theme = 'dropdown',
            },
          },

          user_config_value = 'a user config value',

          extensions = {
            mona = {
              user_config_value = 'a user config value',
            },
          },
        }

        local result = config.setup(user_extension_config, user_config).values

        assert.same(expected_result, result)
      end)

      it(
        'should preserve values from the user extension config on key missing',
        function()
          local user_config = {
            extensions = {
              mona = {},
            },
          }

          local user_extension_config = {
            user_extension_config_value = 'a user extension config value',

            extensions = {
              mona = {
                user_extension_config_value = 'a user extension config value',
              },
            },
          }

          local expected_result = {
            pickers = {
              [config.included_pickers_name] = {
                theme = 'dropdown',
              },
            },

            user_extension_config_value = 'a user extension config value',

            extensions = {
              mona = {
                user_extension_config_value = 'a user extension config value',
              },
            },
          }

          local result = config.setup(user_extension_config, user_config).values

          assert.same(expected_result, result)
        end
      )
    end)

    it('should be persisted', function()
      local user_config = {
        extensions = {
          mona = {
            dictionary = {
              user_config_value = 'a user config value',
            },
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {
            dictionary = {
              user_extension_config_value = 'a user extension config value',
            },
          },
        },
      }

      config.setup(user_extension_config, user_config)

      local expected_result = {
        pickers = {
          [config.included_pickers_name] = {
            theme = 'dropdown',
          },
        },

        extensions = {
          mona = {
            dictionary = {
              user_config_value = 'a user config value',
              user_extension_config_value = 'a user extension config value',
            },
          },
        },
      }

      config = require('telescope._extensions.mona.config')

      assert.same(expected_result, config.values)
    end)
  end)

  describe('merge', function()
    it('should be persisted', function()
    end)
  end)

  describe('register_included_pickers', function()
    it('should register a picker', function()
    end)

    it('should not register the included pickers picker', function()
    end)

    it('should be persisted', function()
    end)
  end)

  describe('reset', function()
    it('should reset persisted config', function()
      config.reset()
    end)
  end)
end)
