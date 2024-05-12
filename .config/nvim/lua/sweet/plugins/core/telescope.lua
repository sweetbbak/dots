local select_one_or_multi = function(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd(string.format("%s %s", "edit", j.path))
            end
        end
    else
        require("telescope.actions").select_default(prompt_bufnr)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "andrew-george/telescope-themes",
        {
            "isak102/telescope-git-file-history.nvim",
            dependencies = { "tpope/vim-fugitive" },
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local gfh_actions = require("telescope").extensions.git_file_history.actions
        local builtin_schemes = require("telescope._extensions.themes").builtin_schemes

        telescope.setup({
            defaults = {
                path_display = { "truncate " },

                -- layout_config = {
                --     horizontal = {
                --         preview_cutoff = 3,
                --     },
                -- },

                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                },

                mappings = {
                    i = {
                        ["<CR>"] = select_one_or_multi,
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },

                opts = {
                    -- defaults = { layout_config = { horizontal = { preview_cutoff = 0 } } },
                    pickers = { colorscheme = { enable_preview = true } },
                },

                extensions = {
                    themes = {
                        -- you can add regular telescope config
                        -- that you want to apply on this picker only
                        layout_config = {
                            horizontal = {
                                width = 0.8,
                                height = 0.7,
                            },
                        },

                        -- extension specific config

                        -- (boolean) -> show/hide previewer window
                        enable_previewer = true,

                        -- (boolean) -> enable/disable live preview
                        enable_live_preview = true,

                        -- all builtin themes are ignored by default
                        -- (table) -> provide table of theme names to overwrite builtins table
                        -- ignore = { "default", "desert", "elflord", "habamax" },
                        -- OR
                        -- extend the required `builtin_schemes` table to ignore other
                        -- schemes in addition to builtin schemes
                        ignore = vim.tbl_deep_extend("force", builtin_schemes, { "embark" }),

                        persist = {
                            -- enable persisting last theme choice
                            enabled = true,

                            -- override path to file that execute colorscheme command
                            -- path = vim.fn.stdpath("config") .. "/lua/sweet/colorscheme.lua",
                            path = "/home/sweet/.config/nvim/lua/sweet/colorscheme.lua",
                        },
                    },

                    git_file_history = {
                        mappings = {
                            i = {
                                ["C-g"] = gfh_actions.open_in_browser,
                            },
                            n = {
                                ["<C-g>"] = gfh_actions.open_in_browser,
                            },
                        },
                    },
                },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("manix")
        telescope.load_extension("git_file_history")
        telescope.load_extension("themes")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find files in cwd" })
        --stylua: ignore
        keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Fuzzy find functions in current file" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        -- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope registers<cr>", { desc = "Fuzzy grep through clipboards" })
        -- keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>", { desc = "Fuzzy select colorscheme" })
        keymap.set(
            "n",
            "<leader>th",
            ":Telescope themes<CR>",
            { noremap = true, silent = true, desc = "Theme Switcher" }
        )

        keymap.set(
            "n",
            "<leader>ft",
            ":lua require('telescope.builtin').colorscheme({ enable_preview = true })<cr>",
            { desc = "Fuzzy select colorscheme" }
        )
        keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
        keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
        keymap.set("n", "<leader>fo", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Help Pages" })
    end,
}
