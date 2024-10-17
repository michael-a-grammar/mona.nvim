local callable_table = require("mona.constructs.callable_table")

local assert_argument = require("mona.constructs.assert_argument")(...)

local assert_argument_factory = assert_argument.factory

local error_factory = require("mona.constructs.error")(...).factory

return callable_table(function(mod_name)
  assert_argument(mod_name, "mod_name")

  local M = {}

  function M.ok(value)
    assert_argument_factory("ok")(value, "value")

    return {
      ok = value,
    }
  end

  M.err = callable_table(function(message, metadata, fn_name)
    assert_argument_factory("err")(message, "message")

    return {
      err = {
        mod_name = mod_name,
        fn_name = fn_name or "",
        message = message,
        metadata = metadata or {},
      },
    }
  end)

  function M.is_ok(ok_or_err)
    assert_argument_factory("is_ok")(ok_or_err, "ok_or_err")

    return type(ok_or_err) == "table" and ok_or_err.ok ~= nil
  end

  function M.is_err(ok_or_err)
    assert_argument_factory("is_err")(ok_or_err, "ok_or_err")

    return type(ok_or_err) == "table" and ok_or_err.err ~= nil
  end

  function M.unwrap(ok_or_err_fn)
    assert_argument_factory("unwrap")(ok_or_err_fn, "ok_or_err_fn")

    local function default_value(value)
      return value
    end

    local state = {
      on_ok_fn = default_value,
      on_err_fn = default_value,
    }

    local function set_on_ok_fn(on_ok_fn)
      state.on_ok_fn = on_ok_fn
    end

    local function set_on_err_fn(on_err_fn)
      state.on_err_fn = on_err_fn
    end

    local unwrap = callable_table(function()
      local ok_or_err = ok_or_err_fn()

      local is_ok, is_err = M.is_ok(ok_or_err), M.is_err(ok_or_err)

      if is_ok then
        return state.on_ok_fn(ok_or_err.ok), true
      elseif is_err then
        return state.on_err_fn(ok_or_err.err), false
      else
        error_factory("unwrap")(
          "the result of ok_or_err_fn is not a table with either an ok or err field"
        )
      end
    end)

    local function rewrap()
      local unwrapped, is_ok = unwrap()

      if is_ok then
        return M.ok(unwrapped)
      else
        return M.err(unwrapped.message, unwrapped.metadata, unwrapped.fn_name)
      end
    end

    local function err(fn_name)
      return function(on_err_fn)
        assert_argument_factory(fn_name .. ".err")(on_err_fn, "on_err_fn")

        set_on_err_fn(on_err_fn)

        local err = callable_table(unwrap)

        err.rewrap = rewrap

        return err
      end
    end

    unwrap.ok = function(on_ok_fn)
      local fn_name = "unwrap.ok"

      assert_argument_factory(fn_name)(on_ok_fn, "on_ok_fn")

      set_on_ok_fn(on_ok_fn)

      local ok = callable_table(unwrap)

      ok.err = err(fn_name)

      ok.rewrap = rewrap

      return ok
    end

    unwrap.err = err("unwrap")

    return unwrap
  end

  function M.err.factory(fn_name)
    assert_argument_factory("err.factory")(fn_name, "fn_name")

    return function(message, metadata)
      assert_argument(message, "message")

      return M.err(message, metadata, fn_name)
    end
  end

  return M
end)
