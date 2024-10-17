local callable_table = require("mona.constructs.callable_table")
local config = require("mona.integrations.config")

local assert_argument = require("mona.constructs.assert_argument")(...)
local error = require("mona.constructs.error")(...)
local notify = require("mona.vim.notify")(...)

return callable_table(
  function(integration_name, should_require_plugin, plugin_name)
    assert_argument(integration_name)

    return function(integration_fn)
      plugin_name = plugin_name or integration_name

      local integration_is_enabled =
        config.is_integration_enabled(integration_name)

      if not integration_is_enabled then
        return notify("integration is not enabled", {
          integration_name = integration_name,
        })
      end

      if not should_require_plugin then
        return integration_fn()
      end

      local ok, plugin = pcall(require, plugin_name)

      if not ok then
        error("can not require plugin", {
          plugin_name = plugin_name,
        })
      end

      return integration_fn(plugin)
    end
  end
)
