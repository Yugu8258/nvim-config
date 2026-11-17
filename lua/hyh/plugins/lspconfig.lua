return {
    "neovim/nvim-lspconfig",
    -- 触发时机: 打开文件前加载LSP配置
    event = { "BufReadPre", "BufNewFile" },
    -- 依赖mason, 保证安装工具先于LSP配置执行
    dependencies = {
        "williamboman/mason.nvim",
    },
    config = function()
        --- LSP附加回调: LSP挂载成功后执行, 统一设置缓冲区快捷键
        --- @param client vim.lsp.Client
        --- @param bufnr integer
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }

            vim.keymap.set("n", "gd",        vim.lsp.buf.definition,       opts) -- 跳转到定义
            vim.keymap.set("n", "gD",        vim.lsp.buf.declaration,      opts) -- 跳转到声明
            vim.keymap.set("n", "gr",        vim.lsp.buf.references,       opts) -- 查看引用
            vim.keymap.set("n", "gi",        vim.lsp.buf.implementation,   opts) -- 跳转到实现
            vim.keymap.set("n", "K",         vim.lsp.buf.hover,            opts) -- 悬浮提示文档
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename,           opts) -- 重命名符号
            vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action,      opts) -- 代码修复/操作
            vim.keymap.set("n", "<space>f",  function()
                vim.lsp.buf.format({ async = true })
            end, opts) -- 格式化代码(异步)
        end

        -- LSP服务配置表
        local servers = {
            lua_ls = { -- Lua LSP
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },           -- 使用Neovim内置LuaJIT
                        diagnostics = { globals = { "vim" } },      -- 识别vim全局变量, 消除警告
                        workspace = { checkThirdParty = false },    -- 关闭第三方库检测, 减少弹窗
                        telemetry = { enable = false },             -- 关闭遥测上报
                    },
                },
            },
            ts_ls = {},                     -- JavaScript / TypeScript LSP
            html = {},                      -- HTML LSP
            cssls = {},                     -- CSS LSP
            tailwindcss = {},               -- TailwindCSS LSP
            gopls = { -- Go LSP
                settings = {
                    gopls = {
                        completeUnimported = true, -- 自动补全未导入包
                        usePlaceholders = true,    -- 函数参数补全占位符
                    },
                },
            },
            angularls = {},                 -- Angular LSP
            emmet_language_server = {},     -- Emmet 缩写补全
            marksman = {},                  -- Markdown LSP
            rust_analyzer = {},             -- Rust LSP
            zls = {},                       -- Zig LSP (版本必须和本地Zig严格匹配)
            bashls = {},                    -- Bash / Shell LSP
            -- clangd：系统全局安装，不由mason管理
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",       -- 后台索引工程，提升补全速度
                    "--clang-tidy",             -- 开启clang-tidy静态检查
                    "--header-insertion=never" -- 禁止自动插入头文件(避免和你原有代码冲突)
                },
            },
        }

        -- 遍历所有LSP, 统一注入on_attach钩子并启用
        for server_name, user_opts in pairs(servers) do
            vim.lsp.config(
                server_name,
                vim.tbl_deep_extend("force", user_opts, {
                    on_attach = on_attach,
                })
            )
            vim.lsp.enable(server_name)
        end

        -- 【可选】CMake LSP, 需要手动安装 neocmakelsp 后再取消注释
        -- vim.lsp.config("neocmake", {
        --     cmd = { "neocmakelsp", "--stdio" },
        --     on_attach = on_attach,
        -- })
        -- vim.lsp.enable("neocmake")
    end,
}

