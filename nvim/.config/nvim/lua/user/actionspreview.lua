local status_ok, actionspreview = pcall(require, "actions-preview")
if not status_ok then
  return
end

vim.keymap.set({ "v", "n" }, "gx", require("actions-preview").code_actions)

require("actions-preview").setup {
  telescope = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
}

