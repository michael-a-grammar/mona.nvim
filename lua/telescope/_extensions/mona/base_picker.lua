return function(opts)
  opts = opts or {}

  local pickers = require('telescope.pickers')
  local config = require('telescope._extensions.mona.config')

  local merged_config = config.merge(opts)

  return pickers, config, merged_config
end
