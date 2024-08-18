-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
}
