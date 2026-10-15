return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "main",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "go", "c", "cpp", "lua", "rust",
                "python", "javascript", "typescript", "vim", "query"
            },
            callback = function()
                vim.treesitter.start()
            end,
        })

        require("nvim-treesitter").setup()

        require("nvim-treesitter").install({
            "vim", "vimdoc", "javascript", "typescript",
            "c", "cpp", "lua", "rust", "go", "python",
            "query", "markdown"
        })
    end
}
