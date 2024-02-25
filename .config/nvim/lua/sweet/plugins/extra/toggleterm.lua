return {
    "akinsho/toggleterm.nvim",
    version = "*",

    -- 'akinsho/toggleterm.nvim', version = "*", config = true
    config = function()
        require("toggleterm").setup({
            persist_size = false,
            direction = "float",
        })

        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Hide terminal" })
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Hide terminal" })
    end,
}
