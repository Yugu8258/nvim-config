return {
    {
        "rmagatti/alternate-toggler",
        keys = {
            { "<leader>i", "<cmd>ToggleAlternate<CR>", desc = "切换光标下单词（默认循环）" },
            {
                "<leader>it",
                function()
                    require("config.toggle").toggle_boolean()
                end,
                desc = "切换 true/false（含首字母大写变体）",
            },
            {
                "<leader>ic",
                function()
                    require("config.toggle").toggle_compare()
                end,
                desc = "切换比较运算符 ==/!=/===/!==",
            },
            {
                "<leader>il",
                function()
                    require("config.toggle").cycle_log_level()
                end,
                desc = "循环日志级别 info→warn→error→debug",
            },
            {
                "<leader>ip",
                function()
                    require("config.toggle").toggle_public_private()
                end,
                desc = "循环 public/private/protected",
            },
        },
        config = function()
            local ok, alt = pcall(require, "alternate-toggler")
            if not ok then
                return
            end

            alt.setup({
                alternates = {
                    -- 布尔值(保留大小写变体, 可分别切换)
                    { "true",   "false" },
                    { "True",   "False" },
                    { "TRUE",   "FALSE" },
                    -- 比较运算符
                    { "===",    "!==" },
                    { "==",     "!=" },
                    -- 日志级别循环(3+ 元素)
                    { "info",   "warn",    "error",    "debug" },
                    -- 访问修饰符循环
                    { "public", "private", "protected" },
                    -- 常用符号对
                    { "(",      ")" },
                    { "[",      "]" },
                    { "{",      "}" },
                    { '"',      "'" },
                    { "+",      "-" },
                    { "<",      ">" },
                    { "1",      "0" },
                    { "Yes",    "No" },
                },
            })
        end,
    },
}
