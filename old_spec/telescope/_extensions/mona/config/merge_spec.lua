describe("telescope._extensions.mona.config.merge", function()
  local config = require("telescope._extensions.mona.config")

  before_each(function()
    config.reset()
  end)

  describe(
    "merging config with the picker config, theme config and picker opts",
    function()
      it("should extend exisiting dictionaries on key collision", function()
        config.values = {
          extensions = {
            mona = {
              dictionary = {
                picker_config_value = "a picker config value",
              },
            },
          },

          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local picker_opts = {
          picker_name = config.included_pickers_name,

          extensions = {
            mona = {
              dictionary = {
                picker_opts_value = "a picker opts value",
              },
            },
          },
        }

        local expected_merged_config = {
          picker_name = config.included_pickers_name,

          extensions = {
            mona = {
              dictionary = {
                picker_config_value = "a picker config value",
                picker_opts_value = "a picker opts value",
              },
            },
          },

          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local merged_config = config.merge(picker_opts)

        assert.same(
          expected_merged_config.picker_name,
          merged_config.picker_name
        )
        assert.same(expected_merged_config.extensions, merged_config.extensions)
        assert.same(expected_merged_config.pickers, merged_config.pickers)

        assert.same(
          expected_merged_config.pickers[config.included_pickers_name].theme,
          merged_config.theme
        )

        assert.truthy(merged_config.border)
        assert.truthy(merged_config.borderchars)
        assert.truthy(merged_config.borderchars.preview)
        assert.truthy(merged_config.borderchars.prompt)
        assert.truthy(merged_config.borderchars.results)
        assert.truthy(merged_config.borderchars.results)
        assert.truthy(merged_config.layout_config)
        assert.truthy(merged_config.layout_config.height)
        assert.truthy(merged_config.layout_config.preview_cutoff)
        assert.truthy(merged_config.layout_config.width)
        assert.truthy(merged_config.layout_strategy)
        assert.truthy(merged_config.sorting_strategy)
        assert.truthy(merged_config.theme)
      end)

      it(
        "should replace exisiting primitive values on key collision",
        function()
          config.values = {
            extensions = {
              mona = {
                string = "a picker config string value",
                integer = 1,
                boolean = false,

                array = {
                  "a picker config array value",
                },
              },
            },

            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local picker_opts = {
            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                string = "a picker opts string value",
                integer = 2,
                boolean = true,

                array = {
                  "a picker opts array value",
                },
              },
            },
          }

          local expected_merged_config = {
            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                string = "a picker opts string value",
                integer = 2,
                boolean = true,

                array = {
                  "a picker opts array value",
                },
              },
            },

            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local merged_config = config.merge(picker_opts)

          assert.same(
            expected_merged_config.picker_name,
            merged_config.picker_name
          )
          assert.same(
            expected_merged_config.extensions,
            merged_config.extensions
          )
          assert.same(expected_merged_config.pickers, merged_config.pickers)

          assert.same(
            expected_merged_config.pickers[config.included_pickers_name].theme,
            merged_config.theme
          )

          assert.truthy(merged_config.border)
          assert.truthy(merged_config.borderchars)
          assert.truthy(merged_config.borderchars.preview)
          assert.truthy(merged_config.borderchars.prompt)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.layout_config)
          assert.truthy(merged_config.layout_config.height)
          assert.truthy(merged_config.layout_config.preview_cutoff)
          assert.truthy(merged_config.layout_config.width)
          assert.truthy(merged_config.layout_strategy)
          assert.truthy(merged_config.sorting_strategy)
          assert.truthy(merged_config.theme)
        end
      )

      it("should merge values from the picker config on key missing", function()
        config.values = {
          picker_config_value = "a picker config value",

          extensions = {
            mona = {
              picker_config_value = "a picker config value",
            },
          },

          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local picker_opts = {
          picker_name = config.included_pickers_name,

          extensions = {
            mona = {},
          },
        }

        local expected_merged_config = {
          picker_config_value = "a picker config value",

          picker_name = config.included_pickers_name,

          extensions = {
            mona = {
              picker_config_value = "a picker config value",
            },
          },

          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local merged_config = config.merge(picker_opts)

        assert.same(
          expected_merged_config.picker_name,
          merged_config.picker_name
        )
        assert.same(expected_merged_config.extensions, merged_config.extensions)
        assert.same(expected_merged_config.pickers, merged_config.pickers)

        assert.same(
          expected_merged_config.pickers[config.included_pickers_name].theme,
          merged_config.theme
        )

        assert.truthy(merged_config.border)
        assert.truthy(merged_config.borderchars)
        assert.truthy(merged_config.borderchars.preview)
        assert.truthy(merged_config.borderchars.prompt)
        assert.truthy(merged_config.borderchars.results)
        assert.truthy(merged_config.borderchars.results)
        assert.truthy(merged_config.layout_config)
        assert.truthy(merged_config.layout_config.height)
        assert.truthy(merged_config.layout_config.preview_cutoff)
        assert.truthy(merged_config.layout_config.width)
        assert.truthy(merged_config.layout_strategy)
        assert.truthy(merged_config.sorting_strategy)
        assert.truthy(merged_config.theme)
      end)

      it(
        "should preserve values from the picker opts on key missing",
        function()
          config.values = {
            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local picker_opts = {
            picker_opts_value = "a picker opts value",

            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                picker_opts_value = "a picker opts value",
              },
            },
          }

          local expected_merged_config = {
            picker_opts_value = "a picker opts value",

            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                picker_opts_value = "a picker opts value",
              },
            },

            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local merged_config = config.merge(picker_opts)

          assert.same(
            expected_merged_config.picker_name,
            merged_config.picker_name
          )
          assert.same(
            expected_merged_config.extensions,
            merged_config.extensions
          )
          assert.same(expected_merged_config.pickers, merged_config.pickers)

          assert.same(
            expected_merged_config.pickers[config.included_pickers_name].theme,
            merged_config.theme
          )

          assert.truthy(merged_config.border)
          assert.truthy(merged_config.borderchars)
          assert.truthy(merged_config.borderchars.preview)
          assert.truthy(merged_config.borderchars.prompt)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.layout_config)
          assert.truthy(merged_config.layout_config.height)
          assert.truthy(merged_config.layout_config.preview_cutoff)
          assert.truthy(merged_config.layout_config.width)
          assert.truthy(merged_config.layout_strategy)
          assert.truthy(merged_config.sorting_strategy)
          assert.truthy(merged_config.theme)
        end
      )

      it(
        "should merge a theme config using the theme set on the picker config",
        function()
          config.values = {
            theme = "dropdown",
          }

          local picker_opts = {
            picker_name = config.included_pickers_name,
          }

          local merged_config = config.merge(picker_opts)

          assert.equals(merged_config.theme, "dropdown")

          assert.truthy(merged_config.border)
          assert.truthy(merged_config.borderchars)
          assert.truthy(merged_config.borderchars.preview)
          assert.truthy(merged_config.borderchars.prompt)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.layout_config)
          assert.truthy(merged_config.layout_config.height)
          assert.truthy(merged_config.layout_config.preview_cutoff)
          assert.truthy(merged_config.layout_config.width)
          assert.truthy(merged_config.layout_strategy)
          assert.truthy(merged_config.sorting_strategy)
        end
      )

      it(
        "should merge a theme config using the theme set on the picker config",
        function()
          config.values = {
            theme = "dropdown",

            pickers = {
              [config.included_pickers_name] = {
                theme = "ivy",
              },
            },
          }

          local picker_opts = {
            picker_name = config.included_pickers_name,
          }

          local merged_config = config.merge(picker_opts)

          assert.equals(merged_config.theme, "ivy")

          assert.truthy(merged_config.border)
          assert.truthy(merged_config.borderchars)
          assert.truthy(merged_config.borderchars.preview)
          assert.truthy(merged_config.borderchars.prompt)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.layout_config)
          assert.truthy(merged_config.layout_config.height)
          assert.truthy(merged_config.layout_strategy)
          assert.truthy(merged_config.sorting_strategy)
        end
      )

      it(
        "should merge a theme config using the theme set on the picker opts",
        function()
          config.values = {
            theme = "dropdown",

            pickers = {
              [config.included_pickers_name] = {
                theme = "ivy",
              },
            },
          }

          local picker_opts = {
            picker_name = config.included_pickers_name,

            theme = "cursor",
          }

          local merged_config = config.merge(picker_opts)

          assert.equals(merged_config.theme, "cursor")

          assert.truthy(merged_config.borderchars)
          assert.truthy(merged_config.borderchars.preview)
          assert.truthy(merged_config.borderchars.prompt)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.borderchars.results)
          assert.truthy(merged_config.layout_config)
          assert.truthy(merged_config.layout_config.height)
          assert.truthy(merged_config.layout_config.width)
          assert.truthy(merged_config.layout_strategy)
          assert.truthy(merged_config.sorting_strategy)
        end
      )

      it(
        "should not merge a theme config if the picker name is not set on the picker opts",
        function()
          config.values = {}

          local picker_opts = {}

          local merged_config = config.merge(picker_opts)

          assert.falsy(merged_config.picker_name)
          assert.falsy(merged_config.border)
          assert.falsy(merged_config.borderchars)
          assert.falsy(merged_config.layout_config)
          assert.falsy(merged_config.layout_strategy)
          assert.falsy(merged_config.sorting_strategy)
          assert.falsy(merged_config.theme)
        end
      )

      it(
        "should not merge a theme config if a theme is not set on the picker config or picker opts",
        function()
          config.values = {}

          local picker_opts = {
            picker_name = config.included_pickers_name,
          }

          local expected_merged_config = {
            picker_name = config.included_pickers_name,
          }

          local merged_config = config.merge(picker_opts)

          assert.same(
            expected_merged_config.picker_name,
            merged_config.picker_name
          )

          assert.falsy(merged_config.border)
          assert.falsy(merged_config.borderchars)
          assert.falsy(merged_config.layout_config)
          assert.falsy(merged_config.layout_strategy)
          assert.falsy(merged_config.sorting_strategy)
          assert.falsy(merged_config.theme)
        end
      )
    end
  )

  it("should not be persisted", function()
    config.values = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "dropdown",
        },
      },
    }

    local picker_opts = {
      picker_name = config.included_pickers_name,

      extensions = {
        mona = {
          picker_opts_value = "a picker opts value",
        },
      },
    }

    config.merge(picker_opts)

    local expected_merged_config = {
      pickers = {
        [config.included_pickers_name] = {
          theme = "dropdown",
        },
      },
    }

    local merged_config = require("telescope._extensions.mona.config").values

    assert.same(expected_merged_config, merged_config)
  end)
end)
