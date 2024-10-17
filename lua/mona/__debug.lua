return setmetatable({}, {
  __call = function(_)
    return {
      config = require("mona.config"),

      constructs = {
        assert_argument = require("mona.constructs.assert_argument"),
        callable_table = require("mona.constructs.callable_table"),
        error = require("mona.constructs.error"),
        message_formatter = require("mona.constructs.message_formatter"),
      },

      lib = {
        ripgrep = {
          parsed_result = require("mona.lib.ripgrep.parsed_result"),
          shell_commands = require("mona.lib.ripgrep.shell_commands"),
        },

        shell_commands = {
          builder = require("mona.lib.shell_commands.builder"),
          factory = require("mona.lib.shell_commands.factory"),
          option_prefixes = require("mona.lib.shell_commands.option_prefixes"),
        },

        config = require("mona.lib.config"),
        paths = require("mona.lib.paths"),
        result = require("mona.lib.result"),
      },

      vim = {
        config = require("mona.vim.config"),
        edit_file = require("mona.vim.edit_file"),
        notify = require("mona.vim.notify"),
        paths = require("mona.vim.paths"),
      },
    }
  end,
})
