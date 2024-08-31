-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        'Mofiqul/vscode.nvim',
        config = function()
            -- Lua:
            -- For dark theme (neovim's default)
            vim.o.background = 'dark'
            -- For light theme
            -- vim.o.background = 'light'

            local c = require('vscode.colors').get_colors()
            require('vscode').setup({
                -- Alternatively set style in setup
                -- style = 'light'

                -- Enable transparent background
                transparent = true,

                italic_comments = false,

                -- Underline `@markup.link.*` variants
                underline_links = true,

                -- Disable nvim-tree background color
                disable_nvimtree_bg = true,

                -- Override highlight groups (see ./lua/vscode/theme.lua)
                group_overrides = {
                    -- this supports the same val table as vim.api.nvim_set_hl
                    -- use colors from this colorscheme by requiring vscode.colors!
                    Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
                }
            })
            require('vscode').load()

            -- load the theme without affecting devicon colors.
            vim.cmd.colorscheme "vscode"
        end
    },
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({
                easing = 'cubic',
                hide_cursor = true,
            })
        end
    },
    {
        'ggandor/leap.nvim',
        version = "*",
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, '<S-Space>', '<Plug>(leap-forward-to)', { silent = true })
            vim.keymap.set({ 'n', 'x', 'o' }, '<S-BS>', '<Plug>(leap-backward-to)', { silent = true })
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end
    },
    {
        "nvim-neorg/neorg",
        lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        config = true,
    },
}
