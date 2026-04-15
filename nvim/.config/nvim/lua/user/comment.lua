-- Disable the CursorHold autocmd — we trigger commentstring calculation
-- only when needed via Comment.nvim's pre_hook instead.
require("ts_context_commentstring").setup { enable_autocmd = false }

local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup {
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}
