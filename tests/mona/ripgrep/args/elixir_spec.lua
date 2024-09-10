describe('mona.ripgrep.args.elixir', function()
  local elixir = require('mona.ripgrep.args.elixir')

  local expected_args, expected_args_tests

  local directory = 'mona_test_umbrella_project'

  before_each(function()
    expected_args = {
      '--case-sensitive',
      '--trim',
      '--vimgrep',
      '--with-filename',
      '--word-regexp',
      '--glob',
      '*.ex',
      '--replace',
      '$1',
      '--regexp',
      'defmodule ([a-zA-Z.]*) do$',
      'mona_test_umbrella_project',
    }

    expected_args_tests = {
      '--case-sensitive',
      '--trim',
      '--vimgrep',
      '--with-filename',
      '--word-regexp',
      '--glob',
      '*_test.exs',
      '--replace',
      '$1',
      '--regexp',
      'defmodule ([a-zA-Z.]*Test) do$',
      'mona_test_umbrella_project',
    }
  end)

  describe('modules', function()
    it('should return ripgrep options to search for elixir modules', function()
      local args = elixir.modules(directory, false)

      args.with_rg_command = nil

      assert.same(expected_args, args)
    end)

    it('should return ripgrep options to search for elixir tests', function()
      local args = elixir.modules(directory, true)

      args.with_rg_command = nil

      assert.same(expected_args_tests, args)
    end)

    it(
      'should return ripgrep options to search for elixir modules including "rg"',
      function()
        local args = elixir.modules(directory, false)

        table.insert(expected_args, 1, 'rg')

        args:with_rg_command()

        args.with_rg_command = nil

        assert.same(expected_args, args)
      end
    )

    it(
      'should return ripgrep options to search for elixir tests including "rg"',
      function()
        local args = elixir.modules(directory, true)

        table.insert(expected_args_tests, 1, 'rg')

        args:with_rg_command()

        args.with_rg_command = nil

        assert.same(expected_args_tests, args)
      end
    )
  end)
end)
