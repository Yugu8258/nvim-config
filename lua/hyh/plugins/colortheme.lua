return {
	{
		"rose-pine/neovim",
		name = "rose-pine",          -- 插件名映射为 rose-pine, 供 require 使用
		lazy = false,                -- 主题必须启动时加载
		priority = 1000,             -- 最高优先级, 确保最先加载, 避免被其他插件的颜色覆盖
		config = function()
			-- 安全加载: 插件异常时静默返回, 不阻塞启动
			local ok, rose_pine = pcall(require, "rose-pine")
			if not ok then
				return
			end

			rose_pine.setup({
				variant         = "moon", -- 固定使用 moon 变体
				dark_variant    = "moon", -- 深色模式下也回落到 moon

				styles          = {
					bold         = true,      -- 粗体
					italic       = false,     -- 关闭斜体
					transparency = true,      -- 透明背景（新版统一开关, 替代已移除的 disable_background / disable_float_background）
				},

				-- 高亮组微调: 给指定组单独覆写属性
				highlight_groups = {
					SignColumn = { bg = "none" }, -- 符号列透明
					FoldColumn = { bg = "none" }, -- 折叠列透明
				},
			})

			-- 应用主题(moon 变体对应 rose-pine-moon)
			vim.cmd.colorscheme("rose-pine-moon")
		end,
	},
}
