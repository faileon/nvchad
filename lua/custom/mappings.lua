---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },

    -- close all buffers
    ["<leader>ax"] = { ":wa | %bd | e#<CR>", "close all buffers" },

    -- organize imports via tstools
    ["<leader>lo"] = { ":TSToolsOrganizeImports<CR>", "Organize imports via TSTools" },
    ["<leader>li"] = { ":TSToolsAddMissingImports<CR>", "Add missing imports via TSTools" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
