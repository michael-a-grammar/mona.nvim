local callable_table = require("mona.constructs.callable_table")

return callable_table(function(_, file_path, opts)
  opts = opts or {}

  if not require("mona.lib.paths").exists(file_path) then
    if opts.prompt_to_create then
      vim.ui.input({}, function() end)
    end

    return false
  end

  local edit_command = require("mona.vim.edit.commands").find(opts)

  vim.cmd("normal! m")

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, string.format("%s %s", edit_command, file_path))
end)
