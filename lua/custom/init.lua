-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- Folding with "zc"
local opt = vim.opt
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Relative numbers
vim.wo.relativenumber = true
-- Current line shows as absolute number
vim.wo.number = true

-- Set the filetype of Angular HTML Component files to 'angular'
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.component.html",
  command = "set filetype=angular",
})

-------------
-- nx command testing
-------------
vim.api.nvim_create_user_command("NxInit", function()
  print "Running nx init..."
  local now = tostring(os.time())
  local fileName = string.format("%s_graph.json", now)
  local cmd = string.format("npx nx graph --file=%s", fileName)

  local function handle_response(_, code)
    -- read the file into memory
    local projectGraphFile = io.open(fileName, "r")
    if projectGraphFile then
      -- read project graph from file
      local projectGraph = vim.json.decode(projectGraphFile:read "*a")
      projectGraphFile:close()

      -- remove the graph file
      os.remove(fileName)

      -- get typescript-tools lsp client
      local lspClients = vim.lsp.get_active_clients()
      local tsclient
      for _, client in ipairs(lspClients) do
        if client.name == "typescript-tools" then
          tsclient = client
        end
      end
      if not tsclient then
        print "typescript-tools.nvim not active"
        return
      end

      -- get workspace root
      -- always first? alternatives to get absolute workspace root?
      local workspacePath = tsclient.config.workspace_folders[1].name
      if not workspacePath then
        print "Could not figure out workspace path"
        return
      end

      -- create external files for monodon
      local externalFiles = {}
      for _, project in pairs(projectGraph.graph.nodes) do
        local sourceRoot = project.data.sourceRoot

        -- skip the root
        if sourceRoot ~= "." and sourceRoot then
          -- localte the entry file. perhaps use tsconfig.[app|lib].json
          local mainFile
          if
            project.data
            and project.data.targets
            and project.data.targets.build
            and project.data.targets.build.options
            and project.data.targets.build.options.main
          then
            mainFile = workspacePath .. "/" .. project.data.targets.build.options.main
          else
            mainFile = workspacePath .. "/" .. sourceRoot .. "/index.ts"
          end

          -- insert to config
          table.insert(externalFiles, {
            mainFile = mainFile, -- this is not always index.ts!
            directory = workspacePath .. "/" .. sourceRoot,
          })
        end
      end

      -- print(vim.inspect(externalFiles))
      -- send configuration request of monodon plugin to tsserver
      local constants = require "typescript-tools.protocol.constants"
      local method = constants.CustomMethods.ConfigurePlugin
      local args = {
        pluginName = "@monodon/typescript-nx-imports-plugin",
        configuration = {
          externalFiles = externalFiles,
        },
      }
      tsclient.request(method, args, function()
        print("tsserver handled configuration request", method)
      end)
      print "nx plugin initialized!"
    end
  end

  -- call nx deamon with graph request, run it in the background with job
  local job_id = vim.fn.jobstart(cmd, {
    on_exit = handle_response,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, {})
