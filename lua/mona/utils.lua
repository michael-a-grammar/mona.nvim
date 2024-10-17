local M = {}

M.paths = {}

function M.paths.exists(path)
  if not path or path == "" then
    return false
  end

  if type(path) == "string" then
    path = require("plenary.path"):new(path)
  end

  return path and path["exists"] and path:exists()
end

return M
