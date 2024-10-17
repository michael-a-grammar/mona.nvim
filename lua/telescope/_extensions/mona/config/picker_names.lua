local function prefix_with_elixir(picker_name)
  return "elixir_" .. picker_name
end

return {
  included_pickers = "pickers",
  test_modules = prefix_with_elixir("test_modules"),
}
