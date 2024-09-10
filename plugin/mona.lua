if vim.fn.executable('rg') ~= 1 then
  error(
    'mona requires ripgrep, please visit https://github.com/BurntSushi/ripgrep'
  )
end
