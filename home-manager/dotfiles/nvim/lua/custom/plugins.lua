local cmp = require "cmp"

local plugins = {
  { "nvim-neotest/nvim-nio" },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function (_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  { "folke/neodev.nvim", opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    config = function ()
      require("telescope").load_extension("git_worktree")
    end,
  },
  {
    "hudclark/grpc-nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "ThePrimeagen/git-worktree.nvim",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = { "python" },
    config = function ()
      require "custom.configs.null-ls"
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      messages = {
        enabled = false,
      },
    },
    config = function (_, opts)
      require("noice").setup(opts)
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      {
        "tpope/vim-dadbod",
        lazy = false,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "typescript-language-server",
        "prettier",
        "js-debug-adapter",
        "terraform-ls",
        "gopls",
        "pyright",
        "mypy",
        "ruff",
        "black",
        "debugpy",
        "lua-language-server",
        "nil",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init =function ()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    opts = function ()
      local lspconfig = require("plugins.configs.lspconfig")
      -- local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
      -- local codelldb_path = extension_path .. 'adapter/codelldb'
      -- local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
      return {
        dap = {
          adapter = {
            type = "executable",
            command = "lldb",
            name = "rt_lldb",
          },
        },
        server = {
          tools = {
            hover_actions = {
              auto_focus = true,
            },
          },
          on_attach = lspconfig.on_attach,
          capabilities = lspconfig.capabilities,
        },
      }
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "crnvl96/lazydocker.nvim",
    opts = {},  -- automatically calls `require("lazydocker").setup()`
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      cmp.setup.buffer({
        sources = { { name = "crates" }}
      })
      crates.show()
      require("core.utils").load_mappings("crates")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      table.insert(M.sources, {name = "crates"})
      return M
    end,
  },
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function ()
      return require("custom.configs.formatter")
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "laytan/cloak.nvim",
    lazy = false,
    config = function ()
      require("cloak").setup({
        enabled = true,
        cloak_character = "*",
        -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
        highlight_group = "Comment",
        patterns = {
          {
            -- Match any file starting with ".env".
            -- This can be a table to match multiple file patterns.
            file_pattern = {
                ".env*",
                "wrangler.toml",
                ".dev.vars",
            },
            -- Match an equals sign and any character after it.
            -- This can also be a table of patterns to cloak,
            -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
            cloak_pattern = "=.+"
          },
        },
      })
    end,
  },
}

return plugins
