local M = {}

M.tests = {}

local function make(directory_name, tests, opts)
   opts = opts or {}

   local utils = require("telescope._extensions.mona.utils")

   local directory, err = require("mona.directories")[directory_name]()

   if not directory then
      return nil, err
   end

   opts.prompt_title = " "
      .. (opts.prompt_title or utils.string.capitalise(directory_name))
      .. (tests and " Tests" or " Modules")

   opts.vimgrep_arguments = require("mona.ripgrep.args.elixir").modules(directory, tests)

   return require("telescope._extensions.mona.elixir.modules.picker")(opts)
end

local function project_modules(tests, opts)
   return make("project", tests, opts)
end

local function application_modules(tests, opts)
   return make("application", tests, opts)
end

local function buffer_directory_modules(tests, opts)
   opts = opts or {}

   opts.prompt_title = opts.prompt_title or "Buffer Directory"

   return make("buffer", tests, opts)
end

function M.project(opts)
   return project_modules(false, opts)
end

function M.application(opts)
   return application_modules(false, opts)
end

function M.buffer_directory(opts)
   return buffer_directory_modules(false, opts)
end

function M.tests.project(opts)
   return project_modules(true, opts)
end

function M.tests.application(opts)
   return application_modules(true, opts)
end

function M.tests.buffer_directory(opts)
   return buffer_directory_modules(true, opts)
end

return M