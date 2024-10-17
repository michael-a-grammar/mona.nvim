describe("mona.paths.directories.applications", function()
  local current_working_directory = vim.loop.cwd()

  local mona_test_project_directory = current_working_directory
    .. "/test_projects/mona_test_project"

  local mona_test_umbrella_project_directory = current_working_directory
    .. "/test_projects/mona_test_umbrella_project"

  it(
    "should return the elixir applications directory path when within a umbrella application",
    function()
      local directories = require("mona.paths.directories")({
        git_directory_name = "_git",
      })

      vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

      vim.cmd("edit apps/mona_test_application1/lib/mona_test_application1.ex")

      local expected_applications_directory = mona_test_umbrella_project_directory
        .. "/apps"

      local applications_directory = directories.applications()

      assert.equals(expected_applications_directory, applications_directory)
    end
  )

  it(
    "should not return the elixir applications directory path when not within a umbrella application",
    function()
      local directories = require("mona.paths.directories")({
        git_directory_name = "_git",
      })

      vim.api.nvim_set_current_dir(mona_test_project_directory)

      vim.cmd("edit lib/mona_test_project.ex")

      local expected_applications_directory = false

      local applications_directory = directories.applications()

      assert.equals(expected_applications_directory, applications_directory)
    end
  )
end)
