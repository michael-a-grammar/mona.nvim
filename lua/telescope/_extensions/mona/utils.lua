local M = {}

M.string = {}

function M.string.capitalise(str)
  return (string.gsub(str, "%L", string.upper))
end

return M
