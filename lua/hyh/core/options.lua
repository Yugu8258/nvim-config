-- ==============================================================================
-- Neovim 核心基础设置 | 稳定、高效、舒适
-- ==============================================================================

-- 关闭内置 netrw 文件管理器横幅
vim.g.netrw_banner = 0
-- 光标形状" n=普通模式, v=可视模式, i=插入模式, c=命令行模式, 统一为 block (块状)
vim.opt.guicursor = "n-v-i-c:block"

-- ------------------------------
-- 行号显示
-- ------------------------------
vim.opt.number = true         -- 显示当前行绝对行号
vim.opt.relativenumber = true -- 显示相对行号(跳行更方便)

-- ------------------------------
-- 缩进与换行
-- ------------------------------
vim.opt.tabstop = 4        -- Tab 显示宽度
vim.opt.shiftwidth = 4     -- 自动缩进宽度
vim.opt.softtabstop = 4    -- 编辑时 Tab 宽度
vim.opt.expandtab = true   -- Tab 转为空格
vim.opt.smartindent = true -- 代码智能缩进
vim.opt.wrap = false       -- 关闭代码自动换行

-- ------------------------------
-- 关闭垃圾文件 + 开启持久撤销
-- ------------------------------
vim.opt.swapfile = false                               -- 关闭 .swp 缓存文件
vim.opt.backup = false                                 -- 关闭备份文件
vim.opt.undofile = true                                -- 开启永久撤销(重启仍可撤销)
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- 设置撤销文件路径

-- ------------------------------
-- 搜索体验
-- ------------------------------
vim.opt.ignorecase = true    -- 搜索默认不区分大小写
vim.opt.smartcase = true     -- 输入大写则自动区分大小写
vim.opt.hlsearch = false     -- 关闭搜索结果高亮
vim.opt.incsearch = true     -- 实时搜索匹配
vim.opt.inccommand = "split" -- 实时预览替换结果

-- ------------------------------
-- UI 界面优化
-- ------------------------------
vim.opt.background = "dark"       -- 深色模式
vim.opt.scrolloff = 8             -- 光标上下保留 8 行(不贴边)
vim.opt.signcolumn = "yes"        -- 固定显示 git / 诊断图标列
vim.opt.winborder = "rounded"     -- 圆角浮动窗口
vim.opt.showmode = false          -- 不显示 --INSERT-- 等模式文字
vim.opt.laststatus = 3            -- 全局统一状态栏(更美观)
vim.opt.fillchars = { eob = " " } -- 空行不显示 ~

-- ------------------------------
-- 窗口分屏
-- ------------------------------
vim.opt.splitright = true -- 垂直分屏 → 右侧
vim.opt.splitbelow = true -- 水平分屏 → 下方

-- ------------------------------
-- 编码与字符
-- ------------------------------
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "gbk", "gb2312", "cp936" }
vim.opt.ambiwidth = "single" -- 避免中文符号错位

-- ------------------------------
-- 性能与交互
-- ------------------------------
vim.opt.updatetime = 50           -- 响应更快
vim.opt.mouse = "a"               -- 全模式开启鼠标
vim.opt.clipboard = "unnamedplus" -- 与系统剪贴板互通
vim.opt.virtualedit = "onemore"   -- 光标可移动到行尾外

-- ------------------------------
-- 编辑体验
-- ------------------------------
vim.opt.fixendofline = false  -- 不自动在文件末尾加换行
vim.opt.isfname:append("@-@") -- 支持 @ 符号文件名
vim.opt.viminfo:append("!")   -- 永久保存记录
