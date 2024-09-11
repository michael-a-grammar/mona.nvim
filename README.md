# 🧪 mona.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A set of `elixir` extensions and configuration for [neovim](https://neovim.io/)!

> [!IMPORTANT]
**Please note** that this is not a replacement for the various LSP implementations available for `elixir`; it is solely some
goodies that I find nice when programming with my favourite language in my favourite editor

As `mona` doesn't use any fancy LSP shenanigans, it is blindingly fast (thanks to `ripgrep`!) but may prove to be naive in implementation

We rely on regular expressions and conventions in order to work _things_ out - if you consider using `mona`, please report any inconsistencies!

## ✨ Features

- Browse project, application and current buffer directory modules _and_ tests using [telescope!](https://github.com/nvim-telescope/telescope.nvim)

## 🚀 Install

- Requires [ripgrep](https://github.com/BurntSushi/ripgrep)

Using [lazy.nvim](https://github.com/folke/lazy.nvim), here is an example _plugin spec_ utilising lazy loading and filetype-specific keymaps

<details>
```lua
return {
  'michael-a-grammar/mona.nvim',

  ft = 'elixir',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },

  keys = {
    {
      '<leader>mp',
      function()
        require('telescope').extensions.mona.elixir_project_modules()
      end,
      desc = 'Browse Project Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<leader>ma',
      function()
        require('telescope').extensions.mona.elixir_application_modules()
      end,
      desc = 'Browse Application Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<leader>mb',
      function()
        require('telescope').extensions.mona.elixir_buffer_directory_modules()
      end,
      desc = 'Browse Buffer Directory Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<leader>mtp',
      function()
        require('telescope').extensions.mona.elixir_project_tests()
      end,
      desc = 'Browse Project Tests',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<leader>mta',
      function()
        require('telescope').extensions.mona.elixir_application_tests()
      end,
      desc = 'Browse Application Tests',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<leader>mtb',
      function()
        require('telescope').extensions.mona.elixir_buffer_directory_tests()
      end,
      desc = 'Browse Buffer Directory Tests',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },
  }
}
```
</details>

- Alternatively, rather than utilising an anonymous function wrapper, you can call a `telescope` picker within a keymap via the following syntax 

`<cmd>Telescope mona elixir_project_modules<cr>`

- Or you can call a `telescope` picker directly using the following `vim` command

`:Telescope mona elixir_project_modules`

> [!TIP]
You can load the `telescope` extension early within your `telescope` configuration to get tab completion when typing the above `vim` command, example below

```lua
local telescope = require('telescope')

telescope.load_extension('mona')
```

`mona` also supports `telescope`-specific configuration being set as a part of the `telescope` _plugin spec_ 

Here is an example that changes the default theme of all the `telescope` pickers exposed by `mona`

<details>
```lua

return {
  'nvim-telescope/telescope.nvim',

   ...

   opts = {
     defaults = {
       mappings = {
         ...
       },
      
      extensions = {
        mona = {
          theme = 'ivy',
        },
      },
    },
  },
}

```
</details>

You can also pass such configuration directly into the function call of a relevant picker like so

<details>
```lua
require('telescope').extensions.mona.elixir_project_modules(
  require('telescope.themes').get_ivy({
    layout_config = {
      height = 35
    },
  })
)
```
</details>

## 🔭 Telescope Pickers

`mona` exposes the following `telescope` pickers, each relying on convention to find relevant results, disclosed below

<details>
#### elixir_project_modules

To discern the root, _project_ directory:

- From the current _working directory_, we attempt to find a _.git_ directory by searching upwards through the directory tree

- We relay an error message if a _.git_ directory cannot be found

- Within the directory that the _.git_ directory is found, we check for the existence of a _mix.exs_ file

- From here, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file that contains one or more module definitions

#### elixir_application_modules

To discern the _application_ directory:

- From the current _buffer directory_, we attempt to find a _mix.exs_ file by searching upwards through the directory tree

- We relay an error message if a _mix.exs_ file cannot be found or if the found _mix.exs_ file is the _project_-level one

- From here, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file that contains one or more module definitions

#### elixir_buffer_directory_modules

From the current _buffer_ directory, a simple `ripgrep` query is launched to populate a `telescope` picker with every descendant `.ex` file that contains one or more module definitions

#### tests

There are also equivalents to each of the above available specifically for tests

These work in much the same way except each `ripgrep` query is configured to find descendant `.exs` files that contain one or more module definitions suffixed with `test`

- `elixir_project_tests`
- `elixir_application_tests`
- `elixir_buffer_directory_tests`
</details>

## 🕰️ Coming Soon

- *Improved* module navigation

## 💕 Attributions

Projects that have either inspired or helped with the development of `mona`

- [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template)
- [elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim)
- [neogit](https://github.com/NeogitOrg/neogit)
- [telescope.nvim/developers.md](https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md)
- [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)

`mona` is also a part of my personal [neovim](https://neovim.io/) setup, [vamp](https://github.com/michael-a-grammar/vamp) 🎷
