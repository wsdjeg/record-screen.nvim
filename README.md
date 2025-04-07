# record-screen.nvim


## Installation

using [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    {
        'D:/wsdjeg/record-screen.nvim',
        config = function()
            vim.keymap.set(
                'n',
                '<F8>',
                '<cmd>lua require("record-screen").start()<cr>',
                { silent = true }
            )
            vim.keymap.set(
                'n',
                '<F9>',
                '<cmd>lua require("record-screen").stop()<cr>',
                { silent = true }
            )
        end,
    },
})
```

## Setup

```lua
require('record-screen').setup({
    target_dir = 'D:/outputs'
})
```
