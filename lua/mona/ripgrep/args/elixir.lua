local M = {}

M.modules = function(directory)
  return require('mona.ripgrep.args.factory')({
    directory = directory,
    glob = '*.ex',
    replace = '$1',
    regexp = 'defmodule ([a-zA-Z.]*) do$',
  }).default()
end

return M
