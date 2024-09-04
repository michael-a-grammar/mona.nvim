local M = {}

M.modules = function(results)
  local modules = {}
  for _, result in ipairs(results) do
    table.insert(modules, M.module(result))
  end
end

M.module = function(result)
  local path, line_number, column_number, module_name =
    string.match(result, '(.*):(.*):(.*):(.*)')

  return {
    path = path,
    line_number = tonumber(line_number),
    column_number = tonumber(column_number),
    module_name = module_name,
  }
end

return M
