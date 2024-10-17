return setmetatable({}, {
  __call = function(_, call_fn)
    assert(call_fn)

    return setmetatable({}, {
      __call = function(_, ...)
        return call_fn(...)
      end,
    })
  end,
})
