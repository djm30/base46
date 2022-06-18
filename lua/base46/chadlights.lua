local merge_tb = require("base46").merge_tb

local ui = require("core.utils").load_config().ui
local highlights = {}
local hl_dir = vim.fn.stdpath "data" .. "/site/pack/packer/opt/base46/lua/base46/integrations"

-- push hl_dir file names to table
local hl_files = require("plenary.scandir").scan_dir(hl_dir, {})

for _, file in ipairs(hl_files) do
   local a = vim.fn.fnamemodify(file, ":t")
   a = vim.fn.fnamemodify(a, ":r")

   local integration = require("base46.integrations." .. a)
   highlights = merge_tb(highlights, integration)
end

-- polish theme specific highlights
local polish_hl = require("base46").get_theme_tb "polish_hl"

if polish_hl then
   highlights = merge_tb(highlights, polish_hl)
end

-- override user highlights if there are any
local user_highlights = ui.hl_override
local colors = require("base46").get_theme_tb "base_30"

-- fg = "white" set by user becomes fg = colors["white"]
-- so no need for the user to import colors

for group, _ in pairs(user_highlights) do
   for key, val in pairs(user_highlights[group]) do
      if key == "fg" or key == "bg" then
         if val:sub(1, 1) == "#" or val == "none" or val == "NONE" then
            user_highlights[group][key] = val
         else
            user_highlights[group][key] = colors[val]
         end
      end
   end
end

highlights = merge_tb(highlights, user_highlights)

-- local set_transparent = nvchad.load_config().ui.transparency
if vim.g.transparency then
   highlights = merge_tb(highlights, require "base46.glassy")
end

return highlights