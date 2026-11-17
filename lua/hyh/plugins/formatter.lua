return {
	"stevearc/conform.nvim",
	-- 打开/新建文件时加载插件, 提前就绪, 不等到格式化时才加载
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- 关闭 conform 自带的尾换行处理逻辑, 由自定义快捷键接管尾空行
			strip_final_newline = false,
			trim_final_newlines = false,

			-- 自定义格式化器参数、条件
			formatters = {
				-- markdown-toc：仅当文件存在 <!-- toc --> 标记时，才生成目录
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
						return false
					end,
				},
				-- clang-format：读取项目 .clang-format 配置, 按文件类型解析
				clang_format = {
					args = {
						"--style=file",
						"--assume-filename",
						"$FILENAME",
					},
				},
				-- prettier：仅传递文件路径, 优先读取项目 .prettierrc 配置
				prettier = {
					args = { "--stdin-filepath", "$FILENAME" },
				},
			},

			-- 文件类型 -> 格式化器映射，数组顺序=执行顺序
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				css = { "biome" },
				html = { "biome" },
				svelte = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier", "markdown-toc" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				objc = { "clang_format" },
				objcpp = { "clang_format" },
				h = { "clang_format" },
				go = { "gofmt" },
			},

			-- 关闭格式化通知提示, 消除多余弹窗
			notify_on_error = false,
		})

		-- 手动格式化+清理尾空行+保存, 仅 <leader>fm 触发
		vim.keymap.set({ "n", "v" }, "<leader>fm", function()
			local buf = vim.api.nvim_get_current_buf()
			local win = vim.api.nvim_get_current_win()
			local cursor = vim.api.nvim_win_get_cursor(win)

			-- 同步格式化, 外部格式化器失败时回退LSP格式化, 超时1s
			conform.format({
				bufnr = buf,
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})

			-- 删除末尾全部连续空行
			local line_count = vim.api.nvim_buf_line_count(buf)
			while line_count > 0 do
				local last = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1]
				if last == "" then
					vim.api.nvim_buf_set_lines(buf, line_count - 1, line_count, false, {})
					line_count = line_count - 1
				else
					break
				end
			end
			-- 追加一个尾换行, 符合POSIX规范
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "" })

			-- 恢复光标位置, 刷新UI
			vim.api.nvim_win_set_cursor(win, cursor)
			vim.cmd("redraw")
			-- 保存文件, 不silent!, 保留基础报错, 只读/权限问题会提示
			vim.cmd("write")
		end, { desc = "Format + trim trailing empty lines + save" })
	end,
}

