return {
	{
		"akinsho/toggleterm.nvim",
		version = "*", -- 使用当前主版本, 避免破坏性变更
		keys = {
			{ "<A-Enter>", "<cmd>ToggleTerm<CR>", desc = "切换浮动终端" }, -- 按 Alt+Enter 打开/关闭终端
		},
		opts = {
			open_mapping = [[<A-Enter>]], -- 正常模式下的切换键(与 keys 一致, 二者不冲突)
			direction = "float", -- 终端方向: 浮动窗口
			float_opts = {
				border = "curved", -- 浮动窗口边框: 弧形
				width = 150, -- 浮动窗口宽度
				height = 45, -- 浮动窗口高度
			},
		},
	},
}
