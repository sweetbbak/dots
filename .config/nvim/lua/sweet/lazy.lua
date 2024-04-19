local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- stylua: ignore
require("lazy").setup({
    { import = "sweet.plugins.lsp" },
    { import = "sweet.plugins.core" },
    { import = "sweet.plugins.themes" },
    { import = "sweet.plugins.extra" },
},
    {
        install = {
            colorscheme = { "kanagawa" },
        },
        checker = {
            enabled = true,
            notify = false,
        },
        change_detection = {
            notify = false,
        },
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "matchit",
                    "netrwPlugin",
                    "matchparen",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                }
            }
        }
    }
)
