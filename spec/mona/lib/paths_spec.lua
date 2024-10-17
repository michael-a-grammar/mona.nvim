describe("mona.lib.paths", function()
  local Path = require("plenary.path")

  local result = require("mona.lib.result")("")

  local current_working_directory = (vim.uv or vim.loop).cwd()

  local mona_test_project_directory = current_working_directory
    .. "/test_projects/mona_test_project"

  describe("find_upwards", function()
    it("should throw an error if from_directory is nil", function()
      assert.has_error(function()
        require("mona.lib.paths").find_upwards(nil, "mix.exs")
      end)
    end)

    it("should throw an error if item_name is nil", function()
      assert.has_error(function()
        local from_directory = Path:new(mona_test_project_directory, "lib")

        require("mona.lib.paths").find_upwards(from_directory, nil)
      end)
    end)

    it("should return an err if from_directory does not exist", function()
      local item_name = "mix.exs"

      local from_directory =
        Path:new(mona_test_project_directory, "does_not_exist")

      local path =
        require("mona.lib.paths").find_upwards(from_directory, item_name)

      local is_err = result.is_err(path)

      local expected_from_directory = from_directory.filename
      local expected_item_name = item_name

      assert.is_true(is_err)
      assert.same(expected_from_directory, path.err.metadata.from_directory)
      assert.same(expected_item_name, path.err.metadata.item_name)
    end)

    it("should return an err if item does not exist", function()
      local item_name = "does_not_exist"

      local from_directory = Path:new(mona_test_project_directory, "lib")

      local path =
        require("mona.lib.paths").find_upwards(from_directory, item_name)

      local is_err = result.is_err(path)

      local expected_from_directory = from_directory.filename
      local expected_item_name = item_name

      assert.is_true(is_err)
      assert.same(expected_from_directory, path.err.metadata.from_directory)
      assert.same(expected_item_name, path.err.metadata.item_name)
    end)

    it("should return an ok if item exists", function()
      local from_directory = Path:new(mona_test_project_directory, "lib")

      local path =
        require("mona.lib.paths").find_upwards(from_directory, "mix.exs")

      local is_ok = result.is_ok(path)

      local expected_path = {
        ok = Path:new(mona_test_project_directory, "mix.exs"),
      }

      assert.is_true(is_ok)
      assert.same(expected_path, path)
    end)
  end)

  describe("descendants", function()
    it("should throw an error if parent_directory is nil", function()
      assert.has_error(function()
        require("mona.lib.paths").descendants(nil, "mix.exs")
      end)
    end)

    it("should throw an error if descendant_names is nil", function()
      assert.has_error(function()
        local parent_directory =
          Path:new(mona_test_project_directory, { "lib" })

        require("mona.lib.paths").descendants(parent_directory, nil)
      end)
    end)

    it("should throw an error if descendant_names is empty", function()
      assert.has_error(function()
        local parent_directory = Path:new(mona_test_project_directory, {})

        require("mona.lib.paths").descendants(parent_directory, nil)
      end)
    end)

    it("should return an err if parent_directory does not exist", function()
      local parent_directory =
        Path:new(mona_test_project_directory, "does_not_exist")

      local path =
        require("mona.lib.paths").descendants(parent_directory, { "mix.exs" })

      local expected_parent_directory = parent_directory.filename

      local is_err = result.is_err(path)

      assert.is_true(is_err)
      assert.same(expected_parent_directory, path.err.metadata.parent_directory)
    end)

    it("should return an err if descendants does not exist", function()
      local parent_directory = Path:new(mona_test_project_directory, "lib")

      local descendant_names = { "does_not_exist", "mix.exs" }

      local path = require("mona.lib.paths").descendants(
        parent_directory,
        descendant_names
      )

      local expected_parent_directory = parent_directory.filename
      local expected_descendant_names = descendant_names

      local is_err = result.is_err(path)

      assert.is_true(is_err)
      assert.same(expected_parent_directory, path.err.metadata.parent_directory)
      assert.same(expected_descendant_names, path.err.metadata.descendant_names)
    end)

    it("should return an ok if descendants exist", function()
      local parent_directory = Path:new(mona_test_project_directory, "lib")

      local path = require("mona.lib.paths").descendants(
        parent_directory,
        { "test_modules", "module1.ex" }
      )

      local is_ok = result.is_ok(path)

      local expected_path = {
        ok = Path:new(
          mona_test_project_directory,
          "lib",
          "test_modules",
          "module1.ex"
        ),
      }

      assert.is_true(is_ok)
      assert.same(expected_path, path)
    end)
  end)

  describe("exists", function()
    it("should throw an error if path is nil", function()
      assert.has_error(function()
        require("mona.lib.paths").exists(nil)
      end)
    end)

    it("should return false if path does not exist", function()
      local path = Path:new(mona_test_project_directory, "does_not_exist")

      local path_exists = require("mona.lib.paths").exists(path)

      assert.is_false(path_exists)
    end)

    it("should return true if path does exists", function()
      local path = Path:new(mona_test_project_directory, "lib")

      local path_exists = require("mona.lib.paths").exists(path)

      assert.is_true(path_exists)
    end)
  end)

  describe("rewrite", function()
    it("should throw an error if path is nil", function()
      assert.has_error(function()
        require("mona.lib.paths").rewrite(nil, {
          directory_from = "lib",
          directory_to = "test",
          filename_from = ".ex",
          filename_to = ".exs",
        })
      end)
    end)

    it("should throw an error if opts is nil", function()
      assert.has_error(function()
        local path = Path:new(mona_test_project_directory, "lib")

        require("mona.lib.paths").rewrite(path, nil)
      end)
    end)

    it("should rewrite path directory", function()
      local path = Path:new(mona_test_project_directory, "lib")

      local updated_path = require("mona.lib.paths").rewrite(path, {
        directory_from = "lib",
        directory_to = "test",
      }).filename

      local expected_path =
        Path:new(mona_test_project_directory, "test").filename

      assert.same(expected_path, updated_path)
    end)

    it("should rewrite path filename", function()
      local path = Path:new(mona_test_project_directory, "lib", "module1.ex")

      local updated_path = require("mona.lib.paths").rewrite(path, {
        filename_from = "module1",
        filename_to = "module2",
      }).filename

      local expected_path =
        Path:new(mona_test_project_directory, "lib", "module2.ex").filename

      assert.same(expected_path, updated_path)
    end)

    it("should rewrite path", function()
      local path = Path:new(mona_test_project_directory, "lib", "module1.ex")

      local updated_path = require("mona.lib.paths").rewrite(path, {
        directory_from = "lib",
        directory_to = "test",
        filename_from = ".ex",
        filename_to = ".exs",
      }).filename

      local expected_path =
        Path:new(mona_test_project_directory, "test", "module1.exs").filename

      assert.same(expected_path, updated_path)
    end)
  end)
end)
