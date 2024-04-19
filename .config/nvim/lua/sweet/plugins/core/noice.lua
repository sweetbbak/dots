-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },

        config = function()
            require("noice").setup({
                routes = {
                    {
                        view = "notify",
                        filter = {
                            event = "msg_showmode",
                            kind = "",
                            find = "written",
                        },
                        opts = { skip = true },
                    },
                    { filter = { find = "E162" }, view = "mini" },
                    { filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
                    { filter = { event = "msg_showmode", kind = "", find = "INSERT" }, view = "mini" },
                    { filter = { event = "msg_showmode", kind = "", find = "VISUAL" }, view = "mini" },
                    { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
                    { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
                    { filter = { event = "emsg", find = "E23" }, skip = true },
                    { filter = { event = "emsg", find = "E20" }, skip = true },
                    { filter = { find = "No signature help" }, skip = true },
                    { filter = { find = "E37" }, skip = true },
                },

                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                -- presets = {
                -- bottom_search = false, -- use a classic bottom cmdline for search
                -- command_palette = false, -- position the cmdline and popupmenu together
                -- long_message_to_split = true, -- long messages will be sent to a split
                -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
                -- lsp_doc_border = false, -- add a border to hover docs and signature help
                -- },
                cmdline = {
                    enabled = true,
                    view = "cmdline_popup",
                    opts = {},
                    format = {
                        cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
                        search_down = {
                            view = "cmdline",
                            kind = "Search",
                            pattern = "^/",
                            icon = "🔎 ",
                            ft = "regex",
                        },
                        search_up = {
                            view = "cmdline",
                            kind = "Search",
                            pattern = "^%?",
                            icon = "🔎 ",
                            ft = "regex",
                        },
                        input = { icon = "✏️ ", ft = "text", opts = cmdline_opts },
                        calculator = { pattern = "^=", icon = "", lang = "vimnormal", opts = cmdline_opts },
                        substitute = {
                            pattern = "^:%%?s/",
                            icon = "🔁",
                            ft = "regex",
                            opts = { border = { text = { top = " sub (old/new/) " } } },
                        },
                        filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
                        filefilter = {
                            kind = "Filter",
                            pattern = "^:%s*%%%s*!",
                            icon = "📄 $",
                            ft = "sh",
                            opts = cmdline_opts,
                        },
                        selectionfilter = {
                            kind = "Filter",
                            pattern = "^:%s*%'<,%'>%s*!",
                            icon = " $",
                            ft = "sh",
                            opts = cmdline_opts,
                        },
                        lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
                        rename = {
                            pattern = "^:%s*IncRename%s+",
                            icon = "✏️ ",
                            conceal = true,
                            opts = {
                                relative = "cursor",
                                size = { min_width = 20 },
                                position = { row = -3, col = 0 },
                                buf_options = { filetype = "text" },
                                border = { text = { top = " rename " } },
                            },
                        },
                        help = { pattern = "^:%s*h%s+", icon = "💡", opts = cmdline_opts },
                    },
                },
                popupmenu = {
                    enabled = true,
                    backend = "nui",
                    -- backend = "cmp",
                },
                messages = {
                    view_search = false,
                },
                views = {
                    cmdline_popup = {
                        position = {
                            row = 5,
                            col = "50%",
                        },
                        size = {
                            width = 60,
                            height = "auto",
                        },
                    },
                    popupmenu = {
                        relative = "editor",
                        position = {
                            row = 8,
                            col = "50%",
                        },
                        size = {
                            width = 60,
                            height = 10,
                        },
                        border = {
                            style = "rounded",
                            padding = { 0, 1 },
                        },
                        win_options = {
                            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                        },
                    },
                },
            })
            vim.keymap.set({ "n", "s", "x" }, "<leader>nd", "<CMD>NoiceDismiss<CR>")
            vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
                if not require("noice.lsp").scroll(4) then
                    return "<c-j>"
                end
            end, { silent = true, expr = true })

            vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
                if not require("noice.lsp").scroll(-4) then
                    return "<c-k>"
                end
            end, { silent = true, expr = true })
        end,
    },

    -- ui components
    { "MunifTanjim/nui.nvim" },
}
