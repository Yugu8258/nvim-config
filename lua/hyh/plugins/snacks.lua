return {
    {
        "folke/snacks.nvim",
        priority = 1000, -- 高优先级, 确保在其他插件之前加载
        lazy = false, -- 立即加载, 不能懒加载(部分模块需尽早注册 autocmd)
        opts = {
            indent = {
                enabled = true, -- 启用缩进线
                char = "│", -- 缩进线字符
                scope = {
                    enabled = true, -- 高亮当前作用域(替代原 show_current_context)
                },
                chunk = {
                    enabled = false, -- 将作用域渲染为块(可选, 按需保留)
                },
            },

            -- 显式关闭其他所有模块, 避免意外启用
            dashboard = { enabled = false }, -- 关闭启动页
            picker = { enabled = false }, -- 关闭选择器
            explorer = { enabled = false }, -- 关闭文件浏览器
            layout = { enabled = false }, -- 关闭布局管理
            win = { enabled = false }, -- 关闭窗口工具
            input = { enabled = false }, -- 关闭输入框
            quickfile = { enabled = false }, -- 关闭快速文件渲染
            image = { enabled = false }, -- 关闭图片预览
            scroll = { enabled = false }, -- 关闭滚动动画
        },
    },
}
