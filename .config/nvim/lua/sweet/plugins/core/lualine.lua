return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        -- local lazy_status = require("lazy.status") -- to configure lazy pending updates count
        -- configure lualine with modified theme
        lualine.setup({
            options = {
                theme = "auto",
                icons_enabled = true,
                component_separators = "|",
                section_separators = "",
            },
        })
    end,
}
