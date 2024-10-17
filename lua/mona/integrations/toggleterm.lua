local M = {}

local assert_argument = require("mona.constructs.assert_argument")(...)

local toggleterm_integration =
  require("mona.integrations.base_integration")("toggleterm", false)

local function make_terminal(command, opts)
  opts = vim.tbl_deep_extend("force", opts or {}, {
    auto_scroll = true,
    display_name = require("mona.config").prefix_with_icon("mona", command),
    close_on_exit = true,
    cmd = command,
  })

  return require("toggleterm.terminal").Terminal:new(opts):toggle()
end

M.iex = toggleterm_integration(function()
  return function(opts, builder_fn)
    assert_argument(builder_fn)

    local iex = require("mona.elixir.lib.shell_commands.iex")(builder_fn)

    return make_terminal(iex, opts)
  end
end)

return M
