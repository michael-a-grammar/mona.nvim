# 🧪 mona.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A set of `elixir` extensions and configuration for [neovim](https://neovim.io/)!

> [!IMPORTANT]
**Please note** that this is not a replacement for the various LSP implementations available for `elixir`; it is solely some
goodies that I find nice when programming my favourite language in my favourite editor

As `mona` doesn't use any fancy LSP shenanigans, it is blindingly fast but may prove to be naive in implementation

We simply rely on regular expressions and conventions in order to _work things_ out - if you consider using `mona`, please report any inconsistencies!

## ✨ Features

- Browse project, application and current buffer directory modules _and_ tests using [telescope!](https://github.com/nvim-telescope/telescope.nvim)

## 💻 Install

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

## 🚀 Usage

> [!NOTE]
You don't *strictly* have to do the below if you don't mind `elixir`-specific shortcuts clobbering your keymap!

- Create a `elixir` _filetype_ plugin where your `neovim` configuration resides (typically *~/.config/nvim/*) if one doesn't already exist

```bash
if [ ! -f ~/.config/nvim/after/ftplugin/elixir.lua ]; then
    mkdir -p ~/.config/nvim/after/ftplugin/
    touch ~/.config/nvim/after/ftplugin/elixir.lua
fi
```

- Add the following keymap to the above file to bind searching for `elixir` modules within your current project

> [!NOTE]
Or, as above, if you're not fussed about the shortcut being set for _every_ filetype, add it to where you usually define keymaps


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

### 🔭 Telescope Pickers

`mona` exposes the following `telescope` pickers as well as the `elixir_project_modules` picker shown in the example above

#### elixir_project_modules

To discern the root, _project_ directory:

- From the current _working directory_, we attempt to find a _.git_ directory by searching upwards through the directory tree

- We relay an error message if a _.git_ directory cannot be found

- Within the directory that the _.git_ directory is found, we check for the existence of a _mix.exs_ file

- From here, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file

#### elixir_application_modules

To discern the _application_ directory:

From the current _buffer directory_, we attempt to find a _mix.exs_ file by searching upwards through the directory tree

- We relay an error message if a _mix.exs_ file cannot be found or if the found _mix.exs_ file is the _project_-level one

- From here, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file

#### elixir_buffer_directory_modules

From the current _buffer_ directory, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file

#### elixir_project_tests

Same as `elixir_project_modules` except the `ripgrep` query is configured to find descendant `.exs` files

#### elixir_application_tests

Same as `elixir_application_modules` except the `ripgrep` query is configured to find descendant `.exs` files

#### elixir_buffer_directory_tests

Same as `elixir_buffer_directory_modules` except the `ripgrep` query is configured to find descendant `.exs` files

## 💕 Coming Soon

- *Improved* module navigation
