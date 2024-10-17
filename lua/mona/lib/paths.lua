local M = {}

local Path = require("plenary.path")

local result = require("mona.lib.result")(...)

local assert_argument_factory =
  require("mona.constructs.assert_argument")(...).factory

local error_factory = require("mona.constructs.error")(...).factory

function M.find_upwards(from_directory, item_name)
  assert_argument_factory.multiple("find_upwards")({
    { from_directory, "from_directory" },
    { item_name, "item_name" },
  })

  local err = result.err.factory("find_upwards")

  if not M.exists(from_directory) then
    return err("from directory does not exist", {
      from_directory = from_directory.filename,
      item_name = item_name,
    })
  end

  local item = Path:new(from_directory:find_upwards(item_name))

  if not M.exists(item) then
    return err("item does not exist", {
      from_directory = from_directory.filename,
      item_name = item_name,
    })
  end

  return result.ok(item)
end

function M.descendants(parent_directory, descendant_names)
  assert_argument_factory.multiple("descendants")({
    { parent_directory, "parent_directory" },
    { descendant_names, "descendant_names" },
  })

  local err = result.err.factory("descendants")

  if vim.tbl_isempty(descendant_names) then
    error_factory("descendants")("no descendant names provided")
  end

  if not M.exists(parent_directory) then
    return err("parent directory does not exist", {
      parent_directory = parent_directory.filename,
    })
  end

  local descendants = Path:new(
    vim
      .iter({ parent_directory.filename, descendant_names })
      :flatten()
      :totable()
  )

  if not M.exists(descendants) then
    return err("one or more descendants do not exist", {
      parent_directory = parent_directory.filename,
      descendant_names = descendant_names,
    })
  end

  return result.ok(descendants)
end

function M.exists(path)
  assert_argument_factory("exists")(path, "path")

  return path:exists() and path.filename ~= ""
end

function M.rewrite(path, opts)
  assert_argument_factory.multiple("rewrite")({
    { path, "path" },
    { opts, "opts" },
  })

  local updated_path = path.filename

  -- TODO: Believe there is a vim api to rewrite paths
  if opts.directory_from and opts.directory_to then
    updated_path =
      string.gsub(updated_path, opts.directory_from, opts.directory_to)
  end

  if opts.filename_from and opts.filename_to then
    updated_path =
      string.gsub(updated_path, opts.filename_from, opts.filename_to)
  end

  updated_path = Path:new(updated_path)

  return updated_path
end

return M
