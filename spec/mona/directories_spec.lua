describe("mona.directories", function()
  local current_working_directory = vim.loop.cwd()

  local mona_test_project_directory = current_working_directory
    .. "/test_projects/mona_test_project"

  local mona_test_umbrella_project_directory = current_working_directory
    .. "/test_projects/mona_test_umbrella_project"

  describe("project", function()
    it(
      "should return the elixir project directory path when not within a umbrella application",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
        })

        vim.api.nvim_set_current_dir(mona_test_project_directory)

        vim.cmd("edit lib/mona_test_project.ex")

        local expected_project_directory = mona_test_project_directory

        local project_directory = directories.project()

        assert.equals(expected_project_directory, project_directory)
      end
    )

    it(
      "should return the elixir project directory path when within a umbrella application",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
        })

        vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

        vim.cmd(
          "edit apps/mona_test_application1/lib/mona_test_application1.ex"
        )

        local expected_project_directory = mona_test_umbrella_project_directory

        local project_directory = directories.project()

        assert.equals(expected_project_directory, project_directory)
      end
    )

    it(
      "should not return the elixir project directory path if no git directory is found",
      function()
        local directories = require("mona.directories")()

        vim.api.nvim_set_current_dir(mona_test_project_directory)

        vim.cmd("edit lib/mona_test_project.ex")

        local expected_project_directory = false

        local project_directory = directories.project()

        assert.equals(expected_project_directory, project_directory)
      end
    )

    it(
      "should not return the elixir project directory path if no project mix.exs file is found",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
          mix_file_name = "_mix.exs",
        })

        vim.api.nvim_set_current_dir(mona_test_project_directory)

        vim.cmd("edit lib/mona_test_project.ex")

        local expected_project_directory = false

        local project_directory = directories.project()

        assert.equals(expected_project_directory, project_directory)
      end
    )
  end)

  describe("application", function()
    it(
      "should return the elixir application directory path when within a umbrella application",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
        })

        vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

        vim.cmd(
          "edit apps/mona_test_application1/lib/mona_test_application1.ex"
        )

        local expected_application_directory = mona_test_umbrella_project_directory
          .. "/apps/mona_test_application1"

        local application_directory = directories.application()

        assert.equals(expected_application_directory, application_directory)
      end
    )

    it(
      "should not return the elixir application directory path if no project mix.exs file is found",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
          mix_file_name = "_mix.exs",
        })

        vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

        vim.cmd(
          "edit apps/mona_test_application1/lib/mona_test_application1.ex"
        )

        local expected_application_directory = false

        local application_directory = directories.application()

        assert.equals(expected_application_directory, application_directory)
      end
    )

    it(
      "should not return the elixir application directory path when not within a umbrella application",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
        })

        vim.api.nvim_set_current_dir(mona_test_project_directory)

        vim.cmd("edit lib/mona_test_project.ex")

        local expected_application_directory = false

        local application_directory = directories.application()

        assert.equals(expected_application_directory, application_directory)
      end
    )
  end)

  describe("applications", function()
    it(
      "should return the elixir applications directory path when within a umbrella application",
      function()
        local directories = require("mona.directories")({
          git_directory_name = "_git",
        })

        vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

        vim.cmd(
          "edit apps/mona_test_application1/lib/mona_test_application1.ex"
        )

        local expected_applications_directory = mona_test_umbrella_project_directory
          .. "/apps"

        local applications_directory = directories.applications()

        assert.equals(expected_applications_directory, applications_directory)
      end
    )

    it(
      "should not return the elixir applications directory path when not within a umbrella application",
      function()
        local directories = require("mona.directories")({
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

  describe("buffer", function()
    it("should return the current buffer directory path", function()
      local directories = require("mona.directories")({
        git_directory_name = "_git",
      })

      vim.api.nvim_set_current_dir(mona_test_project_directory)

      vim.cmd("edit lib/mona_test_project.ex")

      local expected_buffer_directory = mona_test_project_directory .. "/lib"

      local buffer_directory = directories.buffer()

      assert.equals(expected_buffer_directory, buffer_directory)
    end)
  end)
end)
