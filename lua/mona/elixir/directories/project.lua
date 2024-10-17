local callable_table = require("mona.constructs.callable_table")
local lib_paths = require("mona.lib.paths")
local vim_paths = require("mona.vim.paths")

local result = require("mona.lib.result")(...)

local M = callable_table(function(opts)
  opts = opts or {}

  local git_directory_name = opts.git_directory_name or ".git"
  local mix_file_name = opts.mix_file_name or "mix.exs"

  local git_directory_name = result
    .unwrap(function()
      return vim_paths.working_directory.find_upwards(git_directory_name)
    end)
    .with({
      ok = "",
    })

  local git_directory =
    vim_paths.working_directory.find_upwards(git_directory_name)

  if not git_directory then
    return result.err("can not find git directory")
  end

  local project_directory = git_directory:parent()

  local mix_file = lib_paths.descendants(git_directory:parent(), mix_file_name)

  if not mix_file then
    return result.err("can not find mix.exs file")
  end

  return result.ok(project_directory)
end)

M.lib = function()
  return result
    .unwrap(function()
      return M()
    end)
    .with({
      ok = function(project_directory) end,
    })
end

M.test = function() end

return M
