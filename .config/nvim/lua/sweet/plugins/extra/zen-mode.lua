return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      window = {
        backdrop = 1,
        width = 100,
        height = 1,
        options = {
          number = true,
        },
      },
    })

    local keymap = vim.keymap.set
    keymap("n", "<leader>Z", ":ZenMode<CR>", { silent = true })
  end,
}
