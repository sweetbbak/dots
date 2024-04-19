-- using packer.nvim
return {
    "nmac427/guess-indent.nvim",
    config = function()
        require("guess-indent").setup({
            auto_cmd = true, -- set to false to disable autoindent
            override_editorconfig = false, -- Set to true to override settings set by .editorconfig
            filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
                "netrw",
                "tutor",
            },
            buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
                "help",
                "nofile",
                "terminal",
                "prompt",
            },
        })
    end,
}
