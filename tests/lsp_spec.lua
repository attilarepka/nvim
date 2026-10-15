describe("LSP configuration", function()
    local original_config
    local original_enable
    local original_diagnostic_config
    local original_cmp
    local original_luasnip
    local original_cmp_nvim_lsp
    local configured_servers
    local enabled_servers
    local diagnostic_options

    local function load_lsp_config()
        configured_servers = {}
        enabled_servers = nil
        diagnostic_options = nil

        vim.lsp.config = setmetatable(configured_servers, {
            __call = function(_, name, config)
                configured_servers[name] = config
            end,
        })
        local mock_enable = function(servers)
            enabled_servers = servers
        end
        vim.lsp.enable = mock_enable
        vim.diagnostic.config = function(options)
            diagnostic_options = options
        end

        local cmp = {
            config = {
                sources = function(...)
                    return { ... }
                end,
            },
            mapping = {
                preset = {
                    insert = function()
                        return {}
                    end,
                },
                select_prev_item = function()
                    return function() end
                end,
                select_next_item = function()
                    return function() end
                end,
                complete = function()
                    return function() end
                end,
                confirm = function()
                    return function() end
                end,
            },
            setup = function() end,
        }
        package.loaded.cmp = cmp
        package.loaded.luasnip = { lsp_expand = function() end }
        package.loaded.cmp_nvim_lsp = {
            default_capabilities = function()
                return { test_capability = true }
            end,
        }

        local plugins = require("nvim.lazy.lsp")
        plugins[3].config()
    end

    before_each(function()
        original_config = vim.lsp.config
        original_enable = vim.lsp.enable
        original_diagnostic_config = vim.diagnostic.config
        original_cmp = package.loaded.cmp
        original_luasnip = package.loaded.luasnip
        original_cmp_nvim_lsp = package.loaded.cmp_nvim_lsp
        load_lsp_config()
    end)

    after_each(function()
        vim.lsp.config = original_config
        vim.lsp.enable = original_enable
        vim.diagnostic.config = original_diagnostic_config
        package.loaded.cmp = original_cmp
        package.loaded.luasnip = original_luasnip
        package.loaded.cmp_nvim_lsp = original_cmp_nvim_lsp
    end)

    it("registers and enables the expected servers", function()
        for _, server in ipairs({
            "lua_ls", "yamlls", "rust_analyzer", "gopls", "clangd", "jsonls",
            "ts_ls", "eslint", "pylsp", "ruff_lsp",
        }) do
            assert.is_true(vim.tbl_contains(enabled_servers, server))
        end
        assert.are.same({ "lua" }, configured_servers.lua_ls.filetypes)
        assert.are.same({ "yaml" }, configured_servers.yamlls.filetypes)
        assert.are.same({ "rust" }, configured_servers.rust_analyzer.filetypes)
        assert.are.same({ "go" }, configured_servers.gopls.filetypes)
        assert.are.same({ "c", "cpp", "objc", "objcpp" }, configured_servers.clangd.filetypes)
        assert.are.same({ "json", "jsonc" }, configured_servers.jsonls.filetypes)
        assert.are.same(
            { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            configured_servers.ts_ls.filetypes
        )
        assert.are.same(
            { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
            configured_servers.eslint.filetypes
        )
        assert.are.same({ "python" }, configured_servers.pylsp.filetypes)
        assert.are.same({ "python" }, configured_servers.ruff_lsp.filetypes)
        assert.are.same({ "typescript-language-server", "--stdio" }, configured_servers.ts_ls.cmd)
        assert.are.same({ "vscode-eslint-language-server", "--stdio" }, configured_servers.eslint.cmd)
        assert.are.same({ "pylsp" }, configured_servers.pylsp.cmd)
        assert.are.same({ "ruff-lsp" }, configured_servers.ruff_lsp.cmd)
        assert.is_true(configured_servers.lua_ls.capabilities.test_capability)
        assert.is_true(configured_servers.jsonls.init_options.provideFormatter)
        assert.are.same({
            virtual_text = true,
            severity_sort = true,
            update_in_insert = false,
        }, diagnostic_options)
    end)

    it("sets buffer-local LSP keymaps on attach", function()
        local buffer = vim.api.nvim_create_buf(true, false)
        configured_servers.lua_ls.on_attach({
            name = "lua_ls",
            server_capabilities = {},
        }, buffer)

        local mappings = vim.api.nvim_buf_get_keymap(buffer, "n")
        local found_implementation = false
        for _, mapping in ipairs(mappings) do
            if mapping.lhs == "gi" then
                found_implementation = true
                break
            end
        end

        assert.is_true(found_implementation)
        vim.api.nvim_buf_delete(buffer, { force = true })
    end)

    it("keeps highlight and format autocmds for every attached buffer", function()
        local client = {
            name = "lua_ls",
            server_capabilities = {
                documentHighlightProvider = true,
                documentFormattingProvider = true,
            },
        }
        local buffers = {
            vim.api.nvim_create_buf(true, false),
            vim.api.nvim_create_buf(true, false),
        }

        for _, buffer in ipairs(buffers) do
            vim.bo[buffer].filetype = "lua"
            configured_servers.lua_ls.on_attach(client, buffer)
            configured_servers.lua_ls.on_attach(client, buffer)
        end

        for _, event in ipairs({ "CursorHold", "CursorMoved" }) do
            local autocmds = vim.api.nvim_get_autocmds({
                group = "lsp_document_highlight",
                event = event,
            })
            assert.are.equal(2, #autocmds)
            local attached_buffers = {}
            for _, autocmd in ipairs(autocmds) do
                attached_buffers[autocmd.buffer] = true
            end
            assert.is_true(attached_buffers[buffers[1]])
            assert.is_true(attached_buffers[buffers[2]])
        end

        local format_autocmds = vim.api.nvim_get_autocmds({
            group = "lsp_format_on_save",
            event = "BufWritePre",
        })
        assert.are.equal(2, #format_autocmds)
        local formatted_buffers = {}
        for _, autocmd in ipairs(format_autocmds) do
            formatted_buffers[autocmd.buffer] = true
        end
        assert.is_true(formatted_buffers[buffers[1]])
        assert.is_true(formatted_buffers[buffers[2]])

        for _, buffer in ipairs(buffers) do
            vim.api.nvim_buf_delete(buffer, { force = true })
        end
    end)
end)
