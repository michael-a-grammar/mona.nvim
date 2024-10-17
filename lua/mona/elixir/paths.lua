local M = {}

local lib_paths = require("mona.lib.paths")

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

function M.is_module(path)
  assert_argument_factory("is_module")(path, "path")

  return string.match(path.filename, ".+/lib/.+%.ex")
end

function M.is_test_module(path)
  assert_argument_factory("is_test_module")(path, "path")

  return string.match(path.filename, ".+/test/.+_test%.exs")
end

function M.to_module_path(path)
  assert_argument_factory("to_module_path")(path, "path")

  local is_module = M.is_module(path)

  if is_module then
    return path, lib_paths.exists(path)
  end

  return lib_paths.rewrite(path, {
    directory_from = "/test/",
    directory_to = "/lib/",
    filename_from = "_test%.exs",
    filename_to = ".ex",
  })
end

function M.to_test_module_path(path)
  assert_argument_factory("to_test_module_path")(path, "path")

  local is_test_module = M.is_test_module(path)

  if is_test_module then
    return path, lib_paths.exists(path)
  end

  return lib_paths.rewrite(path, {
    directory_from = "/lib/",
    directory_to = "/test/",
    filename_from = "%.ex",
    filename_to = "_test.exs",
  })
end

return M
