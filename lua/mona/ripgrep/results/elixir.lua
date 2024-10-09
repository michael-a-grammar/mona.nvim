local notify_fn = require("mona.notify").for_mona("ripgrep.results.elixir")

local M = {}

M.modules = function(results)
   local modules = {}

   for _, result in ipairs(results) do
      local module = M.module(result)

      if module then
         table.insert(modules, module)
      end
   end

   return modules
end

M.module = function(result)
   local notify = notify_fn("module")

   if not result or result == "" then
      notify.warn("result is nil or empty")
      return false
   end

   local path, line_number, column_number, module_name =
      string.match(result, "(.*):(.*):(.*):(.*)")

   local module = {
      path = path,
      line_number = tonumber(line_number),
      column_number = tonumber(column_number),
      module_name = module_name,
   }

   for key, value in ipairs(module) do
      if not value or value == "" then
         notify.warn("value is nil or empty, key: " .. key)
         return false
      end
   end

   return module
end

return M
