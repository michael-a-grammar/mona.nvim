local M = {}

local mt = {
  __call = function(_)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local notify =
      require("mona.notify").for_telescope("included_pickers.attach_mappings")()

    actions.select_default:replace(function(prompt_bufnr)
      local selection = action_state.get_selected_entry()

      if not selection then
        notify.warn({
          message = "no selected picker",
          notify_once = true,
        })

        return false
      end

      actions.close(prompt_bufnr)

      vim.schedule(function()
        selection.value[2]()
      end)
    end)

    return true
  end,
}

return setmetatable(M, mt)
