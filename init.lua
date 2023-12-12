vim.cmd [[set packpath+=/home/ms/ishipitc/.local/share/nvim/site]]

local old_os = os.getenv
os.getenv = function(arg)
    if arg == 'HOME' then
        return '/home/ms/ishipitc'
    end
    return old_os(arg)
end

require("iasai1")
