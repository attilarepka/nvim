-- unmap <leader> space from any mode
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- exit insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- unmap capital Q from normal mode
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new-window tmux-sessionizer<CR>")

vim.keymap.set({ "n", "v" }, "<leader>fm", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<cr>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<cr>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<cr>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- close quickfix window
vim.keymap.set("n", "<leader>q", "<cmd>cclose<cr>")

-- switch between header/source
vim.keymap.set("n", "<leader>sh", "<cmd>ClangdSwitchSourceHeader<cr>")
