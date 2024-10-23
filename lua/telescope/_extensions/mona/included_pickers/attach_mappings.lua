local M = {}

local mt = {
  __call = function(_)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local notify = require("telescope._extensions.mona.notify")(
      "included_pickers.attach_mappings"
    )()

    actions.select_default:replace(function(prompt_bufnr)
      local selection = action_state.get_selected_entry()

      if not selection then
        notify("no selection", false, {
          notify_once = true,
        })
        return false
      end

      local picker = selection.value[2]

      if not picker and type(picker) ~= "function" then
        notify("can not find selected value", false, {
          notify_once = true,
        })
        return false
      end

      actions.close(prompt_bufnr)

      vim.schedule(function()
        picker()
      end)
    end)

    return true
  end,
}

return setmetatable(M, mt)
