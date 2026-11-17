return {
	"nvim-lua/plenary.nvim",          -- Lua 函数库，许多插件依赖
	"christoomey/vim-tmux-navigator", -- tmux 与分屏窗口间导航
	-- 修复 Neovim 已知的 Lua 类型推断问题
	{
		"folke/lazydev.nvim",
		ft   = "lua",
		opts = {
			library = {
				{
					path  = "${3rd}/plenary.nvim/lua",
					words = { "plenary" },
				},
			},
		},
	},
}
