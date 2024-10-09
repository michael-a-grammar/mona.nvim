local M = {}

local function format_message(message, mod_name, mod_name_suffix, fn_name)
   local ensure = function(name)
      if name then
         name = "." .. name
      else
         name = ""
      end

      return name
   end

   return string.format(
      "[%s%s%s]: %s",
      mod_name or "",
      ensure(mod_name_suffix),
      ensure(fn_name),
      message
   )
end

local function notify_factory(mod_name, mod_name_suffix)
   return function(fn_name)
      local notify = {}

      for log_level, log_level_value in pairs(vim.log.levels) do
         notify[string.lower(log_level)] = function(message, opts)
            opts = opts or {}

            local notify_once = vim.F.if_nil(opts.notify_once, false)

            local notify_fn = notify_once and vim.notify_once or vim.notify

            message = format_message(message, mod_name, mod_name_suffix, fn_name)

            notify_fn(message, log_level_value, {
               title = "mona.nvim",
            })

            return nil, message
         end
      end

      return notify
   end
end

function M.for_mona(mod_name)
   return notify_factory("mona", mod_name)
end

function M.for_telescope(mod_name)
   return notify_factory("telescope._extensions.mona", mod_name)
end

return M
