-- leader key
vim.g.mapleader = " "

-- for brevity
local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" } )
-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- copy into system clipboard
keymap.set({ "n", "x", "o" }, "gy", '"+y') -- copy
keymap.set({ "n", "x", "o" }, "gp", '"+p') -- paste

-- ctrl_s save
keymap.set({ "n", "i" }, "<C-s>", "<ESC>:w<CR>")

-- helix like motions
local motion_modes = { "n", "o", "x" }
keymap.set(motion_modes, "gs", "^")
keymap.set(motion_modes, "gh", "0")
keymap.set(motion_modes, "gl", "$")

keymap.set("n", "<leader>l", "<CMD>Lazy<CR>")

-- local trim_spaces = true
-- keymap.set("v", "<space>s", function()
--   require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
-- end)

-- local Terminal = require("toggleterm.terminal").Terminal
-- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
--
-- function _lazygit_toggle()
--   lazygit:toggle()
-- end
--
-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>ia', ':Gen Ask<CR>', { desc = "A[I] [A]sk" })
vim.keymap.set({ "n", "v" }, "<leader>ic", ":Gen Change<CR>", { desc = "A[I] [C]hange" })
vim.keymap.set({ "n", "v" }, "<leader>icc", ":Gen Change_Code<CR>", { desc = "A[I] [C]hange [C]ode" })
vim.keymap.set({ "n", "v" }, "<leader>ih", ":Gen Chat`<CR>", { desc = "A[I] C[h]at" })
vim.keymap.set({ "n", "v" }, "<leader>ie", ":Gen Enhance_Code<CR>", { desc = "A[I] [E]nhance code" })
vim.keymap.set({ "n", "v" }, "<leader>iew", ":Gen Enhance_Wording<CR>", { desc = "A[I] [E]nhace [W]ording" })
vim.keymap.set({ "n", "v" }, "<leader>ieg", ":Gen Enhance_Grammar_Spelling<CR>", { desc = "A[I] [E]nhance [G]rammar" })
vim.keymap.set({ "n", "v" }, "<leader>ig", ":Gen Generate<CR>", { desc = "A[I] [G]enerate" })
vim.keymap.set({ "n", "v" }, "<leader>ir", ":Gen Review_Code<CR>", { desc = "A[I] [R]eview Code" })
vim.keymap.set({ "n", "v" }, "<leader>is", ":Gen Summarize<CR>", { desc = "A[I] [S]ummarize" })
