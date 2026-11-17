return {
    "folke/noice.nvim",
    -- 加载时机: Neovim 启动完成后延迟加载
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },

    -- 自定义快捷键映射
    keys = {
        { "<leader>sN", "<CMD>Noice pick<CR>", desc = "[Noice] 查看消息历史" },
        { "<leader>N", "<CMD>Noice<CR>", desc = "[Noice] 打开Noice面板" },
    },

    -- Noice 核心配置
    opts = {
        -- 关闭内置弹出菜单, 交给 nvim-cmp 接管
        popupmenu = { enabled = false },
        -- 关闭 Noice 接管通知, 留给其他通知插件(如 nvim-notify)
        notify = { enabled = false },

        -- LSP UI 渲染美化
        lsp = {
            override = {
                -- 启用 markdown 格式转换, 美化 hover 文档
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                -- 美化 markdown 样式渲染
                ["vim.lsp.util.stylize_markdown"] = true,
            },
            signature = { enabled = true }, -- 函数签名悬浮提示
            hover = { enabled = true }, -- 鼠标悬浮文档提示
        },

        -- 预设模板开关
        presets = {
            bottom_search = false, -- 不在底部命令行显示搜索
            command_palette = true, -- 启用悬浮式命令行面板
            long_message_to_split = true, -- 超长消息自动切到分割窗口展示
            inc_rename = false,  -- 关闭内置实时重命名, 使用原生LSP rename
            lsp_doc_border = true, -- LSP悬浮提示增加边框, 视觉更清晰
        },

        -- 消息路由规则: 过滤, 屏蔽不需要的刷屏消息
        routes = {
            -- 屏蔽LSP索引进度(rust-analyzer indexing 等进度提示), 保留报错, 诊断, hover
            { filter = { event = "lsp", kind = "progress" },          opts = { skip = true } },
            -- 屏蔽搜索计数提示(xx matches)
            { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
            -- 屏蔽保存,复制,撤销重做这类无关消息
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d+ lines yanked" },
                        { find = "Already at oldest change" },
                        { find = "Already at newest change" },
                    },
                },
                opts = { skip = true },
            },
        },

        -- 悬浮命令行样式配置
        cmdline = {
            enabled = true,
            format = {
                cmdline = { icon = " " },
                search_down = { icon = " " },
                search_up = { icon = " " },
                filter = { icon = "" },
                lua = { icon = " " },
            },
        },
    },
}
