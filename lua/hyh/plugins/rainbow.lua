return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		init  = function()
			-- 全局变量在插件加载前设置, 时序正确
			vim.g.rainbow_delimiters = {
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
		config = function()
			-- 在主题加载后覆盖彩虹括号颜色, 使其匹配 Rose Pine Moon 调色板
			local moon = {
				love  = "#eb6f92",  -- 第 1 层
				gold  = "#f6c177",  -- 第 2 层
				pine  = "#3e8fb0",  -- 第 3 层
				rose  = "#ea9a97",  -- 第 4 层
				leaf  = "#95b1ac",  -- 第 5 层
				iris  = "#c4a7e7",  -- 第 6 层
				foam  = "#9ccfd8",  -- 第 7 层
			}

			vim.api.nvim_set_hl(0, "RainbowDelimiterRed",    { fg = moon.love })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = moon.gold })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue",   { fg = moon.pine })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = moon.rose })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen",  { fg = moon.leaf })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = moon.iris })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan",   { fg = moon.foam })
		end,
	},
}
