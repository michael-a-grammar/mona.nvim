describe("mona.ripgrep.args.elixir.modules", function()
  local directory = "mona_test_umbrella_project"

  it("should return ripgrep options to search for elixir modules", function()
    local modules = require("mona.ripgrep.args.elixir.modules")

    local expected_options = {
      "--case-sensitive",
      "--trim",
      "--with-filename",
      "--word-regexp",
      "--vimgrep",
      "--glob",
      "*.ex",
      "--replace",
      "$1",
      "--regexp",
      "defmodule ([a-zA-Z0-9.]*) do$",
      "mona_test_umbrella_project",
    }

    local options = modules(directory, false)

    assert.same(expected_options, options)
  end)

  it("should return ripgrep options to search for elixir tests", function()
    local modules = require("mona.ripgrep.args.elixir.modules")

    local expected_options = {
      "--case-sensitive",
      "--trim",
      "--with-filename",
      "--word-regexp",
      "--vimgrep",
      "--glob",
      "*_test.exs",
      "--replace",
      "$1",
      "--regexp",
      "defmodule ([a-zA-Z0-9.]*Test) do$",
      "mona_test_umbrella_project",
    }

    local options = modules(directory, true)

    assert.same(expected_options, options)
  end)
end)
