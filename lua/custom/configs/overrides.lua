local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "markdown",
    "markdown_inline",
    "angular",
    "svelte",
    "astro",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "prettier",
    "angular-language-server",
    "eslint-lsp",
    "tree-sitter-cli",
    "tailwindcss-language-server",
    "svelte-language-server",
    "json-lsp",
    "python-lsp-server",
    "astro",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  view = {
    adaptive_size = true,
  },
}

-- TODO: does not work on windows? cmp-npm uses "npm" but it can't see it in the PATH for some reason?
-- M.cmp = {
--   sources = {
--     { name = "npm", keyword_length = 3 },
--   },
-- }

return M
