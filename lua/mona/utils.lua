local M = {}

M.paths = {}

function M.paths.exists(path)
  if not path then
    return false
  end

  if type(path) == "string" then
    path = require("plenary.path"):new(path)
  end

  return path
    and path["exists"]
    and path["filename"]
    and path:exists()
    and path.filename ~= ""
end

return M
