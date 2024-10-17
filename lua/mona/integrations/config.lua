local M = {}

local integrations_config = require("mona.config").values.integrations

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

local error_factory = require("mona.constructs.error")(...).factory

function M.is_integration_enabled(integration_name)
  assert_argument_factory("is_integration_enabled")(integration_name)

  local integration_is_enabled = integrations_config[integration_name]

  if integration_is_enabled == nil then
    error_factory("is_integration_enabled")("can not find integration", {
      integration_name = integration_name,
    })
  end

  return integration_is_enabled
end

return M
