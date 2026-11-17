return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }, -- plenary 为必需依赖
        event = { "BufReadPost", "BufNewFile" }, -- 打开文件后再加载
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "下一个 todo 注释",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "上一个 todo 注释",
            },
        },
        opts = {
            signs = true, -- 在符号列显示图标
            sign_priority = 8, -- 符号优先级
            merge_keywords = true, -- 自定义关键字与默认值合并(而非替换)
            keywords = {
                FIX = {
                    icon = " ", -- 图标
                    color = "error", -- 颜色组: 错误
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- 同义关键字
                },
            },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            gui_style = {
                fg = "NONE", -- 前景样式: 无
                bg = "BOLD", -- 背景样式: 粗体
            },
            highlight = {
                multiline = true,    -- 启用多行 todo 注释
                multiline_pattern = "^.", -- 多行匹配模式
                multiline_context = 10, -- 多行上下文行数
                before = "",         -- 关键字左侧不高亮
                keyword = "wide",    -- 关键字使用 wide 高亮(含周围字符)
                after = "fg",        -- 关键字右侧只使用前景色
                pattern = [[.*<(KEYWORDS)\s*:]], -- 高亮匹配模式(vim regex)
                comments_only = true, -- 只匹配注释中的关键字(依赖 treesitter)
                max_line_len = 400,  -- 忽略超过 400 字符的行
                exclude = {},        -- 排除的文件类型
            },
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" }, -- 错误色
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" }, -- 警告色
                info = { "DiagnosticInfo", "#2563EB" },      -- 信息色
                hint = { "DiagnosticHint", "#10B981" },      -- 提示色
                default = { "Identifier", "#7C3AED" },       -- 默认色
                test = { "Identifier", "#FF00FF" },          -- 测试色
            },
            search = {
                command = "rg", -- 使用 ripgrep
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]], -- ripgrep 正则(保留 (KEYWORDS) 占位符)
            },
        },
    },
}
