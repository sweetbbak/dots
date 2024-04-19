return {
    "jvgrootveld/telescope-zoxide",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",
        "nvim-telescope/telescope.nvim",
    },

    config = function()
        local t = require("telescope")
        -- local zutils = require("telescope._extensions.zoxide.utils")
        -- t.setup()
        t.load_extension("zoxide")
        vim.keymap.set("n", "<leader>cd", t.extensions.zoxide.list)
    end,
}
