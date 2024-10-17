describe("mona.paths.directories.buffer", function()
  local current_working_directory = vim.loop.cwd()

  local mona_test_project_directory = current_working_directory
    .. "/test_projects/mona_test_project"

  it("should return the current buffer directory path", function()
    local directories = require("mona.paths.directories")({
      git_directory_name = "_git",
    })

    vim.api.nvim_set_current_dir(mona_test_project_directory)

    vim.cmd("edit lib/mona_test_project.ex")

    local expected_buffer_directory = mona_test_project_directory .. "/lib"

    local buffer_directory = directories.buffer()

    assert.equals(expected_buffer_directory, buffer_directory)
  end)
end)
