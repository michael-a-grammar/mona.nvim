local M = {}

M.modules = function(directory, tests)
  local glob = '*.ex' .. (tests and 's' or '')

  local regexp =
    string.format('defmodule ([a-zA-Z.]*%s) do$', tests and 'Test' or '')

  return require('mona.ripgrep.args.factory')({
    directory = directory,
    glob = glob,
    replace = '$1',
    regexp = regexp,
  }).default()
end

return M
