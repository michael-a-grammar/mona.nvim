describe('mona.directories', function()
  local directories = require('mona.directories')

  describe('project', function()
    it('should return the elixir project directory', function()
     local expected_project_directory = vim.fn.getcwd() .. '/tests/mona_test_project'

      vim.api.nvim_set_current_dir(expected_project_directory .. '/lib')

      local project_directory = directories.project()

      assert.equals(expected_project_directory, project_directory)
    end)
  end)
end)
