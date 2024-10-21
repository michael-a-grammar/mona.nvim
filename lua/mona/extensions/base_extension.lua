local M = {}

local mt = {
  __call = function(_, extension_name, plugin_name)
    return function(fn_name, fn)
      local config = require("mona.config")

      local notify =
        require("mona.notify")("extensions." .. extension_name)(fn_name)

      local extension_is_enabled = config.is_extension_enabled(extension_name)

      if not extension_is_enabled then
        notify.warn(
          "Extension is not enabled, extension name: " .. extension_name
        )
        return false
      end

      local ok, plugin = pcall(require, plugin_name)

      if not ok then
        notify.warn(
          string.format("Can not require plugin, plugin name: %s", plugin_name)
        )
        return false
      end

      return fn(plugin)
    end
  end,
}

return setmetatable(M, mt)
