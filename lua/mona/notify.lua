local M = {}

local config = require("mona.config")

local function format_message_header(mod_name, mod_name_suffix, fn_name)
  local append_dot = function(name)
    if name then
      name = "." .. name
    else
      name = ""
    end

    return name
  end

  return string.format(
    "[%s%s%s]: ",
    mod_name or "",
    append_dot(mod_name_suffix),
    append_dot(fn_name)
  )
end

local function format_message(message_header, message, metadata)
  message = message_header .. message

  if metadata then
    message = string.format(message .. ", metadata: %s", vim.inspect(metadata))
  end

  return message
end

local function get_title()
  local title = "mona.nvim"
  local icon = config.icon("mona")

  if icon then
    return string.format(" %s %s", icon, title)
  end

  return title
end

local function notify(message_header, message, log_level_value, metadata, opts)
  if not message or message == "" then
    return false
  end

  opts = opts or {}

  if not log_level_value then
    log_level_value = config.log_level_value(opts.log_level)
  end

  message = format_message(message_header, message, metadata)

  local notify_once = vim.F.if_nil(opts.notify_once, false)

  local notify_fn = notify_once and vim.notify_once or vim.notify

  notify_fn(message, log_level_value, {
    title = get_title(),
  })

  return message
end

local function factory(mod_name, mod_name_suffix)
  return function(fn_name)
    local notifications = {}

    local message_header =
      format_message_header(mod_name, mod_name_suffix, fn_name)

    local mt = {
      __call = function(_, message, metadata, opts)
        return notify(message_header, message, false, metadata, opts)
      end,
    }

    for log_level, log_level_value in pairs(vim.log.levels) do
      if log_level ~= "OFF" then
        notifications[string.lower(log_level)] = function(
          message,
          metadata,
          opts
        )
          return notify(
            message_header,
            message,
            log_level_value,
            metadata,
            opts
          )
        end
      end
    end

    return setmetatable(notifications, mt)
  end
end

local function make(mod_name, mod_name_suffix, fn_name)
  local notify_factory = factory(mod_name, mod_name_suffix)

  if fn_name and fn_name ~= "" then
    return notify_factory(fn_name)
  end

  return notify_factory
end

local mt = {
  __call = function(_, mod_name_suffix, fn_name)
    return make("mona", mod_name_suffix, fn_name)
  end,
}

function M.for_module(mod_name)
  return function(mod_name_suffix, fn_name)
    return make(mod_name, mod_name_suffix, fn_name)
  end
end

return setmetatable(M, mt)
