local M = {}

local mod_name, _ = ...

local function edit_module(opts)
  return edit_file(function(files)
    return files.module()
  end, opts)
end

local function edit_test_module(opts)
  return edit_file(function(files)
    return files.test_module()
  end, opts)
end

function M.edit_test_module(opts)
  if M.is_module() then
    return edit_test_module(opts)
  elseif M.is_test_module() then
    return edit_module(opts)
  end

  return nil
end

return M
