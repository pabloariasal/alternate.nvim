local M = {}

local function search(file_name, extension)
    local search_pattern = string.format("**/%s%s", file_name, extension)
    local line_iterator = string.gmatch(vim.fn.glob(search_pattern), "([^\n]*)\n?")
    return line_iterator()
end

local function search_first(file_name, extensions)
    for _,e in ipairs(extensions) do
        s = search(file_name, e)
        if s then
            return s
        end
    end
    return nil
end

M.alternate = function()
    local curr_buffer = vim.api.nvim_buf_get_name(0)
    local file_name = curr_buffer:match("^.+/(.+)%..+$")
    local extension = curr_buffer:match("^.+(%..+)$")
    local alternate_file

    if extension == '.c' or extension == '.cpp' or extansion == '.cc' then
        alternate_file = search_first(file_name, {'.h', '.hpp'})
    elseif extension == '.h' then
        alternate_file = search_first(file_name, {'.cpp', '.cc', '.c', '.hpp'})
    elseif extension == '.hpp' then
        alternate_file = search_first(file_name, {'.cpp', '.cc', '.c', '.h'})
    end

    if alternate_file == nil then
        vim.notify('Alternate file not found')
        return
    end

    vim.cmd('e ' .. alternate_file)
end

return M
