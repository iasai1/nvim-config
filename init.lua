local HOME = os.getenv('LOCALAPPDATA')
vim.cmd('set packpath+=' .. HOME .. '/nvim-data/site')

require("iasai1")
