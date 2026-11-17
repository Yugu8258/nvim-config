-- 声明 neovim 全局
---@diagnostic disable: undefined-global
return {
    globals = { "vim" }
}

-- 可选：顺带关掉 122（禁止全局函数警告，如果你还保留老写法 function xxx()）
-- readme: https://luacheck.readthedocs.io/en/stable/warnings.html
-- 122: setting non-standard global variable
-- unused = false
-- ignore = { 122 }

