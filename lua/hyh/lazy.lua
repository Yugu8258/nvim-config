-- ==============================================================================
-- lazy.nvim 插件管理器引导配置
-- ==============================================================================

-- 1. 确定 lazy.nvim 的安装路径
-- stdpath("data") 在 Linux/macOS 通常是 ~/.local/share/nvim
-- 在 Windows 通常是 ~/AppData/Local/nvim-data
-- 最终路径: <data>/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 2. 检查 lazy.nvim 是否已安装
-- (vim.uv or vim.loop): 兼容新旧 Neovim, 新版本用 vim.uv, 旧版本回退到 vim.loop
-- fs_stat 返回 nil 表示路径不存在(即尚未安装)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- 3. 未安装则从 GitHub 克隆
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	-- vim.fn.system 同步执行 git clone 命令：
	--   --filter=blob:none：无 blob 克隆，只拉取提交信息，克隆更快更省空间
	--   --branch=stable：使用 stable 分支（官方推荐的稳定版）
	--   lazyrepo：仓库地址
	--   lazypath：目标目录
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

	-- 4. 检查克隆是否成功
	-- vim.v.shell_error 保存上一条 shell 命令的退出码, 非 0 表示失败
	if vim.v.shell_error ~= 0 then
		-- 5. 克隆失败时向用户显示错误信息并退出
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },   -- 红色错误提示
			{ out, "WarningMsg" },                            -- git 命令的输出（错误详情）
			{ "\nPress any key to exit..." },                 -- 提示按任意键退出
		}, true, {})                                          -- true = 历史记录中保留, {} = 无额外选项
		vim.fn.getchar()                                      -- 阻塞等待用户按键
		os.exit(1)                                            -- 以退出码 1 终止 Neovim
	end
end

-- 6. 将 lazy.nvim 加入运行时路径(runtimepath)的最前面
-- 这样 require("lazy") 才能找到刚克隆的模块
vim.opt.rtp:prepend(lazypath)

-- 7. 初始化 lazy.nvim 并传入插件规格(spec)
require("lazy").setup({
	-- 8. 插件规格来源：从模块导入
	-- 相当于加载 lua/hyh/plugins/ 目录下的所有 .lua 文件(init.lua 或各插件文件)
	{ import = "hyh.plugins" },
	-- 加载 lua/hyh/plugins/lsp/ 目录下的 LSP 相关插件配置
	{ import = "hyh.plugins.lsp" },
}, {
	-- 9. lazy.nvim 自身的全局选项
	checker = {
		enabled = true,     -- 自动检查插件更新
		notify  = false,    -- 发现更新时不弹通知(避免打扰)
	},
	change_detection = {
		notify = false,     -- 配置文件变更时不弹通知(自动重载仍然生效)
	},
	ui = {
		border = "rounded", -- lazy.nvim 管理界面的浮动窗口使用圆角边框
	},
})
