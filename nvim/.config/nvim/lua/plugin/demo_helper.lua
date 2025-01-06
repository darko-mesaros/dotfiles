-- plugin/demo_helper.lua
local M = {}
local popup = require('plenary.popup')
local scan = require('plenary.scandir')

-- Configuration
M.config = {
    snippets_dir = vim.fn.stdpath('config') .. '/demo_snippets',
    typewriter_speed = 50, -- milliseconds between characters
    default_insert_mode = 'typewriter', -- 'instant' or 'typewriter'
}

-- Store active timer globally so we can cancel it
M.active_timer = nil
M.is_typing = false

-- Utility function to read file content
local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

-- Function to get all snippet files
local function get_snippets()
    local snippets = {}
    local files = scan.scan_dir(M.config.snippets_dir, { depth = 1, search_pattern = "%.%w+$" })
    for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t")
        snippets[#snippets + 1] = {
            name = name,
            path = file
        }
    end
    return snippets
end

-- Function to stop the typewriter effect
function M.stop_typewriter()
    if M.active_timer then
        M.active_timer:stop()
        M.active_timer:close()
        M.active_timer = nil
        M.is_typing = false
        vim.api.nvim_echo({{'Typewriter effect stopped', 'WarningMsg'}}, false, {})
    end
end

-- Create snippet selector window
function M.show_snippet_selector()
    local snippets = get_snippets()
    local width = 60
    local height = #snippets + 2
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    
    local bufnr = vim.api.nvim_create_buf(false, true)
    local win_id = popup.create(bufnr, {
        title = "Demo Snippets",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    -- Fill buffer with snippet names
    local lines = {}
    for i, snippet in ipairs(snippets) do
        lines[i] = string.format("%d. %s", i, snippet.name)
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- Set up keymaps
    local opts = { noremap = true, silent = true }
    -- Normal insert (instant)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', string.format(
        [[<cmd>lua require('plugin.demo_helper').insert_snippet(%d, 'instant')<CR>]], bufnr
    ), opts)
    -- Typewriter effect insert
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader><CR>', string.format(
        [[<cmd>lua require('plugin.demo_helper').insert_snippet(%d, 'typewriter')<CR>]], bufnr
    ), opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<cmd>q<CR>', opts)

    -- Store snippets data
    vim.b[bufnr].snippets = snippets
    
    -- Add a helpful message at the bottom of the popup
    local help_msg = {"", "Press <CR> for instant insert, <leader><CR> for typewriter effect"}
    vim.api.nvim_buf_set_lines(bufnr, height-2, height, false, help_msg)
end

-- Typewriter effect function
function M.typewriter_effect(text, callback)
    -- Stop any existing typewriter effect
    if M.is_typing then
        M.stop_typewriter()
    end

    local lines = vim.split(text, "\n")
    local current_line = 1
    local current_char = 1
    local pos = vim.api.nvim_win_get_cursor(0)
    local start_line = pos[1] - 1
    local win = vim.api.nvim_get_current_win()

    -- Insert all lines as empty strings first
    local empty_lines = {}
    for i = 1, #lines do
        empty_lines[i] = ""
    end
    vim.api.nvim_buf_set_lines(0, start_line, start_line, false, empty_lines)

    -- Set up interrupt mappings
    local function setup_interrupt_mappings()
        vim.keymap.set({'n', 'i', 'v'}, '<C-c>', M.stop_typewriter, { silent = true })
        vim.keymap.set({'n', 'i', 'v'}, '<Esc>', M.stop_typewriter, { silent = true })
    end

    local function cleanup_interrupt_mappings()
        vim.keymap.del({'n', 'i', 'v'}, '<C-c>')
        vim.keymap.del({'n', 'i', 'v'}, '<Esc>')
    end

    setup_interrupt_mappings()
    M.is_typing = true
    
    M.active_timer = vim.loop.new_timer()
    M.active_timer:start(0, M.config.typewriter_speed, vim.schedule_wrap(function()
        if not M.is_typing then
            cleanup_interrupt_mappings()
            if M.active_timer then
                M.active_timer:stop()
                M.active_timer:close()
                M.active_timer = nil
            end
            return
        end

        if current_line > #lines then
            M.is_typing = false
            cleanup_interrupt_mappings()
            M.active_timer:stop()
            M.active_timer:close()
            M.active_timer = nil
            if callback then callback() end
            return
        end

        local line = lines[current_line]
        if current_char > #line then
            current_line = current_line + 1
            current_char = 1
            -- Update cursor position to next line
            vim.api.nvim_win_set_cursor(win, {start_line + current_line, 0})
            -- Center the cursor line in the window
            vim.cmd('normal! zz')
            return
        end

        local partial_line = string.sub(line, 1, current_char)
        vim.api.nvim_buf_set_lines(0, start_line + current_line - 1, start_line + current_line, false, {partial_line})
        -- Update cursor position within the current line
        vim.api.nvim_win_set_cursor(win, {start_line + current_line, current_char - 1})
        current_char = current_char + 1
        
        -- Keep the cursor line centered
        vim.cmd('normal! zz')
    end))
end

-- Insert selected snippet
function M.insert_snippet(bufnr, mode)
    local snippets = vim.b[bufnr].snippets
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local selected = snippets[current_line]
    
    if selected then
        local content = read_file(selected.path)
        vim.cmd('q') -- Close popup
        
        if mode == 'typewriter' or (mode == nil and M.config.default_insert_mode == 'typewriter') then
            -- Use typewriter effect
            M.typewriter_effect(content)
        else
            -- Instant insert
            local pos = vim.api.nvim_win_get_cursor(0)
            local line = pos[1] - 1
            vim.api.nvim_buf_set_lines(0, line, line, false, vim.split(content, "\n"))
        end
    end
end

-- Setup function
function M.setup(opts)
    M.config = vim.tbl_extend('force', M.config, opts or {})
    
    -- Create snippets directory if it doesn't exist
    if not vim.fn.isdirectory(M.config.snippets_dir) then
        vim.fn.mkdir(M.config.snippets_dir, 'p')
    end

    -- Create default keymaps
    vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>lua require("plugin.demo_helper").show_snippet_selector()<CR>', 
        { noremap = true, silent = true, desc = "Show Demo Snippets" })
end

return M
