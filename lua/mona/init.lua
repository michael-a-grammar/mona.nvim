local M = {}

function M.setup(opts)
  require("mona.config").extend(opts)

  return M
end

return M
