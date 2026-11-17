return {
  "saghen/blink.cmp",
  version = "1.*",
  build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    keymap = { preset = "super-tab" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = { show_on_insert = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      ghost_text = { enabled = false },
    },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },
    fuzzy = {
      implementation = "rust",
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
  },
  config = function(_, opts)
    -- 先初始化 blink
    require("blink.cmp").setup(opts)
    -- blink 就绪之后，拿到 capabilities，启动 LSP
    local caps = require("blink.cmp").get_lsp_capabilities()
    require("hyh.config.lsp").setup(caps)
  end,
}

