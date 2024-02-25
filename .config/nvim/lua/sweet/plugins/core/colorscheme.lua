return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme kanagawa]])
        end,
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        config = function()
            -- load the colorscheme here
            -- vim.cmd([[colorscheme oxocarbon]])
        end,
    },

    { "tanvirtin/monokai.nvim" },
}
