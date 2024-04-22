-- leader key
vim.g.mapleader = " "

-- for brevity
local keymap = vim.keymap

-- fix for cmp breaking tab in commandline
keymap.set("c", "<tab>", "<C-z>", { silent = false })
-- vim.api.nvim_set_keymap("n", "U", ":redo<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true })

-- jk roll to leave insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- ctrl_s save
keymap.set({ "n", "i" }, "<C-s>", "<ESC>:w<CR>")

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

-- buffer
keymap.set("n", "<C-n>", "<cmd>BufferLineCycleNext<CR>", { desc = "Cycle buffer next" })
keymap.set("n", "<C-m>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Cycle buffer previous" })

-- helix like motions
local motion_modes = { "n", "o", "x" }
keymap.set(motion_modes, "gs", "^")
keymap.set(motion_modes, "gh", "0")
keymap.set(motion_modes, "gl", "$")

keymap.set("n", "<leader>l", "<CMD>Lazy<CR>")
keymap.set("n", "mm", "%", { desc = "Go to matching pair" })
keymap.set("n", "<leader>nf", "<CMD>ene<CR>", { desc = "New file" })
keymap.set("n", "<leader>nn", "<CMD>:%!alejandra -qq<CR>", { desc = "Format nix file" })

-- silicon
-- Generate image of lines in a visual selection
-- keymap.set("v", "<Leader>s", function()
--     silicon.visualise_api()
-- end)
-- -- Generate image of a whole buffer, with lines in a visual selection highlighted
-- keymap.set("v", "<Leader>bs", function()
--     silicon.visualise_api({ to_clip = true, show_buf = true })
-- end)
-- -- Generate visible portion of a buffer
-- keymap.set("n", "<Leader>s", function()
--     silicon.visualise_api({ to_clip = true, visible = true })
-- end)
-- -- Generate current buffer line in normal mode
-- keymap.set("n", "<Leader>s", function()
--     silicon.visualise_api({ to_clip = true })
-- end)
--
keymap.set({ "n", "v" }, "<leader>ia", ":Gen Ask<CR>", { desc = "A[I] [A]sk" })
keymap.set({ "n", "v" }, "<leader>ic", ":Gen Change<CR>", { desc = "A[I] [C]hange" })
keymap.set({ "n", "v" }, "<leader>icc", ":Gen Change_Code<CR>", { desc = "A[I] [C]hange [C]ode" })
keymap.set({ "n", "v" }, "<leader>ih", ":Gen Chat`<CR>", { desc = "A[I] C[h]at" })
keymap.set({ "n", "v" }, "<leader>ie", ":Gen Enhance_Code<CR>", { desc = "A[I] [E]nhance code" })
keymap.set({ "n", "v" }, "<leader>iew", ":Gen Enhance_Wording<CR>", { desc = "A[I] [E]nhace [W]ording" })
keymap.set({ "n", "v" }, "<leader>ieg", ":Gen Enhance_Grammar_Spelling<CR>", { desc = "A[I] [E]nhance [G]rammar" })
keymap.set({ "n", "v" }, "<leader>ig", ":Gen Generate<CR>", { desc = "A[I] [G]enerate" })
keymap.set({ "n", "v" }, "<leader>ir", ":Gen Review_Code<CR>", { desc = "A[I] [R]eview Code" })
keymap.set({ "n", "v" }, "<leader>is", ":Gen Summarize<CR>", { desc = "A[I] [S]ummarize" })
keymap.set({ "n", "v" }, "<leader>is", ":Gen Summarize<CR>", { desc = "A[I] [S]ummarize" })
-- stylua: ignore
keymap.set({ "n", "v" }, "<leader>dd", '<cmd>lua require("dapui").eval()<cr>', { desc = "[D]ebug selection with nvim-dap"})
-- stylua: ignore
keymap.set({ "n", "v" }, "<leader>db", '<cmd>:DapToggleBreakpoint<cr>', { desc = "[D]ebug [B]reakpoint"})
-- stylua: ignore
keymap.set({ "n", "v" }, "<leader>dr", '<cmd>:DapContinue<cr>', { desc = "[D]ebug [R]un"})
-- stylua: ignore
keymap.set({ "n", "v" }, "<leader>dg", '<cmd>lua require("dap-go").debug_test()<cr>', { desc = "[D]ebug [G]o func"})

-- If this is a script, make it executable, and execute it in a split pane on the right
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
keymap.set("n", "<leader>f.", function()
    local file = vim.fn.expand("%") -- Get the current file name
    local first_line = vim.fn.getline(1) -- Get the first line of the file
    if string.match(first_line, "^#!/") then -- If first line contains shebang
        local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
        vim.cmd("!chmod +x " .. escaped_file) -- Make the file executable
        vim.cmd("vsplit") -- Split the window vertically
        vim.cmd("terminal " .. "./" .. escaped_file) -- Open terminal and execute the file
        vim.cmd("startinsert") -- Enter insert mode, recommended by echasnovski on Reddit
    else
        vim.cmd("echo 'Not a script. Shebang line not found.'")
    end
end, { desc = "Execute current file in terminal (if it's a script)" })
