return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- 文件图标依赖
		event        = "VeryLazy",                       -- 启动完成后加载, 不拖慢启动
		config       = function()
			-- 安全加载: 插件异常时静默返回, 不阻塞启动
			local ok, lualine = pcall(require, "lualine")
			if not ok then
				return
			end

			-- ====================== 自动识别系统图标 ======================
			local os_icon = "" -- 默认 Linux 企鹅图标
			local sys     = vim.loop.os_uname().sysname

			if sys == "Darwin" then
				os_icon = ""     -- macOS
			elseif sys == "Windows_NT" then
				os_icon = ""     -- Windows
			else
				-- Linux 发行版识别: 读取 /etc/os-release
				local ok_rel, content = pcall(vim.fn.readfile, "/etc/os-release")
				if ok_rel then
					local release = table.concat(content)
					if release:find("ID=ubuntu") then
						os_icon = "" -- Ubuntu
					elseif release:find("ID=arch") then
						os_icon = "" -- Arch
					elseif release:find("ID=kali") then
						os_icon = "" -- Kali
					end
				end
			end

			-- ====================== 透明玫瑰主题 ======================
			local rose_theme = {
				normal   = {
					a = { fg = "#e0def4", bg = "none", gui = "bold" }, -- 模式: 亮白加粗
					b = { fg = "#9ccfd8", bg = "none" },               -- 分支/差异: 青
					c = { fg = "#6e6a86", bg = "none" },               -- 文件名: 暗紫灰
					x = { fg = "#6e6a86", bg = "none" },               -- 编码等: 暗紫灰
					y = { fg = "#ebbcba", bg = "none" },               -- 系统图标/进度: 玫瑰
					z = { fg = "#c4a7e7", bg = "none", gui = "bold" }, -- 位置: 紫加粗
				},
				insert   = { a = { fg = "#9ccfd8", bg = "none", gui = "bold" } }, -- 插入模式: 青
				visual   = { a = { fg = "#c4a7e7", bg = "none", gui = "bold" } }, -- 可视模式: 紫
				replace  = { a = { fg = "#eb6f92", bg = "none", gui = "bold" } }, -- 替换模式: 红
				command  = { a = { fg = "#f6c177", bg = "none", gui = "bold" } }, -- 命令模式: 金
				inactive = {
					a = { fg = "#6e6a86", bg = "none" },           -- 非活动窗口统一暗紫灰
					b = { fg = "#6e6a86", bg = "none" },
					c = { fg = "#6e6a86", bg = "none" },
				},
			}

			-- ====================== 全局透明状态栏 ======================
			-- 定义后立即执行一次, 确保当前主题下状态栏背景已透明
			local transparent = function()
				vim.api.nvim_set_hl(0, "StatusLine",   { bg = "none" })
				vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
			end
			transparent()

			-- 每次切换主题后重新应用透明, 避免被 colorscheme 覆盖
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern  = "*",
				callback = transparent,
			})

			-- ====================== 主配置 ======================
			lualine.setup({
				options = {
					theme                = rose_theme,                 -- 自定义透明主题
					component_separators = { left = "", right = "" }, -- 组件分隔符
					section_separators   = { left = "", right = "" }, -- 区段分隔符
					globalstatus         = true,                       -- 全局统一状态栏
					disabled_filetypes   = {},                         -- 不禁用任何文件类型
				},
				sections = {
					lualine_a = { "mode" },                              -- 左: 模式
					lualine_b = { "branch", "diff", "diagnostics" },     -- 左: 分支/差异/诊断
					lualine_c = { "filename" },                          -- 左: 文件名
					lualine_x = { "encoding", "fileformat", "filetype" }, -- 右: 编码/格式/类型
					lualine_y = {                                        -- 右: 系统图标 + 进度
						{ os_icon, color = { fg = "#ebbcba" } },
						"progress",
					},
					lualine_z = { "location" },                          -- 右: 光标位置
				},
				extensions = { "nvim-tree", "toggleterm" },              -- 适配文件树与终端
			})
		end,
	},
}
