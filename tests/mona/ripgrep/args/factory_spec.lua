describe('mona.ripgrep.args.factory', function()
  local factory = require('mona.ripgrep.args.factory')

  local expected_args, args

  local opts = {
    directory = 'mona_test_umbrella_project',
    glob = '*.ex',
    replace = '$1',
    regexp = 'defmodule ([a-zA-Z.]*) do$',
  }

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

    args = factory(opts).default()
  end)

  it('should return ripgrep options', function()
    args.with_rg_command = nil

    assert.same(expected_args, args)
  end)

  it('should return ripgrep options including "rg"', function()
    table.insert(expected_args, 1, 'rg')

    args:with_rg_command()

    args.with_rg_command = nil

    assert.same(expected_args, args)
  end)
end)
