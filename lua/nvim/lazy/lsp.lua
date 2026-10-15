return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "rust_analyzer",
                    "gopls",
                    "clangd",
                    "lua_ls",
                    "yamlls",
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })

            -- LSP setup
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                -- Prevent duplicate keymaps
                local keymaps_set = vim.b[bufnr].lsp_keymaps_set
                if not keymaps_set then
                    -- Navigation
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                    -- Workspace & Diagnostics
                    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

                    -- Code actions & Refactoring
                    vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

                    vim.b[bufnr].lsp_keymaps_set = true
                end

                -- Document highlight
                if client.server_capabilities.documentHighlightProvider then
                    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                    vim.api.nvim_create_autocmd("CursorHold", {
                        callback = vim.lsp.buf.document_highlight,
                        buffer = bufnr,
                        group = "lsp_document_highlight",
                        desc = "Document Highlight",
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        callback = vim.lsp.buf.clear_references,
                        buffer = bufnr,
                        group = "lsp_document_highlight",
                        desc = "Clear All the References",
                    })
                end

                -- Format on save
                if client.server_capabilities.documentFormattingProvider then
                    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

                    local format_filetypes = {
                        lua_ls = "lua",
                        rust_analyzer = "rust",
                        gopls = "go",
                    }

                    for server, filetype in pairs(format_filetypes) do
                        if vim.bo[bufnr].filetype == filetype and client.name == server then
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                callback = function()
                                    vim.lsp.buf.format({ async = false })
                                end,
                                buffer = bufnr,
                                group = "lsp_format_on_save",
                                desc = "Format on save",
                            })
                            break
                        end
                    end
                end
            end

            -- Diagnostic config
            vim.diagnostic.config({
                virtual_text = true,
                severity_sort = true,
                update_in_insert = false,
            })

            -- Define all server configs using vim.lsp.config
            vim.lsp.config.lua_ls = {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            }

            vim.lsp.config.yamlls = {
                cmd = { "yaml-language-server", "--stdio" },
                filetypes = { "yaml" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    yaml = {
                        format = { enable = true },
                        schemaStore = { enable = true },
                    },
                },
            }

            vim.lsp.config.rust_analyzer = {
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = {
                                "--",
                                "--no-deps",
                                "-Dclippy::correctness",
                                "-Dclippy::complexity",
                                "-Wclippy::perf",
                                "-Wclippy::pedantic",
                            },
                            allFeatures = true,
                        },
                    },
                },
            }

            vim.lsp.config.gopls = {
                cmd = { "gopls" },
                filetypes = { "go" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config.clangd = {
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config("jsonls", {
                cmd = { 'vscode-json-language-server', '--stdio' },
                filetypes = { 'json', 'jsonc' },
                init_options = {
                    provideFormatter = true,
                },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            vim.lsp.config.ts_ls = {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config.eslint = {
                cmd = { "vscode-eslint-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config.pylsp = {
                cmd = { "pylsp" },
                filetypes = { "python" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config.ruff_lsp = {
                cmd = { "ruff-lsp" },
                filetypes = { "python" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            -- Enable all servers
            vim.lsp.enable({
                "lua_ls",
                "yamlls",
                "rust_analyzer",
                "gopls",
                "clangd",
                "jsonls",
                "ts_ls",
                "eslint",
                "pylsp",
                "ruff_lsp",
            })
        end,
    },
    "L3MON4D3/LuaSnip",
}
