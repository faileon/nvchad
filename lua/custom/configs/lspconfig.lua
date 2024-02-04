local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-------------------
-- CSS SERVER
-------------------
lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern ".git",
  filetypes = {
    "css",
    "scss",
    "less",
  },
}

-------------------
-- HTML SERVER
-------------------
lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern ".git",
  filetypes = {
    "angular",
    "html",
  },
}

-------------------
-- TAILWIND SERVER
-------------------
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern ".git",
  filetypes = {
    "angular",
    "html",
    "css",
    "scss",
    "sass",
    "less",
  },
}

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
  root_dir = lspconfig.util.root_pattern ".git",
  filetypes = {
    "angular",
    "typescript",
  },
}

-----------
-- ESLINT
----------
lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    -- call the shared on attach
    on_attach(client, bufnr)
    -- custom on attach
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  root_dir = lspconfig.util.root_pattern ".git",
}

-----------
-- TSSERVER
----------
-- lspconfig.tsserver.setup {
--   on_attach = function(client, bufnr)
--     -- call the base on_attach
--     on_attach(client, bufnr)
--     print("on attach", client)
--
--     -- configure plugin
--     local method = "_typescript.configurePlugin"
--     client.request("workspace/executeCommand", {
--       command = method,
--       arguments = {
--         "@monodon/typescript-nx-imports-plugin",
--         {
--           externalFiles = {
--             {
--               mainFile = "C:/Projects/datera/web-applications/apps/absint-app/src/main.ts",
--               directory = "C:/Projects/datera/web-applications/apps/absint-app",
--             },
--           },
--         },
--       },
--     }, function(arg)
--       print("executeCommand response", arg)
--     end, bufnr)
--   end,
--   on_init = function(client, initialize_result)
--     print("INIT RESULT", client)
--
--     -- configure plugin
--     -- local method = "_typescript.configurePlugin"
--     -- local reqResult = client.request("workspace/executeCommand", {
--     --   command = method,
--     --   arguments = {
--     --     "@monodon/typescript-nx-imports-plugin",
--     --     {
--     --       externalFiles = {
--     --         {
--     --           mainFile = "C:/Projects/datera/web-applications/apps/absint-app/src/main.ts",
--     --           directory = "C:/Projects/datera/web-applications/apps/absint-app",
--     --         },
--     --       },
--     --     },
--     --   },
--     -- })
--     -- print("workspace/executeCommand result", reqResult)
--   end,
--   capabilities = capabilities,
--   root_dir = lspconfig.util.root_pattern ".git",
--   -- cmd = { "typescript-language-server", "--stdio", "--log-level", "4" },
--   init_options = {
--     hostInfo = "neovim",
--     plugins = {
--       {
--         name = "@monodon/typescript-nx-imports-plugin",
--         location = "C:\\Users\\tomasbird\\AppData\\Roaming\\nvm\\v18.10.0",
--       },
--     },
--     tsserver = {
--       logVerbosity = "verbose",
--     },
--   },
-- }

-- local constants = require "typescript-tools.protocol.constants"
-- local method = constants.CustomMethods.ConfigurePlugin
-- local args = {
--   pluginName = "@monodon/typescript-nx-imports-plugin",
--   configuration = {
--     externalFiles = {
--       {
--         mainFile = "C:/Projects/datera/web-applications/apps/absint-app/src/main.ts",
--         directory = "C:/Projects/datera/web-applications/apps/absint-app/src",
--       },
--       -- {
--       --   mainFile = "C:/Projects/datera/web-applications/libs/dashboards/common/models/dashboard/src/index.ts",
--       --   directory = "C:/Projects/datera/web-applications/libs/dashboards/common/models/dashboard/src",
--       -- },
--     },
--   },
-- }
-----------
-- TSSERVER via typescript-tools:
----------
require("typescript-tools").setup {
  on_init = function(client, bufnr)
    vim.schedule(function()
      vim.cmd.NxInit()
    end)
  end,
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern ".git",
  settings = {
    tsserver_plugins = {
      "@monodon/typescript-nx-imports-plugin",
    },
    tsserver_logs = "verbose",
  },
}

require("todo-comments").setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
