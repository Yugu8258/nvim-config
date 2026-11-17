return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("treesitter-context").setup({
            enable = true,   -- 开启插件
            max_lines = 3,   -- 最多显示多少行上下文
            min_lines = 0,
            line_numbers = true, -- 是否显示行号
            multiline_threshold = 20, -- 单行上下文阈值
            trim_scope = "outer",
            mode = "cursor", -- cursor / topline
            separator = "-", -- 分隔线, 比如 "─"
            zindex = 20,
        })

        -- 切换上下文显示
        vim.keymap.set("n", "<leader>tc", function()
            require("treesitter-context").toggle()
        end, { desc = "Toggle Treesitter Context" })
    end,
}
