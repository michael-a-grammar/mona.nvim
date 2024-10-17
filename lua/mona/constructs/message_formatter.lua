local callable_table = require("mona.constructs.callable_table")

local function header(mod_name, fn_name)
  local append_dot = function(name)
    if name then
      name = "." .. name
    else
      name = ""
    end

    return name
  end

  return string.format("[%s%s]: ", mod_name, append_dot(fn_name))
end

return callable_table(function(mod_name, message, fn_name, metadata)
  assert(mod_name)
  assert(message)

  message = header(mod_name, fn_name) .. message

  if metadata and not vim.tbl_isempty(metadata) then
    message = string.format(message .. ", metadata: %s", vim.inspect(metadata))
  end

  return message
end)
