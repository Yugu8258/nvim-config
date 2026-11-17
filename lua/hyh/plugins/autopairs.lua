-- ==============================================================================
-- nvim-autopairs: 自动配对括号, 引号, 标签等
-- ==============================================================================

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- 延迟加载: 首次进入插入模式才加载
        dependencies = { -- 可选: 若使用 nvim-cmp, 可在此声明依赖(也可不写, 下方用 pcall 兜底)
            -- "hrsh7th/nvim-cmp",
        },
        config = function()
            -- 安全加载插件, 避免插件缺失时报错
            local ok, autopairs = pcall(require, "nvim-autopairs")
            if not ok then
                return
            end

            -- 主配置
            autopairs.setup({
                check_ts = true, -- 开启 treesitter 智能判断
                ts_config = {
                    lua = { "string" }, -- lua 字符串里不配对
                    -- java = false,       -- java 不使用 treesitter 判断
                },
            })

            -- 若存在 nvim-cmp, 则联动: 选中函数补全项时自动补全括号
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end

            -- 自定义规则: 让 html / vue / jsx 中的 < > 也自动配对
            local Rule = require("nvim-autopairs.rule")
            autopairs.add_rules({
                Rule("<", ">", { "html", "vue", "jsx" }),
            })
        end,
    },
}
