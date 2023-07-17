local header = require("header")

header.setup({
    file_name = true,
    author = nil,
    project = nil,
    date_created = true,
    date_created_fmt = "%Y-%m-%d %H:%M:%S",
    line_separator = "------",
    copyright_text = nil,

})

vim.keymap.set("n", "<leader>hh", function() header.add_headers() end)
