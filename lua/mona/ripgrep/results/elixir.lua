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
  if not result or result == '' then
    return false
  end

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
