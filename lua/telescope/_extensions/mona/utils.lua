local M = {}

M.string = {}

function M.string.capitalise(str)
  return (string.gsub(str, "^%l", string.upper))
end

return M
