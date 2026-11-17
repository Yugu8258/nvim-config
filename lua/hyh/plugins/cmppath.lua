return {
    "hrsh7th/cmp-path",
    -- 依赖nvim-cmp
    dependencies = { "hrsh7th/nvim-cmp" },
    -- 加载时机：插入模式补全时加载
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        -- 注册路径补全源
        cmp.setup({
            sources = cmp.config.sources({
                { name = "path" }, -- 文件路径补全源
            }),
        })
    end,
}
