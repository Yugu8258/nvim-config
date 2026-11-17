--[[
Neovide 专属配置
仅在 Neovide GUI 客户端加载, 原生终端 Neovim 直接跳过
文档参考: https://neovide.dev/configuration.html
]]
if not vim.g.neovide then
    return
end

-- ==============================================
-- 窗口视觉:透明度,磨砂模糊
-- ==============================================
-- 窗口整体不透明度, 1.0 完全不透明, <1.0 才会透出底层壁纸/桌面
vim.g.neovide_opacity = 0.85
-- 开启窗口磨砂模糊效果（macOS / Windows 支持较好, Linux 视窗口管理器）
vim.g.neovide_window_blurred = true
-- X / Y 方向模糊强度，数值越大越糊，推荐 4~12
vim.g.neovide_blur_amount_x = 8.0
vim.g.neovide_blur_amount_y = 8.0
-- 编辑器内容区域不透明度, 1.0 = 文字区域不透明
vim.g.neovide_normal_opacity = 1.0

-- 想要透出磨砂效果, 必须把 Normal 背景置空
vim.api.nvim_set_hl(0, "Normal", { bg = nil })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = nil })

-- ==============================================
-- 字体配置
-- guifont 格式: 字体名:h字号, 多字体为 fallback, 找不到第一个自动用第二个
-- ==============================================
vim.opt.guifont = {
    "JetBrainsMono Nerd Font",
    "FiraCode Nerd Font",
    ":h14",
}
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- ==============================================
-- 光标动画, 滚动动画
-- ==============================================
vim.g.neovide_cursor_animation_length = 0.13
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_animate_window = true

-- ==============================================
-- 输入与系统快捷键(macOS Command 键 <D->)
-- ==============================================
vim.g.neovide_input_use_logo = true

-- 复制粘贴
vim.keymap.set("v", "<D-c>", '"+y', { desc = "Neovide: Copy to system clipboard" })
vim.keymap.set("n", "<D-v>", '"+P', { desc = "Neovide: Paste from system clipboard" })
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Neovide: Paste from system clipboard" })

-- Command + Enter 切换全屏
vim.keymap.set("n", "<D-Enter>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = "Neovide: Toggle fullscreen" })

-- ==============================================
-- 字号动态缩放（Command + / Command -）
-- 修复: 普通模式 + 插入模式都支持缩放
-- ==============================================
local function get_font_size()
    local font_cfg = vim.opt.guifont:get()
    for _, item in ipairs(font_cfg) do
        local size = item:match("^:h(%d+)$")
        if size then
            return tonumber(size)
        end
    end
    return 14
end

local function set_font_size(new_size)
    local font_cfg = vim.opt.guifont:get()
    local clean = vim.tbl_filter(function(s)
        return not s:match("^:h%d+$")
    end, font_cfg)
    table.insert(clean, string.format(":h%d", new_size))
    vim.opt.guifont:set(clean)
end

local function font_zoom(delta)
    local sz = get_font_size()
    set_font_size(math.max(8, sz + delta))
end

vim.keymap.set({ "n", "i" }, "<D-+>", function() font_zoom(1) end, { desc = "Neovide: Increase font size" })
vim.keymap.set({ "n", "i" }, "<D-->", function() font_zoom(-1) end, { desc = "Neovide: Decrease font size" })

-- ==============================================
-- 其他杂项
-- ==============================================
vim.g.neovide_menu_embed = false
vim.g.neovide_allow_touchpad_scrolling = true
vim.g.neovide_title = "Neovide"

-- 可选补充
-- vim.g.neovide_cursor_antialiasing = true
-- vim.g.neovide_hide_mouse_when_typing = true
-- vim.g.neovide_remember_window_size = true
