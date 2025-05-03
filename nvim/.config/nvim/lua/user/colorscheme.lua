--local colorscheme = "flexoki-dark"
-- local colorscheme = "noctishc"
local colorscheme = "cyberdream"

-- the following tries to set the scheme and if it fails it just returns
-- no error thrown
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end
