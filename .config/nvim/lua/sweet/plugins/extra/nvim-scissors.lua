return {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    opts = {
        snippetDir = "/home/sweet/.snippets",
    },

    require("luasnip.loaders.from_vscode").lazy_load({ paths = { "/home/sweet/.snippets" } }),

    -- When used in visual mode prefills the selection as body.
    vim.keymap.set("n", "<leader>si", function()
        require("scissors").editSnippet()
    end),
    vim.keymap.set({ "n", "x" }, "<leader>sa", function()
        require("scissors").addNewSnippet()
    end),
}
