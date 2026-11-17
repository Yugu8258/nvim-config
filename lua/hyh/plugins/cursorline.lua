return {
	{
		"yamatsum/nvim-cursorline",
		event = { "BufReadPost", "BufNewFile" }, -- 打开文件后再加载，不拖慢启动
		config = function()
			-- 安全加载：插件异常时静默返回，不阻塞启动
			local ok, cursorline = pcall(require, "nvim-cursorline")
			if not ok then
				return
			end

			cursorline.setup({
				disable_filetypes = {        -- 顶层字段：这些文件类型不启用高亮
					"NvimTree",
					"Oil",
					"dashboard",
					"Telescope",
					"terminal",
				},
				cursorline        = {
					enable  = true,          -- 启用光标行高亮
					timeout = 1000,          -- 光标停止移动 1000ms 后显示行高亮
					number  = false,         -- 不高亮行号
				},
				cursorword        = {
					enable     = true,       -- 启用光标下相同单词高亮
					min_length = 3,          -- 至少 3 个字符才高亮
					hl         = { underline = true }, -- 默认下划线样式
				},
			})

			-- 自定义高亮颜色：清爽蓝色下划线
			vim.api.nvim_set_hl(0, "CursorWord", {
				underline = true,
				sp        = "#5e81ac",   -- 下划线颜色（蓝色）
				fg        = "none",      -- 不设前景色
				bg        = "none",      -- 不设背景色
			})
		end,
	},
}
