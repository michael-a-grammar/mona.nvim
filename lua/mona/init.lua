local M = {}

function M.setup(opts)
  opts = opts or {}

  require("mona.config").extend(opts)

  return M
end

M.elixir = require("mona.elixir")

return M
