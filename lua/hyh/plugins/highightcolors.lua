-- ==============================================================================
-- nvim-highlight-colors: 在代码中直观显示颜色值对应的实际颜色
-- 依赖 termguicolors 开启, 直接加载无需延迟
-- ==============================================================================

return {
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            -- 前置条件: 必须开启 termguicolors, 否则颜色无法正确渲染
            vim.opt.termguicolors = true

            -- 基础配置(使用默认值, 所有常见颜色格式均已启用)
            require("nvim-highlight-colors").setup({
                render = "background",   -- 渲染模式: background(背景色) / foreground(前景色) / virtual(虚拟符号)
                enable_hex = true,       -- 启用 #FFFFFF 格式
                enable_short_hex = true, -- 启用 #FFF 短格式
                enable_rgb = true,       -- 启用 rgb(0 0 0) 格式
                enable_hsl = true,       -- 启用 hsl(150deg 30% 40%) 格式
                enable_var_usage = true, -- 启用 CSS 变量引用如 var(--color)
                enable_named_colors = true, -- 启用命名颜色如 green
                enable_tailwind = false, -- 是否启用 Tailwind 颜色名(如 bg-blue-500), 按需开启
            })
        end,
    },
}
