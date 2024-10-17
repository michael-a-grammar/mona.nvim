local edit_commands = vim
  .iter({
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
  })
  :fold({}, function(edit_commands, edit_command)
    edit_commands[string.gsub(edit_command, "%s", "_")] = edit_command

    return edit_commands
  end)

return {
  log_level_value = vim.log.levels.WARN,

  edit = {
    commands = edit_commands,
    default_command = edit_commands.rightbelow_vnew,
    prompt_to_create = false,
  },
}
