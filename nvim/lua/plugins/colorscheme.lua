return {
	{
		"oxfist/night-owl.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("night-owl").setup({
				-- Add settings
				transparent_background = true,
			})
			vim.cmd.colorscheme("night-owl")
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "night-owl" },
	},
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
}
