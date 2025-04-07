# record-screen.nvim

record-screen.nvim is a Neovim screen recording plugin that uses [ffmpeg](https://www.ffmpeg.org/) command for screen recording.

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Setup](#setup)
* [Recording Example](#recording-example)
* [Debug](#debug)
* [Self-Promotion](#self-promotion)

<!-- vim-markdown-toc -->

## Installation

using [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    {
        'wsdjeg/record-screen.nvim',
        depends = {
            { 'wsdjeg/job.nvim' },
            { 'wsdjeg/notify.nvim' },
        },
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
    cmd = 'ffmpeg',
    argvs = { '-f', 'gdigrab', '-i', 'desktop', '-f', 'mp4' },
    target_dir = 'D:/outputs',
})
```

## Recording Example

https://github.com/user-attachments/assets/9fc2c7c2-e59b-4759-8cfe-991126bd95d3

## Debug

You can enable logger and install logger.nvim to debug this plugin:

```lua
require('plug').add({
    {
        'wsdjeg/record-screen.nvim',
        depends = {
            { 'wsdjeg/job.nvim' },
            { 'wsdjeg/notify.nvim' },
            {
                'wsdjeg/logger.nvim',
                config = function()
                    vim.keymap.set(
                        'n',
                        '<leader>hL',
                        '<cmd>lua require("logger").viewRuntimeLog()<cr>',
                        { silent = true }
                    )
                end,
            },
        },
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

and the runtime log is:

```
[ record-screen.nvim ] [01:15:45:587] [ Info  ] cmd is: { "ffmpeg", "-f", "gdigrab", "-i", "desktop", "-f", "mp4", "C:/Users/wsdjeg/Desktop/2025-4-8-1-15-45.mp4" }
[ record-screen.nvim ] [01:15:47:794] [ Info  ] job exit with: code 0 single 0
```



## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) and
[Twitter](http://twitter.com/wsdtty).
