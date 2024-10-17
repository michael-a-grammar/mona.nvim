return setmetatable({}, {
  __call = function(_, picker_names, picker_groups)
    return {
      pickers = {
        [picker_names.included_pickers] = {
          theme = "dropdown",
        },
      },

      picker_groups = {
        [picker_groups.modules] = {},

        [picker_groups.test_modules] = {},

        [picker_groups.other] = {},
      },
    }
  end,
})
