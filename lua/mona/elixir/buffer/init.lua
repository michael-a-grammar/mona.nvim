local M = {}

local function with_buffer_content_and_path(buffer_content_and_path_fn)
  local buffer_content = require("mona.elixir.buffer.content")
  local buffer_path = require("mona.elixir.buffer.path")

  return buffer_content_and_path_fn(buffer_content, buffer_path)
end

function M.is_module()
  return with_buffer_content_and_path(function(buffer_content, buffer_path)
    return buffer_content.is_module() and buffer_path.is_module()
  end)
end

function M.is_test_module()
  return with_buffer_content_and_path(function(buffer_content, buffer_path)
    return buffer_content.is_test_module() and buffer_path.is_test_module()
  end)
end

return M
