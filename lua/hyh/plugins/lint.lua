return {
    "mfussenegger/nvim-lint",
    -- 加载时机: 打开文件前 / 新建文件时加载
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- 文件类型 -> 对应的 linter 映射表
        lint.linters_by_ft = {
            -- Web 前端
            javascript = { "biomejs" },
            typescript = { "biomejs" },
            javascriptreact = { "biomejs" },
            typescriptreact = { "biomejs" },
            svelte = { "biomejs" },

            -- HTML
            html = { "htmlhint" },

            -- CSS 样式
            css = { "stylelint" },
            scss = { "stylelint" },
            less = { "stylelint" },

            -- Python
            python = { "pylint" },

            -- C / C++ / 头文件
            c = { "clangtidy" },
            cpp = { "clangtidy" },
            h = { "clangtidy" },
            hpp = { "clangtidy" },

            -- Go
            go = { "golangcilint" },

            -- Rust
            rust = { "clippy" },

            -- Shell / Bash
            sh = { "shellcheck" },
            bash = { "shellcheck" },

            -- Lua
            lua = { "luacheck" },

            -- Markdown
            markdown = { "markdownlint" },

            -- JSON
            json = { "biomejs" },
            jsonc = { "biomejs" },

            -- YAML
            yaml = { "yamllint" },

            -- Zig
            zig = { "zls" },
        }

        -- 自动 lint 自动命令组
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        -- 手动触发 lint 快捷键
        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Lint: 手动触发代码检查" })
    end,
}
