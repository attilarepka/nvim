vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false

vim.opt.rtp:prepend(".")

local plenary_dir = os.getenv("PLENARY_DIR")
if not plenary_dir or vim.fn.isdirectory(plenary_dir) == 0 then
    error("Plenary not found; set PLENARY_DIR to the plenary.nvim checkout")
end

vim.opt.rtp:append(plenary_dir)
vim.cmd("runtime plugin/plenary.vim")
