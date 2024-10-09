local M = {}

local notify_factory = require("mona.notify").for_mona("ripgrep.results.elixir")

function M.modules(results)
   local modules = {}

   for _, result in ipairs(results) do
      local module = M.module(result)

      if module then
         table.insert(modules, module)
      end
   end

   return modules
end

function M.module(result)
   local notify = notify_factory("module")

   if not result or result == "" then
      return notify.warn("result is nil or empty")
   end

   local path, line_number, column_number, module_name = string.match(result, "(.*):(.*):(.*):(.*)")

   local module = {
      path = path,
      line_number = tonumber(line_number),
      column_number = tonumber(column_number),
      module_name = module_name,
   }

   for key, value in ipairs(module) do
      if not value or value == "" then
         return notify.warn("value is nil or empty, key: " .. key)
      end
   end

   return module
end

return M
