return {
    {
        "b0o/incline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- 文件图标依赖
        event = "VeryLazy",                         -- 启动完成后加载, 不拖慢启动
        config = function()
            -- 安全加载：插件异常时静默返回，不阻塞启动
            local ok, incline = pcall(require, "incline")
            if not ok then
                return
            end

            -- 图标库为可选依赖, 加载失败时降级为无图标
            local ok_devicons, devicons = pcall(require, "nvim-web-devicons")

            incline.setup({
                hide = {
                    cursorline = false, -- 光标行上不隐藏状态栏
                    focused_win = false, -- 聚焦窗口也显示
                    only_win = false, -- 只有一个窗口时仍显示
                },

                window = {
                    margin = { horizontal = 2, vertical = 1 }, -- 外边距
                    padding = { left = 0, right = 0 }, -- 内边距
                    padding_char = " ",         -- 内边距填充字符
                    zindex = 100,               -- 浮动窗口层级
                    winhighlight = {
                        Normal = "NormalFloat", -- 活动窗口背景
                        NormalNC = "NormalFloat", -- 非活动窗口背景
                    },
                },

                render = function(props)
                    local bufname = vim.api.nvim_buf_get_name(props.buf)
                    local filename = vim.fn.fnamemodify(bufname, ":t") -- 只取文件名

                    if filename == "" then
                        filename = "[No Name]" -- 未命名缓冲区
                    end

                    -- 获取文件图标与图标颜色（devicons 不可用时为空）
                    local icon, icon_color = "", nil
                    if ok_devicons then
                        icon, icon_color = devicons.get_icon(
                            filename,
                            vim.fn.fnamemodify(bufname, ":e"), -- 扩展名
                            { default = true }
                        )
                    end

                    local modified = vim.bo[props.buf].modified -- 缓冲区是否已修改

                    return {
                        { " " },
                        { icon .. " ", guifg = icon_color },    -- 图标
                        { filename,    gui = modified and "bold,italic" or "none" }, -- 文件名, 修改时加粗斜体
                        modified and { " [+] ", guifg = "#ff9e64" } or " ", -- 修改标记
                    }
                end,
            })
        end,
    },
}
