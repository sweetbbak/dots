return {
    "p00f/godbolt.nvim",
    config = function()
        require("godbolt").setup({
            languages = {
                cpp = { compiler = "g122", options = {} },
                c = { compiler = "cg122", options = {} },
                rust = { compiler = "r1650", options = {} },
                -- any_additional_filetype = { compiler = ..., options = ... },
            },
            quickfix = {
                enable = false, -- whether to populate the quickfix list in case of errors
                auto_open = false, -- whether to open the quickfix list in case of errors
            },
            url = "https://godbolt.org", -- can be changed to a different godbolt instance
        })
    end,
}
