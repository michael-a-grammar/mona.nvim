local M = {}

M.project_modules = function(project_directory)
  return require('mona.ripgrep.args.factory')({
    directory = project_directory,
    glob = '*.ex',
    replace = '$1',
    regexp = 'defmodule ([a-zA-Z.]*) do$',
  }).default()
end

return M
