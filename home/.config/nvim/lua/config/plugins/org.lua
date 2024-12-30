local org_path = function(path)
    local org_directory = '~/Library/Mobile Documents/com~apple~CloudDocs/orgfiles'
    return ('%s/%s'):format(org_directory, path)
end

return {
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        dependencies = {
            { 'nvim-orgmode/org-bullets.nvim' },
        },
        keys = {
            { '<leader>oa', '<Cmd>lua require("orgmode").action("agenda.prompt")<CR>' },
            { '<leader>n',  '<Cmd>lua require("orgmode").action("capture.prompt")<CR>' },
        },
        config = function()
            require('orgmode').setup({
                org_agenda_files = org_path('**/*'),
                org_default_notes_file = org_path('refile.org'),
                org_hide_emphasis_markers = true,
                org_agenda_text_search_extra_files = { 'agenda-archives' },
                org_agenda_start_on_weekday = false,
                org_startup_indented = true,
                org_log_into_drawer = 'LOGBOOK',
                org_todo_keywords = { 'TODO(t)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)' },
                org_capture_templates = {
                    j = {
                        description = 'Journal',
                        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                        target = org_path('journal.org'),
                    },
                    t = {
                        description = 'Refile',
                        template = '* TODO %?\nDEADLINE: %T',
                    },
                    T = {
                        description = 'Todo',
                        template = '* TODO %?\nDEADLINE: %T',
                        target = org_path('todos.org'),
                    },
                    w = {
                        description = 'Work todo',
                        template = '* TODO %?\nDEADLINE: %T',
                        target = org_path('work.org'),
                    },
                },
            })
        end,
    }
}
