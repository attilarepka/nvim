describe("Treesitter configuration", function()
    local original_create_autocmd
    local original_treesitter
    local original_nvim_treesitter
    local autocmds
    local installed_parsers
    local setup_called
    local start_called
    local plugin_spec

    before_each(function()
        original_create_autocmd = vim.api.nvim_create_autocmd
        original_treesitter = vim.treesitter
        original_nvim_treesitter = package.loaded["nvim-treesitter"]
        autocmds = {}
        installed_parsers = nil
        setup_called = false
        start_called = false

        vim.api.nvim_create_autocmd = function(event, options)
            autocmds[#autocmds + 1] = { event = event, options = options }
        end
        vim.treesitter = {
            start = function()
                start_called = true
            end,
        }
        package.loaded["nvim-treesitter"] = {
            setup = function()
                setup_called = true
            end,
            install = function(parsers)
                installed_parsers = parsers
            end,
        }

        plugin_spec = require("nvim.lazy.treesitter")
        plugin_spec.config()
    end)

    after_each(function()
        vim.api.nvim_create_autocmd = original_create_autocmd
        vim.treesitter = original_treesitter
        package.loaded["nvim-treesitter"] = original_nvim_treesitter
    end)

    it("sets up Treesitter and installs the configured parsers", function()
        assert.is_false(plugin_spec.lazy)
        assert.are.equal("main", plugin_spec.branch)
        assert.is_true(setup_called)
        assert.are.same({
            "vim", "vimdoc", "javascript", "typescript",
            "c", "cpp", "lua", "rust", "go", "python",
            "query", "markdown",
        }, installed_parsers)
    end)

    it("starts highlighting for the configured filetypes", function()
        assert.are.equal(1, #autocmds)
        assert.are.equal("FileType", autocmds[1].event)
        assert.are.same({
            "go", "c", "cpp", "lua", "rust",
            "python", "javascript", "typescript", "vim", "query",
        }, autocmds[1].options.pattern)

        autocmds[1].options.callback()
        assert.is_true(start_called)
    end)
end)
