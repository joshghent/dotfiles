require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telekasten mappings
map("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "Telekasten find notes" })
map("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "Telekasten search notes" })
map("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "Telekasten daily note" })
map("n", "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>", { desc = "Telekasten weekly note" })
map("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "Telekasten new note" })
map("n", "<leader>zt", "<cmd>Telekasten toggle_todo<CR>", { desc = "Telekasten toggle todo" })
map("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", { desc = "Telekasten backlinks" })
map("n", "<leader>zT", "<cmd>Telekasten show_tags<CR>", { desc = "Telekasten show tags" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
