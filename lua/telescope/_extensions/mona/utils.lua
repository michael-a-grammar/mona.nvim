local M = {}

M.string = {}

M.string.capitalise = function(str)
   return (str:gsub("^%l", string.upper))
end

return M
