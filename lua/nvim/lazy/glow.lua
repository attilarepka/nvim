return {
    "ellisonleao/glow.nvim",
    config = function()
        require("glow").setup()
        vim.keymap.set("n", "<leader>mp", "<cmd>Glow<cr>", {})
    end
}
