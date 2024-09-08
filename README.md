# mona.nvim

A set of `elixir` extensions and configuration for [neovim](https://neovim.io/)!

> [!IMPORTANT]
**Please note** that this is not a replacement for the various LSP implementations available for `elixir`; it is solely some
goodies that I find nice when programming my favourite language in my favourite editor

## Features

- Browse project, application and current buffer directory modules using [telescope!](https://github.com/nvim-telescope/telescope.nvim)

## Install

- Requires [ripgrep](https://github.com/BurntSushi/ripgrep)

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  'michael-a-grammar/mona.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
}
```

## Usage

> [!NOTE]
You don't *strictly* have to do the below if you don't mind `elixir` shortcuts clobbering your non-specific keymap!

- Create a `elixir` filetype plugin where your `neovim` resides (typically *~/.config/nvim/*) if one doesn't already exist

```bash
if [ ! -f ~/.config/nvim/after/ftplugin/elixir.lua ]; then
    mkdir -p ~/.config/nvim/after/ftplugin/
    touch ~/.config/nvim/after/ftplugin/elixir.lua
fi
```

- Add the following keymap to the above file 

> [!NOTE]
Or, as above, if you're not fussed about the shortcut being global for every filetype, add it to where you usually define keymaps


```lua
local mona = require('telescope').extensions.mona
local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set({ 'n', 'x' }, '<leader>mp', mona.elixir_project_modules, {
  desc = 'Project Modules',
  buffer = bufnr, -- exclude setting this key if not defining the keymap within the `elixir` filetype plugin
  noremap = true,
})

```

You can also call the `telescope` picker via the following `vim` command - `:Telescope mona elixir_project_modules`

`elixir_application_modules` and `elixir_browser_directory_modules` are also exposed by the above

> [!TIP]
You can load the `telescope` extension early to get tab completion when typing the above command

```lua
local telescope = require('telescope')

telescope.load_extension('mona')
```

## Coming Soon

- Browse *project-wide test* modules
- Browse *current application test* modules
- Browse _current buffer directory test_ modules
- *Improved* go to a module using `gf`
