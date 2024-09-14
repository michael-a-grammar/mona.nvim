describe('telescope._extensions.mona.base_picker', function()

  local base_picker = require('telescope._extensions.mona.base_picker')

  it('should return the telescope pickers, config and merged config', function()
    local pickers, config, merged_config = base_picker()

    assert.is.not_false(pickers)
    assert.is.not_false(config)
    assert.is.not_false(merged_config)
  end)
end)
