local M = {}

local function insert_arg(arg, exclude_prefix, args)
  local prefix = (exclude_prefix and "") or "--"

  table.insert(args, prefix .. arg)
end

local function insert_if(condition, arg, exclude_prefix, args)
  if condition then
    insert_arg(arg, exclude_prefix, args)
  end
end

local function insert_arg_with_value(arg, args, opts)
  local key = string.gsub(arg, "-", "_")

  local arg_value = opts[key]

  insert_if(arg_value, arg, false, args)
  insert_if(arg_value, arg_value, true, args)
end

function M.default(opts)
  local args = {}

  for _, arg in ipairs({
    "case-sensitive",
    "trim",
    "vimgrep",
    "with-filename",
    "word-regexp",
  }) do
    insert_arg(arg, args)
  end

  for _, arg in ipairs({ "glob", "replace", "regexp" }) do
    insert_arg_with_value(arg, args, opts)
  end

  return args
end

return M
