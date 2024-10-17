return setmetatable({}, {
  __call = function(_, opts)
    if not opts then
      return false
    end

    local entry_maker =
      require("telescope._extensions.mona.elixir.modules.entry_maker")

    return require("telescope.finders.async_oneshot_finder")({
      entry_maker = entry_maker,

      fn_command = function()
        return {
          args = opts.vimgrep_arguments,
          command = "rg",
        }
      end,
    })
  end,
})
