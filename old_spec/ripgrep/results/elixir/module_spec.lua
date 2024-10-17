describe("mona.ripgrep.results.elixir.module", function()
  local elixir_module = require("mona.ripgrep.results.elixir.module")

  it("should return parsed ripgrep output", function()
    local ripgrep_output =
      "mona_test_project/lib/mona_test_project.ex:1:1:MonaTestProject"

    local expected_module = {
      path = "mona_test_project/lib/mona_test_project.ex",
      line_number = 1,
      column_number = 1,
      module_name = "MonaTestProject",
    }

    local module = elixir_module(ripgrep_output)

    assert.same(expected_module, module)
  end)

  it(
    "should not return parsed ripgrep output if output is nil or empty",
    function()
      for _, ripgrep_output in ipairs({ nil, "" }) do
        local module = elixir_module(ripgrep_output)

        assert.truthy(module)
      end
    end
  )
end)
