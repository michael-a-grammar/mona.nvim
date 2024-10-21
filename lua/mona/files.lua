local M = {}

local Path = require("plenary.path")

local notify_factory = require("mona.notify")("files")

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

function M.test()
  local notify = notify_factory("test")

  local buffer_name = vim.fn.bufname()

  if string.find(buffer_name, ".+/test/.+_test%.exs") then
    return false
  end

  local buffer_file = M.buffer()

  if not utils.paths.exists(buffer_file) then
    notify.warn("can not find buffer file, buffer file: " .. buffer_file)
    return false
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local test_file = string.gsub(buffer_file, "/lib/", "/test/")

  test_file = string.gsub(test_file, "%.ex", "_test.exs")

  test_file = Path:new(test_file)

  return test_file.filename, utils.paths.exists(test_file)
end

local mt = {
  __call = function(_)
    local buffer_file = M.buffer()
    local test_file, test_file_exists = M.test()

    return {
      buffer = {
        exists = utils.paths.exists(buffer_file),
        path = buffer_file,
      },

      test_file = {
        exists = test_file_exists,
        path = test_file,
      },
    }
  end,
}

return setmetatable(M, mt)
