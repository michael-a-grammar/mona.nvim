local M = {}

local mt = {
  __call = function(_, extension_name, require_plugin, plugin_name)
    return function(fn_name, fn)
      plugin_name = plugin_name or extension_name

      local config = require("mona.config")

      local notify =
        require("mona.notify")("extensions." .. extension_name)(fn_name)

      local extension_is_enabled = config.is_extension_enabled(extension_name)

      if not extension_is_enabled then
        notify("extension is not enabled", {
          extension_name = extension_name,
        })
        return false
      end

      if not require_plugin then
        return fn()
      end

      local ok, plugin = pcall(require, plugin_name)

      if not ok then
        notify("can not require plugin", {
          plugin_name = plugin_name,
        })
        return false
      end

      return fn(plugin)
    end
  end,
}

return setmetatable(M, mt)
