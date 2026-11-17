return {
    {
        "lukas-reineke/virt-column.nvim",
        event = { "BufReadPost", "BufNewFile" }, -- 打开文件后再加载, 避免拖慢启动
        config = function()
            -- 安全加载: 插件异常时静默返回, 不阻塞启动
            local ok, virt_column = pcall(require, "virt-column")
            if not ok then
                return
            end

            virt_column.setup({
                virtcolumn = "120", -- 代码长度提示列, 第 120 列显示竖线
                char = "│", -- 竖线字符
                highlight = "NonText", -- 高亮组, 与背景融合不刺眼
                exclude = { -- 排除不需要显示的界面（注意: 该选项在部分版本中可能未被完全遵循[citation:6])
                    filetypes = {
                        "alpha",
                        "dashboard",
                        "neo-tree",
                        "toggleterm",
                        "lazy",
                        "mason",
                        "TelescopePrompt",
                        "notify",
                    },
                    buftypes = {
                        "terminal",
                        "quickfix",
                        "help",
                        "nofile",
                        "prompt",
                    },
                },
            })
        end,
    },
}
