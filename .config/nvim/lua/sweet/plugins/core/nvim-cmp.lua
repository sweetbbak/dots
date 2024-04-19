return {
    "hrsh7th/nvim-cmp",

    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        "L3MON4D3/LuaSnip", -- snippet engine
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind.nvim", -- vs-code like pictograms
    },

    config = function()
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
                -- completeopt = "menu,menuone,preview",
                -- completeopt = "menu,menuone,noselect",
            },
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            preselect = { cmp.PreselectMode.None },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion

                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),

                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),

                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window

                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<S-CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

                ["<C-CR>"] = function(fallback)
                    cmp.abort()
                    fallback()
                end,
            }),

            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 1, keyword_length = 1, priority_weight = 1 },
                { name = "luasnip", group_index = 2, max_view_entries = 2 }, -- snippets
                { name = "buffer", group_index = 3, max_view_entries = 1 }, -- text within current buffer
                { name = "path", group_index = 3, max_view_entries = 1 }, -- file system paths
            }),

            -- `:` cmdline setup.
            -- cmp.setup.cmdline(":", {
            --     mapping = cmp.mapping.preset.cmdline({
            --         ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            --         ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            --     }),
            --     sources = cmp.config.sources({
            --         { name = "nvim_lsp" },
            --         { name = "path" },
            --     }, {
            --         { name = "cmdline" },
            --         { name = "buffer" },
            --     }),
            -- }),

            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },

            -- configure lspkind for vs-code like pictograms in completion menu
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                    -- snippets
                    {
                        "L3MON4D3/LuaSnip",
                        dependencies = {
                            {
                                "rafamadriz/friendly-snippets",
                                config = function()
                                    require("luasnip.loaders.from_vscode").lazy_load()
                                end,
                            },
                            {
                                "nvim-cmp",
                                dependencies = {
                                    "saadparwaiz1/cmp_luasnip",
                                },
                                opts = function(_, opts)
                                    opts.snippet = {
                                        expand = function(args)
                                            require("luasnip").lsp_expand(args.body)
                                        end,
                                    }
                                    table.insert(opts.sources, { name = "luasnip" })
                                end,
                            },
                        },
                        opts = {
                            history = true,
                            delete_check_events = "TextChanged",
                        },

                        -- stylua: ignore
                        keys = {
                          {
                            "<C-j>",
                            function()
                              return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                            end,
                            expr = true, silent = true, mode = "i",
                          },
                          { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
                          { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
                        },
                    },
                }),
            },
        })
    end,
}
-- return {
-- auto completion
-- "hrsh7th/nvim-cmp",
--   version = false, -- last release is way too old
--   event = "InsertEnter",
--   dependencies = {
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--
--   },
--   opts = function()
--     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
--     local cmp = require("cmp")
--     local defaults = require("cmp.config.default")()
--     return {
--       completion = {
--         completeopt = "menu,menuone,noinsert",
--       },
--       mapping = cmp.mapping.preset.insert({
--         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
--         ["<C-Space>"] = cmp.mapping.complete(),
--         ["<C-e>"] = cmp.mapping.abort(),
--         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ["<S-CR>"] = cmp.mapping.confirm({
--           behavior = cmp.ConfirmBehavior.Replace,
--           select = true,
--         }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ["<C-CR>"] = function(fallback)
--           cmp.abort()
--           fallback()
--         end,
--       }),
--       sources = cmp.config.sources({
--         { name = "nvim_lsp" },
--         { name = "path" },
--       }, {
--         { name = "buffer" },
--       }),
--       -- formatting = {
--       --   format = function(_, item)
--       --     local icons = require("lazyvim.config").icons.kinds
--       --     if icons[item.kind] then
--       --       item.kind = icons[item.kind] .. item.kind
--       --     end
--       --     return item
--       --   end,
--       -- },
--       experimental = {
--         ghost_text = {
--           hl_group = "CmpGhostText",
--         },
--       },
--       sorting = defaults.sorting,
--     }
--   end,
--   ---@param opts cmp.ConfigSchema
--   config = function(_, opts)
--     for _, source in ipairs(opts.sources) do
--       source.group_index = source.group_index or 1
--     end
--     require("cmp").setup(opts)
--   end,
-- },
-- -- snippets
-- {
--   "L3MON4D3/LuaSnip",
--   -- build = (not jit.os:find("Windows"))
--   -- and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
--   -- or nil,
--   dependencies = {
--     {
--       "rafamadriz/friendly-snippets",
--       config = function()
--         require("luasnip.loaders.from_vscode").lazy_load()
--       end,
--     },
--     {
--       "nvim-cmp",
--       dependencies = {
--         "saadparwaiz1/cmp_luasnip",
--       },
--       opts = function(_, opts)
--         opts.snippet = {
--           expand = function(args)
--             require("luasnip").lsp_expand(args.body)
--           end,
--         }
--         table.insert(opts.sources, { name = "luasnip" })
--       end,
--     },
--   },
--   opts = {
--     history = true,
--     delete_check_events = "TextChanged",
--   },
--     -- stylua: ignore
--     keys = {
--       {
--         "<tab>",
--         function()
--           return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
--         end,
--         expr = true, silent = true, mode = "i",
--       },
--       { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
--       { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
--     },
-- }
