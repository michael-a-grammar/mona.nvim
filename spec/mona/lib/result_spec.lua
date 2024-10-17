describe("mona.lib.result", function()
  it("should throw an error if mod_name is nil", function()
    assert.has_error(function()
      require("mona.lib.result")(nil)
    end)
  end)

  describe("ok", function()
    it("should throw an error if value is nil", function()
      assert.has_error(function()
        require("mona.lib.result")("mod_name").ok(nil)
      end)
    end)

    it("should return an ok", function()
      local ok = require("mona.lib.result")("mod_name").ok("success")

      local expected_ok = {
        ok = "success",
      }

      assert.same(expected_ok, ok)
    end)
  end)

  describe("err", function()
    it("should throw an error if message is nil", function()
      assert.has_error(function()
        require("mona.lib.result")("mod_name").err(
          nil,
          { metadata = "metadata" },
          "fn_name"
        )
      end)
    end)

    it(
      "should return an err which contains mod_name and message, with defaults for fn_name and metadata",
      function()
        local err = require("mona.lib.result")("mod_name").err("failure")

        local expected_err = {
          err = {
            mod_name = "mod_name",
            fn_name = "",
            message = "failure",
            metadata = {},
          },
        }

        assert.same(expected_err, err)
      end
    )

    it(
      "should return an err which contains mod_name, message and metadata, with a default for fn_name",
      function()
        local err = require("mona.lib.result")("mod_name").err(
          "failure",
          { metadata = "metadata" }
        )

        local expected_err = {
          err = {
            mod_name = "mod_name",
            fn_name = "",
            message = "failure",
            metadata = { metadata = "metadata" },
          },
        }

        assert.same(expected_err, err)
      end
    )

    it(
      "should return an err which contains mod_name, fn_name and message, with a default for metadata",
      function()
        local err =
          require("mona.lib.result")("mod_name").err("failure", nil, "fn_name")

        local expected_err = {
          err = {
            mod_name = "mod_name",
            fn_name = "fn_name",
            message = "failure",
            metadata = {},
          },
        }

        assert.same(expected_err, err)
      end
    )

    it(
      "should return an err which contains mod_name, fn_name, message and metadata",
      function()
        local err = require("mona.lib.result")("mod_name").err(
          "failure",
          { metadata = "metadata" },
          "fn_name"
        )

        local expected_err = {
          err = {
            mod_name = "mod_name",
            fn_name = "fn_name",
            message = "failure",
            metadata = { metadata = "metadata" },
          },
        }

        assert.same(expected_err, err)
      end
    )

    describe("factory", function()
      it("should throw an error if fn_name is nil", function()
        assert.has_error(function()
          require("mona.lib.result")("mod_name").err.factory(nil)
        end)
      end)

      it("should capture fn_name", function()
        local err = require("mona.lib.result")("mod_name").err.factory(
          "fn_name"
        )("failure", { metadata = "metadata" })

        local expected_err = {
          err = {
            mod_name = "mod_name",
            fn_name = "fn_name",
            message = "failure",
            metadata = { metadata = "metadata" },
          },
        }

        assert.same(expected_err, err)
      end)
    end)
  end)

  describe("is_ok", function()
    it("should throw an error if ok_or_err is nil", function()
      assert.has_error(function()
        require("mona.lib.result")("mod_name").is_ok(nil)
      end)
    end)

    it("should return true if ok_or_err is an ok", function()
      local result = require("mona.lib.result")("mod_name")

      local ok = result.ok("success")

      local is_ok = result.is_ok(ok)

      assert.is_true(is_ok)
    end)

    it("should return false if ok_or_err is not an ok", function()
      local result = require("mona.lib.result")("mod_name")

      local is_ok = result.is_ok

      assert.is_false(is_ok(1))
      assert.is_false(is_ok(""))
      assert.is_false(is_ok(true))
      assert.is_false(is_ok({}))
      assert.is_false(is_ok({ 1, 2, 3 }))
      assert.is_false(is_ok({ value = "" }))
      assert.is_false(is_ok(result.err("failure")))
    end)
  end)

  describe("is_err", function()
    it("should throw an error if ok_or_err is nil", function()
      assert.has_error(function()
        require("mona.lib.result")("mod_name").is_err(nil)
      end)
    end)

    it("should return true if ok_or_err is an err", function()
      local result = require("mona.lib.result")("mod_name")

      local err = result.err("failure")

      local is_err = result.is_err(err)

      assert.is_true(is_err)
    end)

    it("should return false if ok_or_err is not an err", function()
      local result = require("mona.lib.result")("mod_name")

      local is_err = result.is_err

      assert.is_false(is_err(1))
      assert.is_false(is_err(""))
      assert.is_false(is_err(true))
      assert.is_false(is_err({}))
      assert.is_false(is_err({ 1, 2, 3 }))
      assert.is_false(is_err({ value = "" }))
      assert.is_false(is_err(result.ok("success")))
    end)
  end)

  describe("unwrap", function()
    it("should throw an error if ok_or_err_fn is nil", function()
      assert.has_error(function()
        require("mona.lib.result")("mod_name").unwrap(nil)
      end)
    end)

    it(
      "should throw an error if ok_or_err_fn does not return an ok or err",
      function()
        assert.has_error(function()
          require("mona.lib.result")("mod_name").unwrap(function()
            return "success"
          end)()
        end)
      end
    )

    it("should return an unwrapped ok if ok_or_err_rn returns an ok", function()
      local result = require("mona.lib.result")("mod_name")

      local unwrapped = result.unwrap(function()
        return result.ok("success")
      end)()

      assert.same("success", unwrapped)
    end)

    it(
      "should return an unwrapped err if ok_or_err_rn returns an err",
      function()
        local result = require("mona.lib.result")("mod_name")

        local inner_value = result.unwrap(function()
          return result.err("failure")
        end)()

        local expected_inner_value = {
          fn_name = "",
          message = "failure",
          metadata = {},
          mod_name = "mod_name",
        }

        assert.same(expected_inner_value, inner_value)
      end
    )

    describe("ok", function()
      it("should throw an error if on_ok_fn is nil", function()
        local result = require("mona.lib.result")("mod_name")

        assert.has_error(function()
          result
            .unwrap(function()
              return result.ok("success")
            end)
            .ok(nil)()
        end)
      end)

      it(
        "should return the result of on_ok_fn if ok_or_err_fn returns an ok",
        function()
          local result = require("mona.lib.result")("mod_name")

          local value = result
            .unwrap(function()
              return result.ok("success")
            end)
            .ok(function(value)
              return value .. "!"
            end)()

          assert.same("success!", value)
        end
      )

      it(
        "should return the result of unwrap if ok_or_err_fn returns an err",
        function()
          local result = require("mona.lib.result")("mod_name")

          local value = result
            .unwrap(function()
              return result.err("failure")
            end)
            .ok(function(value)
              return value .. "!"
            end)()

          local expected_value = {
            fn_name = "",
            message = "failure",
            metadata = {},
            mod_name = "mod_name",
          }

          assert.same(expected_value, value)
        end
      )

      describe("err", function()
        it("should throw an error if on_err_fn is nil", function()
          local result = require("mona.lib.result")("mod_name")

          assert.has_error(function()
            result
              .unwrap(function()
                return result.err("failure")
              end)
              .ok(function(value)
                return value .. "!"
              end)
              .err(nil)()
          end)
        end)

        it(
          "should return the result of on_err_fn if ok_or_err returns an err",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.err("failure")
              end)
              .ok(function(value)
                return value .. "!"
              end)
              .err(function(err)
                err.message = err.message .. "!"

                return err
              end)()

            local expected_value = {
              fn_name = "",
              message = "failure!",
              metadata = {},
              mod_name = "mod_name",
            }

            assert.same(expected_value, value)
          end
        )

        it(
          "should return the result of ok if ok_or_err_fn returns an ok",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.ok("success")
              end)
              .ok(function(value)
                return value .. "!"
              end)
              .err(function(err)
                err.message = err.message .. "!"

                return err
              end)()

            assert.same("success!", value)
          end
        )

        describe("rewrap", function()
          it(
            "should throw an error if err does not return a table containing a message",
            function()
              local result = require("mona.lib.result")("mod_name")

              assert.has_error(function()
                local value = result
                  .unwrap(function()
                    return result.err("failure")
                  end)
                  .ok(function(value)
                    return value .. "!"
                  end)
                  .err(function(err)
                    return ""
                  end)
                  .rewrap()
              end)
            end
          )

          it(
            "should return the result of err within an err if ok_or_err_fn returns an err",
            function()
              local result = require("mona.lib.result")("mod_name")

              local value = result
                .unwrap(function()
                  return result.err("failure")
                end)
                .ok(function(value)
                  return value .. "!"
                end)
                .err(function(err)
                  err.message = err.message .. "!"

                  return err
                end)
                .rewrap()

              local expected_value = {
                err = {
                  fn_name = "",
                  message = "failure!",
                  metadata = {},
                  mod_name = "mod_name",
                },
              }

              assert.same(expected_value, value)
            end
          )

          it(
            "should return the result of ok within an ok if ok_or_err_fn returns an ok",
            function()
              local result = require("mona.lib.result")("mod_name")

              local value = result
                .unwrap(function()
                  return result.ok("success")
                end)
                .ok(function(value)
                  return value .. "!"
                end)
                .err(function(err)
                  err.message = err.message .. "!"

                  return err
                end)
                .rewrap()

              local expected_value = {
                ok = "success!",
              }

              assert.same(expected_value, value)
            end
          )
        end)
      end)

      describe("rewrap", function()
        it(
          "should return the result of ok within an ok if ok_or_err_fn returns an ok",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.ok("success")
              end)
              .ok(function(value)
                return value .. "!"
              end)
              .rewrap()

            local expected_value = {
              ok = "success!",
            }

            assert.same(expected_value, value)
          end
        )

        it(
          "should return the result of unwrap within an err if ok_or_err_fn returns an err",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.err("failure")
              end)
              .ok(function(value)
                return value
              end)
              .rewrap()

            local expected_value = {
              err = {
                fn_name = "",
                message = "failure",
                metadata = {},
                mod_name = "mod_name",
              },
            }

            assert.same(expected_value, value)
          end
        )
      end)
    end)

    describe("err", function()
      it("should throw an error if on_err_fn is nil", function()
        local result = require("mona.lib.result")("mod_name")

        assert.has_error(function()
          result
            .unwrap(function()
              return result.err("failure")
            end)
            .err(nil)()
        end)
      end)

      it(
        "should throw an error if err does not return a table containing a message",
        function()
          local result = require("mona.lib.result")("mod_name")

          assert.has_error(function()
            local value = result
              .unwrap(function()
                return result.err("failure")
              end)
              .err(function(err)
                return ""
              end)
              .rewrap()
          end)
        end
      )

      it(
        "should return the result of on_err_fn if ok_or_err returns an err",
        function()
          local result = require("mona.lib.result")("mod_name")

          local value = result
            .unwrap(function()
              return result.err("failure")
            end)
            .err(function(err)
              err.message = err.message .. "!"

              return err
            end)()

          local expected_value = {
            fn_name = "",
            message = "failure!",
            metadata = {},
            mod_name = "mod_name",
          }

          assert.same(expected_value, value)
        end
      )

      it(
        "should return the result of unwrap if ok_or_err_fn returns an ok",
        function()
          local result = require("mona.lib.result")("mod_name")

          local value = result
            .unwrap(function()
              return result.ok("success")
            end)
            .err(function(err)
              err.message = err.message .. "!"

              return err
            end)()

          assert.same("success", value)
        end
      )

      describe("rewrap", function()
        it(
          "should return the result of err within an err if ok_or_err_fn returns an err",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.err("failure")
              end)
              .err(function(err)
                err.message = err.message .. "!"

                return err
              end)
              .rewrap()

            local expected_value = {
              err = {
                fn_name = "",
                message = "failure!",
                metadata = {},
                mod_name = "mod_name",
              },
            }

            assert.same(expected_value, value)
          end
        )

        it(
          "should return the result of unwrap within an ok if ok_or_err_fn returns an ok",
          function()
            local result = require("mona.lib.result")("mod_name")

            local value = result
              .unwrap(function()
                return result.ok("success")
              end)
              .err(function(value)
                err.message = err.message .. "!"

                return err
              end)
              .rewrap()

            local expected_value = {
              ok = "success",
            }

            assert.same(expected_value, value)
          end
        )
      end)
    end)
  end)
end)
