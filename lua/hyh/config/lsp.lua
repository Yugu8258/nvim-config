local M = {}

M.setup = function(caps)
    -- Global LSP defaults
    vim.lsp.config("*", {
        root_markers = { ".git" },
    })

    -- Diagnostic UI
    vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = {
            border = "rounded",
        },
    })

    -- Override LSP floating preview handler
    local orig = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig(contents, syntax, opts, ...)
    end

    -- LSP Attach autocmd
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local buf = args.buf

            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
            end

            map("n", "K", vim.lsp.buf.hover, "Hover")
            map("n", "gd", vim.lsp.buf.definition, "Go definition")
            map("n", "gD", vim.lsp.buf.declaration, "Go declaration")
            map("n", "gi", vim.lsp.buf.implementation, "Go implementation")
            map("n", "go", vim.lsp.buf.type_definition, "Go type")
            map("n", "gr", vim.lsp.buf.references, "References")
            map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
            map("n", "gl", vim.diagnostic.open_float, "Diagnostic float")
            map("n", "<F2>", vim.lsp.buf.rename, "Rename")
            map({ "n", "x" }, "<F3>", function()
                vim.lsp.buf.format({ async = true })
            end, "Format")
            map("n", "<F4>", vim.lsp.buf.code_action, "Code action")

            if client:supports_method("textDocument/documentHighlight") then
                local hl_group = vim.api.nvim_create_augroup("my.lsp.hl", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = buf,
                    group = hl_group,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = buf,
                    group = hl_group,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            local excluded = { php = true, c = true, cpp = true }
            if
                not client:supports_method("textDocument/willSaveWaitUntil")
                and client:supports_method("textDocument/formatting")
                and not excluded[vim.bo[buf].filetype]
            then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("my.lsp.format", { clear = false }),
                    buffer = buf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
                    end,
                })
            end
        end,
    })

    -- LSP server configs
    vim.lsp.config["luals"] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        capabilities = caps,
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        },
    }

    vim.lsp.config["cssls"] = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        capabilities = caps,
        settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
        },
    }

    vim.lsp.config["intelephense"] = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_markers = { "composer.json", ".git" },
        capabilities = caps,
        settings = {
            intelephense = {
                files = { maxSize = 10000000 },
            },
        },
    }

    vim.lsp.config["ts_ls"] = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "typescript", "tsx", "jsx" },
        root_markers = { "tsconfig.json", "package.json", ".git" },
        capabilities = caps,
        settings = {
            completions = { completeFunctionCalls = true },
        },
    }

    vim.lsp.config["zls"] = {
        cmd = { "zls" },
        filetypes = { "zig" },
        root_markers = { "build.zig", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["nil"] = {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["rust_analyzer"] = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
        capabilities = caps,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = { command = "clippy" },
            },
        },
    }

    vim.lsp.config["clangd"] = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        root_markers = { "compile_commands.json", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["c3lsp"] = {
        cmd = { "c3-lsp" },
        filetypes = { "c3" },
        root_markers = { ".git" },
        capabilities = caps,
    }

    vim.lsp.config["serve_d"] = {
        cmd = { "serve-d" },
        filetypes = { "d" },
        root_markers = { "dub.json", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["jsonls"] = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { "package.json", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["hls"] = {
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        filetypes = { "haskell", "lhaskell" },
        root_markers = { "cabal.project", ".git" },
        capabilities = caps,
    }

    vim.lsp.config["gopls"] = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.mod", ".git" },
        capabilities = caps,
        settings = {
            gopls = {
                usePlaceholders = true,
                completeUnimported = true,
            },
        },
    }

    vim.lsp.config["templ"] = {
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_markers = { "go.mod", ".git" },
        capabilities = caps,
    }

    -- Activate all configured servers
    for name, _ in pairs(vim.lsp.config) do
        if name ~= "*" then
            vim.lsp.enable(name)
        end
    end
end

return M
