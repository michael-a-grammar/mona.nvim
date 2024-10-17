local M = {}

local vim_config = require("mona.config").values.vim

local error_factory = require("mona.constructs.error")(...).factory

function M.log_level_value(log_level_name)
  log_level_name = log_level_name and string.upper(log_level_name) or ""

  local config_log_level_value = vim_config.log_level_value

  local _, log_level_value = vim
    .iter(vim.log.levels)
    :find(function(log_level_key, log_level_value)
      return log_level_key == log_level_name
        or log_level_value == config_log_level_value
    end)

  if not log_level_value then
    error_factory("log_level_value")("can not find log level value", {
      config_log_level_value = config_log_level_value,
      log_level_name = log_level_name,
    })
  end

  return log_level_value
end

function M.edit_command(edit_command)
  local config_edit_default_command = vim.config.edit.default_command

  edit_command = edit_command and vim_config.edit.commands[edit_command]
    or vim_config.edit.commands[config_edit_default_command]

  if not edit_command then
    error_factory("edit_command")("can not find edit command", {
      config_edit_default_command = config_edit_default_command,
      edit_command = edit_command,
    })
  end

  return edit_command
end

return M
