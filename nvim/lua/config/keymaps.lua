local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

map("n", "<leader>tt", function()
	local theme = require("night-owl")
	theme._options.transparent_background = not theme._options.transparent_background
	theme._load()
end, { desc = "Toggle transparent background" })
