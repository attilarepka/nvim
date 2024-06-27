return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")
        local widgets = require("dap.ui.widgets")

        vim.keymap.set("n", "<leader>vr", dap.terminate)
        vim.keymap.set("n", "<F5>", dap.continue)
        vim.keymap.set("n", "<F10>", dap.step_over)
        vim.keymap.set("n", "<F11>", dap.step_into)
        vim.keymap.set("n", "<F12>", dap.step_out)
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
        vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)
        vim.keymap.set({ "n", "v" }, "<leader>dh", function()
            widgets.hover()
        end)
        vim.keymap.set({ "n", "v" }, "<leader>dp", function()
            widgets.preview()
        end)
        vim.keymap.set("n", "<Leader>df", function()
            widgets.centered_float(widgets.frames)
        end)
        vim.keymap.set("n", "<Leader>ds", function()
            widgets.centered_float(widgets.scopes)
        end)

        dap.adapters.lldb = {
            type = "executable",
            command = "/usr/bin/lldb-vscode-14", -- adjust as needed, must be absolute path
            name = "lldb"
        }

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = "codelldb",
                args = { "--port", "${port}" },
                -- On windows you may have to uncomment this:
                -- detached = false,
            }
        }

        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                -- 💀
                -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                --
                --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                --
                -- Otherwise you might get the following error:
                --
                --    Error on launch: Failed to attach to the target process
                --
                -- But you should be aware of the implications:
                -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                -- runInTerminal = false,
            },
        }

        -- If you want to use this for Rust and C, add something like this:
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}" },
            }
        }

        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
        dap.configurations.go = {
            {
                type = "delve",
                name = "Debug",
                request = "launch",
                program = "${file}"
            },
            {
                type = "delve",
                name = "Debug test", -- configuration for debugging test files
                request = "launch",
                mode = "test",
                program = "${file}"
            },
            -- works with go.mod packages and sub packages
            {
                type = "delve",
                name = "Debug test (go.mod)",
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}"
            }
        }
    end
}
