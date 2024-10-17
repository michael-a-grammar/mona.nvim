local M = {}

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

local error_factory = require("mona.constructs.error")(...).factory

function M.icon(icon_name)
  assert_argument_factory("icon")(icon_name, "icon_name")

  local lib_config = require("mona.config").values.lib

  if not lib_config.icons.enable then
    return nil
  end

  local icon = lib_config.icons[icon_name]

  if not icon then
    error_factory("icon")("can not find icon", {
      icon_name = icon_name,
    })
  end

  return icon
end

function M.prefix_with_icon(icon_name, suffix)
  assert_argument_factory.multiple("icon")({
    { icon_name, "icon_name" },
    { suffix, "suffix" },
  })

  local icon = M.icon(icon_name)

  if not icon then
    return suffix
  end

  return string.format("%s %s", icon, suffix)
end

return M
