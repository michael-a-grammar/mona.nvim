local M = {}

local edit_commands = {}

for _, edit_command in ipairs({
  "edit",
  "new",
  "tabedit",
  "drop",
  "tab drop",
  "leftabove new",
  "leftabove vnew",
  "rightbelow new",
  "rightbelow vnew",
  "topleft new",
  "topleft vnew",
  "botright new",
  "botright vnew",
}) do
  local key = string.gsub(edit_command, "%s", "_")

  edit_commands[key] = edit_command

  M[key] = key
end

function M.find(opts)
  if not opts or not opts.edit_command then
    return edit_commands.rightbelow_vnew
  end

  local edit_command = edit_commands[opts.edit_command]

  if not edit_command then
    return edit_commands.rightbelow_vnew
  end

  return edit_command
end

return M
