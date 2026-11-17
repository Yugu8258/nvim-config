return {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    config = function()
        -- 导入模块
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- Mason 基础配置（LSP/工具安装UI）
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓", -- 已安装
                    package_pending = "➜", -- 等待安装
                    package_uninstalled = "✗", -- 未安装
                },
            },
        })

        -- mason-lspconfig 桥接配置: 自动安装LSP服务端
        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",    -- Lua LSP
                "ts_ls",     -- TypeScript / JavaScript LSP
                "html",      -- HTML LSP
                "cssls",     -- CSS LSP
                "tailwindcss", -- Tailwind CSS LSP
                "gopls",     -- Go LSP
                "angularls", -- Angular LSP
                "emmet_language_server", -- Emmet 语法补全
                "marksman",  -- Markdown LSP
                "rust_analyzer", -- Rust LSP
                "zls",       -- Zig LSP(注意: 需要和本地Zig版本严格匹配)
                "bashls",    -- Bash / Shell LSP
                -- 删掉 neocmake / neocmakelsp，避免mason-lspconfig名称校验报错
            },
        })

        -- mason-tool-installer: 自动安装格式化, lint工具
        mason_tool_installer.setup({
            ensure_installed = {
                "prettier", -- 通用格式化(JS/TS/HTML/CSS等)
                "stylua", -- Lua代码格式化
                "denols", -- Deno LSP
                "shellcheck", -- Shell静态检查
                "shfmt", -- Shell脚本格式化
                "ruff", -- Python Lint & 格式化
            },
            auto_update = false, -- 启动时不自动更新工具版本
            run_on_start = true, -- Neovim启动时自动检测并安装缺失工具
        })
    end,
}
