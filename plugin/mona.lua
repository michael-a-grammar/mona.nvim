if vim.fn.executable("rg") ~= 1 then
  require("mona.notify")("mona.nvim").error(
    "mona requires ripgrep, please visit https://github.com/BurntSushi/ripgrep"
  )
end
