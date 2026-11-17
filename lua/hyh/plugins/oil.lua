return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- 文件图标依赖
		lazy         = false,                            -- 官方推荐: 不懒加载, 确保 default_file_explorer 及时接管目录缓冲区
		opts         = {
			default_file_explorer = true,                -- 接管目录缓冲区(如 'vim .')
			columns               = { "icon" },          -- 只显示图标列, 界面更简洁
			delete_to_trash       = true,                -- 删除文件时移至回收站, 而非永久删除
			skip_confirm_for_simple_edits = true,        -- 简单编辑(如重命名)跳过确认弹窗

			keymaps = {
				["<C-h>"] = false,                       -- 禁用默认的水平分屏打开(与窗口导航键冲突)
				["<C-c>"] = false,                       -- 禁用默认的关闭映射(由下方 q 替代)
				["<M-h>"] = "actions.select_split",      -- Alt+h 水平分屏打开
				["q"]     = "actions.close",             -- q 关闭 oil 窗口
			},

			view_options = {
				show_hidden = true,                      -- 显示以 . 开头的隐藏文件
			},

			float = {
				border     = "rounded",                  -- 浮动窗口边框: 圆角
				max_width  = 0.8,                        -- 最大宽度: 屏幕的 80%
				max_height = 0.8,                        -- 最大高度: 屏幕的 80%
				padding    = 2,                          -- 内边距
				win_options = {
					winblend = 0,                        -- 窗口透明度: 0 表示完全不透明
				},
			},
		},
		config = function(_, opts)
			-- 使用 lazy 传入的 opts 调用 setup, 避免重复写配置
			require("oil").setup(opts)

			-- 全局快捷键: 在插件加载后注册, 确保命令可用
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "打开目录（父级）" }) -- 打开当前文件所在目录
			vim.keymap.set("n", "<leader>e", function()
				require("oil").toggle_float()            -- 切换浮动文件浏览器
			end, { desc = "浮动文件浏览器" })

			-- oil 缓冲区中启用光标行高亮, 便于定位当前条目
			vim.api.nvim_create_autocmd("FileType", {
				pattern  = "oil",
				callback = function()
					vim.opt_local.cursorline = true
				end,
			})
		end,
	},
}
