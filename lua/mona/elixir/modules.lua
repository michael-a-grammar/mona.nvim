local M = {}

M.project = function(with_modules)
  return function()
    local project_directory = require('mona.directories').project_directory()

    if not project_directory then
      return false
    end

    require('plenary.job')
      :new({
        command = 'rg',
        args = require('mona.ripgrep.args.elixir').project_modules(
          project_directory
        ),
        cwd = project_directory,
        env = vim.env,
        on_exit = function(self, code)
          if code == 0 then
            with_modules(
              require('mona.ripgrep.results.elixir').modules(self:result())
            )
          end
        end,
        on_stderr = function(error, _)
          vim.notify(error)
        end,
      })
      :start()

    return true
  end
end

return M
