return setmetatable({}, {
  __call = function(_, opts)
    opts.prompt_title =
      require("mona.config").prefix_with_icon("elixir", "mona")

    local pickers, config, merged_config =
      require("telescope._extensions.mona.base_picker")(opts)

    local attach_mappings =
      require("telescope._extensions.mona.included_pickers.attach_mappings")

    local finder =
      require("telescope._extensions.mona.included_pickers.finder")(
        merged_config
      )

    return pickers
      .new(merged_config, {
        attach_mappings = attach_mappings,
        finder = finder,
        sorter = config.values.generic_sorter(merged_config),
      })
      :find()
  end,
})
