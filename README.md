# 🧪 mona.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/michael-a-grammar/mona.nvim/test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)

A set of `elixir` extensions and configuration for [neovim](https://neovim.io/)!

> [!IMPORTANT]
**Please note** that this is not a replacement for the various LSP implementations available for `elixir`; it is solely some goodies that I find nice when programming with my favourite language in my favourite editor

As `mona` doesn't use any fancy LSP shenanigans, it is blindingly fast (thanks to `ripgrep`!) but may prove to be naive in implementation

We rely on regular expressions and conventions in order to work _things_ out - if you consider using `mona`, please report any inconsistencies!

## ✨ Features

Browse project, `umbrella` application and buffer directory modules _and_ tests using [telescope!](https://github.com/nvim-telescope/telescope.nvim)

## 🚀 Install

Requires [ripgrep](https://github.com/BurntSushi/ripgrep)

Using [lazy.nvim](https://github.com/folke/lazy.nvim), here is an example _plugin spec_ utilising lazy loading and filetype-specific keymaps

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
      '<localleader>mm',
      function()
        require('telescope').extensions.mona.pickers()
      end,
      desc = 'Browse Pickers',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>mp',
      function()
        require('telescope').extensions.mona.elixir_project_modules()
      end,
      desc = 'Browse Project Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>ma',
      function()
        require('telescope').extensions.mona.elixir_application_modules()
      end,
      desc = 'Browse Application Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>mb',
      function()
        require('telescope').extensions.mona.elixir_buffer_directory_modules()
      end,
      desc = 'Browse Buffer Directory Modules',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>mtp',
      function()
        require('telescope').extensions.mona.elixir_project_tests()
      end,
      desc = 'Browse Project Tests',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>mta',
      function()
        require('telescope').extensions.mona.elixir_application_tests()
      end,
      desc = 'Browse Application Tests',
      ft = 'elixir',
      mode = { 'n', 'x' },
    },

    {
      '<localleader>mtb',
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

Next, add the following to your `telescope` *plugin spec*  to load the `mona` `telescope` extension

```lua
return {
  'nvim-telescope/telescope.nvim',

  ...

  config = function(_, opts)
   local telescope = require('telescope')

    ...

    telescope.load_extension('mona')
  end
}
```

`mona` also supports `telescope`-specific configuration being set as a part of the `telescope` _plugin spec_

Here is an example that changes the default theme of all the `telescope` pickers exposed by `mona`

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
          theme = 'dropdown',
        },
      },
    },
  },
}
```

You can also pass such configuration directly into the function call of a relevant picker like so

```lua
require('telescope').extensions.mona.elixir_project_modules(
  require('telescope.themes').get_dropdown({
    ...
  })
)
```

## 🔭 Telescope Pickers

`mona` exposes the following `telescope` pickers

| Picker                            | Displays                                             | Excludes            | Scope                              |
| --------------------------------- | ---------------------------------------------------- | ------------------- | ---------------------------------- |
| `pickers`                         | All of the the `telescope` pickers exposed by `mona` | N/A                 | N/A                                |
| `elixir_project_modules`          | Modules                                              | Tests and scripts   | _Project_ directory                |
| `elixir_application_modules`      | Modules                                              | Tests and scripts   | `Umbrella` _application_ directory | 
| `elixir_buffer_directory_modules` | Modules                                              | Tests and scripts   | _Buffer_ directory                 | 
| `elixir_project_tests`            | Tests                                                | Modules and scripts | _Project_ directory                |
| `elixir_application_tests`        | Tests                                                | Modules and scripts | `Umbrella` _application_ directory | 
| `elixir_buffer_directory_tests`   | Tests                                                | Modules and scripts | _Buffer_ directory                 |

Each picker relies on convention to find relevant results, please see the [vim documentation](doc/mona.nvim.txt) for further information

## 🕰️ Coming Soon

- *Improved* module and test navigation

## 💕 Attributions

Projects that have either inspired or helped with the development of `mona`

- [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template)
- [elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim)
- [neogit](https://github.com/NeogitOrg/neogit)
- [telescope.nvim/developers.md](https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md)
- [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)

`mona` is also a part of my personal [neovim](https://neovim.io/) setup, [vamp](https://github.com/michael-a-grammar/vamp) 🎷
