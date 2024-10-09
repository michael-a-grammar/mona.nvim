return function(opts)
   local finders = require("telescope.finders")
   local actions = require("telescope.actions")
   local action_set = require("telescope.actions.set")
   local action_state = require("telescope.actions.state")

   local utils = require("telescope._extensions.mona.utils")

   local notify = require("mona.notify").for_telescope("included_pickers")()

   opts.prompt_title = " " .. "mona"

   local pickers, config, merged_config =
      require("telescope._extensions.mona.base_picker")(opts)

   return pickers
      .new(merged_config, {
         finder = finders.new_table({
            results = config.included_pickers,

            entry_maker = function(entry)
               local picker_name = entry[1]
               local picker_display_name = ""

               for picker_display_name_part in
                  string.gmatch(picker_name, "[^_]+")
               do
                  if picker_display_name_part ~= "elixir" then
                     picker_display_name = picker_display_name
                        .. " "
                        .. utils.string.capitalise(picker_display_name_part)
                  end
               end

               return {
                  display = picker_display_name,
                  ordinal = picker_name,
                  value = entry,
               }
            end,
         }),

         attach_mappings = function(_)
            actions.select_default:replace(function(prompt_bufnr)
               local selection = action_state.get_selected_entry()

               if not selection then
                  notify.warn({
                     message = "no selected picker",
                     notify_once = true,
                  })

                  return
               end

               actions.close(prompt_bufnr)

               vim.schedule(function()
                  selection.value[2]()
               end)
            end)

            return true
         end,

         sorter = config.values.generic_sorter(merged_config),
      })
      :find()
end
