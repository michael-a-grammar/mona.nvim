local M = {}

local Path = require("plenary.path")

local notify_factory = require("mona.notify").for_mona("files")

local utils = require("mona.utils")

function M.buffer()
  local notify = notify_factory("buffer")

  local buffer_file = Path:new(vim.fn.bufname()):absolute()

  if not utils.paths.exists(buffer_file) then
    notify.warn("can not find buffer file, buffer file: " .. buffer_file)
    return false
  end

  return buffer_file
end

local mt = {
  __call = function(_)
    local buffer_file = M.buffer()

    return {
      buffer = {
        exists = utils.paths.exists(buffer_file),
        path = buffer_file,
      },
    }
  end,
}

return setmetatable(M, mt)
