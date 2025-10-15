return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
    },

    config = function()
        local lsp_zero = require("lsp-zero")

        -- Use recommended LSP behavior
        lsp_zero.extend_lspconfig()

        lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({ buffer = bufnr })

            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>ac", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", "<leader>ac", function() vim.lsp.buf.code_action() end, opts)

            -- Cursor-based symbol highlighting
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
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
        end)

        -- Mason setup
        require("mason").setup()

        -- Mason-LSPConfig setup
        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "gopls",
                "clangd",
                "lua_ls",
                "yamlls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,

                ["lua_ls"] = function()
                    vim.lsp.config.lua_ls = {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    }
                    vim.lsp.start(vim.lsp.config.lua_ls)
                end,

                ["yamlls"] = function()
                    vim.lsp.config.yamlls = {
                        settings = {
                            yaml = {
                                format = { enable = true },
                                schemaStore = { enable = true },
                            },
                        },
                    }
                    vim.lsp.start(vim.lsp.config.yamlls)
                end,

                ["rust_analyzer"] = function()
                    vim.lsp.config.rust_analyzer = {
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
                    vim.lsp.start(vim.lsp.config.rust_analyzer)
                end,
            },
        })

        -- nvim-cmp setup
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<cr>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
        })

        -- Format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })

        -- Diagnostic visuals
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            update_in_insert = false,
        })
    end,
}
