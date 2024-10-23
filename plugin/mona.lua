local notify = require("mona.notify")("nvim")()

if vim.fn.executable("rg") ~= 1 then
  notify.error(
    "mona requires ripgrep, please visit https://github.com/BurntSushi/ripgrep"
  )
end
