require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = ''
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,
        shorting_target = 40,
        symbols = {
          modified = '[+]',
          readonly = '[-]',
          unnamed = '[No Name]',
        }
      },
      {
        function()
          if vim.wo.diff then
            local branch_name = vim.fn.FugitiveHead()
            -- Read the first few lines of the buffer to check for the specific strings
            local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(vim.api.nvim_buf_line_count(0), 10), false)
            for _, line in ipairs(lines) do
              if line:find('//2') then
                return 'at target branch'
              elseif line:find('//3') then
                return 'at merge branch'
              end
            end
            if branch_name ~= '' then
              return 'at ' .. branch_name
            else
              return 'Diff mode'
            end
          else
            return ''
          end
        end,
        cond = function()
          return vim.wo.diff
        end,
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

