local callable_table = require("mona.constructs.callable_table")

local assert_argument = require("mona.constructs.assert_argument")(...)
local result = require("mona.lib.result")(...)

return callable_table(function(ripgrep_output)
  assert_argument(ripgrep_output, "ripgrep_output")

  if ripgrep_output == "" then
    return result.err("ripgrep output empty")
  end

  local path, line_number, column_number, file_name =
    string.match(ripgrep_output, "(.*):(.*):(.*):(.*)")

  local parsed_result = {
    path = path or "",
    line_number = tonumber(line_number) or "",
    column_number = tonumber(column_number) or "",
    file_name = file_name or "",
  }

  local invalid_parsed_result_fields = vim
    .iter(parsed_result)
    :map(function(key, value)
      if value == "" or value == 0 then
        return key
      end
    end)
    :totable()

  if not vim.tbl_isempty(invalid_parsed_result_fields) then
    return result.err("one or more parsed result fields are empty or 0", {
      invalid_parsed_result_fields = invalid_parsed_result_fields,
      ripgrep_output = ripgrep_output,
    })
  end

  return result.ok(parsed_result)
end)
