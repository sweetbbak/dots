return {
    { "echasnovski/mini.move", version = false },
    {
        "echasnovski/mini.move",
        version = false,
        config = function()
            require("mini.move").setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = "<A-h>",
                    right = "<A-l>",
                    down = "<A-j>",
                    up = "<A-k>",

                    -- Move current line in Normal mode
                    line_left = "<A-h>",
                    line_right = "<A-l>",
                    line_down = "<A-j>",
                    line_up = "<A-k>",
                },

                -- Options which control moving behavior
                options = {
                    -- Automatically reindent selection during linewise vertical move
                    reindent_linewise = true,
                },
            })
        end,
    },
    -- {
    --     "echasnovski/mini.animate",
    --     version = false,
    --     config = function()
    --         require("mini.animate").setup()
    --     end,
    -- },
    {
        "echasnovski/mini.cursorword",
        version = false,
        config = function()
            require("mini.cursorword").setup()
        end,
    },
    {
        "echasnovski/mini.map",
        version = false,
        config = function()
            require("mini.map").setup()
        end,
        vim.keymap.set(
            "n",
            "<leader>mm",
            "<cmd>lua MiniMap.toggle()<CR>",
            { desc = "Show side bar map view of entire document" }
        ), -- close current split window
    },
}
