local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-------------
-- ANGULAR
-------------
local install_path = vim.fn.stdpath "data" .. "/mason/packages/angular-language-server/node_modules"
-- local cwdpath = vim.fn.getcwd() .. "/node_modules"
local ang = install_path .. "/@angular/language-server/node_modules"

local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  install_path,
  "--ngProbeLocations",
  ang,
}

lspconfig.angularls.setup {
  on_attach = on_attach,
  cmd = cmd,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = cmd
  end,
  root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
}

-----------
-- ESLINT
----------
lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  root_dir = lspconfig.util.root_pattern ".eslintrc.json",
}
