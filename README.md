## Neovim Config
Personal Neovim config powered by lazy.nvim, built for backend development.
Targets: Go / C/C++ / Zig / TS / Lua / Markdown.
Minimal & restrained, no redundant animations, optimized for Neovide GUI.

## ✨ Features
- **Package Manager**: lazy.nvim, lazy loading, auto plugin update detection, silent reload on config change
- **LSP Stack**: native `vim.lsp.config`, blink.cmp for completion, mason for toolchain management
  - Servers: clangd, gopls, rust_analyzer, zls, ts_ls, lua_ls, marksman, bashls
  - Auto LSP attach mappings: hover, jump, rename, code action
- **Formatting**: conform.nvim
  - Biome: JS/TS/CSS/HTML
  - prettier: json/yaml/svelte
  - clang-format: C/C++
  - stylua / gofmt
  - markdown: auto toc via `<!-- toc -->`
  - **Manual trigger only**: `<leader>fm` to format + save; `:w` saves without formatting
- **Lint**: nvim-lint, static analysis, triggered on BufWritePost / InsertLeave
- **Syntax & Code Enhancement**
  - treesitter: syntax highlighting, custom textobjects `af` / `if` (around/inside function)
  - nvim-ufo: treesitter based folding, all unfolded by default
  - treesitter-context: sticky context header, max 3 lines
  - rainbow-delimiters: rainbow brackets, matched with rose-pine-moon
  - virt-column: 120 column marker
- **Completion**: blink.cmp (rust backend, high performance), sources: snippets / path / buffer / lsp
- **UI & Statusline**
  - Colorscheme: rose-pine-moon, transparent background
  - lualine: global statusline, transparent, nerdfont icons
  - incline: floating window filename label
  - noice: command & hover ui, suppress noisy progress messages
  - winbar: nvim-navic symbol breadcrumb
- **File Explorer**: oil.nvim (replaces netrw)
  - `-` open parent directory
  - `<leader>e` floating oil window
- **Git Toolchain**
  - vim-fugitive: git wrapper, `<leader>gg` open fugitive
  - gitsigns: line diff, stage / reset / preview hunk
  - lazygit.nvim: `<leader>lg` lazygit
  - git-worktree.nvim: telescope integration for worktree management
- **Terminal**: toggleterm, `<Alt+Enter>` toggle floating terminal
- **Text Utilities**
  - todo-comments: highlight & jump FIXME / TODO / HACK / WARN / PERF / NOTE
  - undotree: visual undo tree `<leader>u`
  - alternate-toggler: toggle true<->false, ==<->!=, access modifier, log level
  - markdown ftplugin: checkbox & list toggle, colored heading background
- **Editing Experience**
  - nvim-autopairs: treesitter-aware auto pairs
  - Global mappings: centered search, blackhole register, global replace, copy file path
  - Direction keys disabled, hjkl only
  - Yank highlight, persistent undo, swapfile / backup disabled
- **Tmux Integration**: vim-tmux-navigator, `<C-h/j/k/l>` cross pane navigation
- **Neovide Exclusive**: frosted transparent window, railgun cursor, macOS Command bindings, font zoom

## 📁 Structure
```bash
.
├── ftplugin
│   ├── cpp.lua
│   ├── markdown.lua
│   ├── python.lua
│   └── typescriptreact.lua
├── init.lua                 # 入口，lazy.nvim bootstrap
├── lazy-lock.json           # 插件版本锁定
├── lua/hyh
│   ├── core
│   │   ├── init.lua
│   │   ├── keymaps.lua      # 全局快捷键
│   │   └── options.lua      # 全局 vim.opt
│   ├── config
│   │   ├── hyhsitter.lua    # treesitter 自定义指令、textobject
│   │   ├── init.lua
│   │   ├── lsp.lua          # LSP 服务配置、on_attach、C/C++ 排除自动格式化
│   │   ├── neovide.lua      # Neovide GUI 配置
│   │   └── toggle.lua       # 单词切换工具函数
│   ├── lazy.lua             # lazy 加载入口
│   └── plugins              # 所有插件独立配置，lazy 自动导入
│       ├── autopairs.lua
│       ├── blink.lua
│       ├── cmppath.lua
│       ├── colortheme.lua
│       ├── cursorline.lua
│       ├── formatter.lua    # conform.nvim
│       ├── gitstuff.lua
│       ├── gitworstree.lua
│       ├── highightcolors.lua
│       ├── incline.lua
│       ├── lint.lua
│       ├── lspconfig.lua
│       ├── lualine.lua
│       ├── mason.lua
│       ├── navic.lua
│       ├── noice.lua
│       ├── nvimufo.lua
│       ├── oil.lua
│       ├── rainbow.lua
│       ├── snacks.lua       # 仅缩进线 + scope 高亮
│       ├── stickybuf.lua
│       ├── tmux.lua
│       ├── todocomments.lua
│       ├── toggle.lua
│       ├── toggleterm.lua
│       ├── treesittercontext.lua
│       ├── treesitter.lua
│       ├── undotree.lua
│       └── virtcolumn.lua
└── README.md

```


## ⌨️ 核心快捷键
空格 = `<leader>`

### 格式化 & 保存
- `<leader>fm`：格式化 + 清理尾空行 + 保存（conform）
- `:w`：原生保存，不会自动格式化

### LSP
- `K`：hover 文档
- `gd`：跳定义
- `gD`：跳声明
- `gi`：实现
- `gr`：引用
- `gs`：签名提示
- `gl`：诊断悬浮
- `<F2>`：重命名
- `<F3>`：LSP 格式化（备选）
- `<F4>`：code action

### 文本对象（treesitter）
- `af`：around function
- `if`：inside function

### Git
- `<leader>gg`：Fugitive git
- `<leader>lg`：LazyGit
- `<leader>gs`：stage hunk
- `<leader>gr`：reset hunk
- `<leader>gbl`：blame line
- `<leader>wl`：list git worktree
- `<leader>wc`：create git worktree

### 文件浏览
- `-`：打开当前文件所在目录（oil）
- `<leader>e`：浮动 oil

### 切换工具
- `<leader>i`：alternate-toggler 通用切换
- `<leader>it`：true/false
- `<leader>ic`：== / != / === / !==
- `<leader>il`：info/warn/error/debug
- `<leader>ip`：public/private/protected

### Markdown（buffer-local）
- `tn`：切换编号列表
- `tb`：切换项目符号
- `tc`：切换复选框
- `tt`：勾选/取消任务
- `tl`：智能循环切换列表类型

### 折叠
- `zR`：全部展开
- `zM`：全部折叠

### 其他
- `<leader>u`：Undotree
- `<leader>l`：手动触发 lint
- `<leader>s`：全局替换光标下单词
- `<leader>fp`：复制当前文件路径
- `<A-Enter>`：浮动终端
- `<leader>tc`：toggle treesitter context
- `<leader>N`：Noice 消息面板
- `<leader>sN`：Noice pick 历史消息

### tmux
- `Ctrl+h/j/k/l`：窗口跳转

## 🧰 依赖
外部工具（PATH 中）
- clangd、clang-format、clang-tidy（C/C++）
- gopls、gofmt（Go）
- rust-analyzer（Rust）
- zls（Zig，版本对齐）
- biome、prettier、stylua
- shellcheck、shfmt
- markdownlint、markdown-toc
- lazygit、git
- ripgrep（todo-comments 搜索）
- Nerd Font（JetBrainsMono Nerd Font 推荐）

Neovim 版本
- Neovim ≥ 0.10（使用原生 vim.lsp.config）

## 🚀 安装
备份原有 nvim 配置
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

克隆仓库
```bash
git clone https://github.com/Yugu8258/nvim-config.git ~/.config/nvim
```

打开 nvim，lazy 自动下载插件
```bash
nvim
```

进入 Mason 安装缺失 LSP /lint 工具
```bash
:Mason
```

##  规范说明

- 格式化策略：控制权交给用户，不劫持 `:w`
- 缩进：C/C++ 4 空格；JS/TS 2 空格；Lua 4 空格
- 文件末尾：POSIX 规范，保留单个换行
- 配色：统一 rose-pine-moon，透明背景适配 Neovide
- 所有通知默认静默，减少刷屏干扰

## 📌 已知说明

- clangd 在 lsp.lua 里被排除 BufWritePre 自动格式化，由 conform 接管
- markdown 列表切换只在 ftplugin/markdown.lua 缓冲区生效
- snacks 仅启用缩进线，其余模块全部关闭，避免冲突
- 关闭 swapfile /backup，开启 undofile 持久撤销

