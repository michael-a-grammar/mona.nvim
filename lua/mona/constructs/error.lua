local callable_table = require("mona.constructs.callable_table")
local message_formatter = require("mona.constructs.message_formatter")

return callable_table(function(mod_name)
  assert(mod_name)

  local M = callable_table(function(error_message, metadata, fn_name)
    assert(error_message)

    local message = message_formatter(mod_name, "Error thrown", fn_name, {
      error_message = error_message,
      metadata = metadata,
    })

    error(message)
  end)

  function M.factory(fn_name)
    assert(fn_name)

    return function(error_message, metadata)
      assert(error_message)

      return M(error_message, metadata, fn_name)
    end
  end

  return M
end)
