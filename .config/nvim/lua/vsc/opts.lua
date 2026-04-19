local o = vim.opt

o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
o.swapfile = false
o.ignorecase = true
o.smartcase = true
o.smartindent = true
o.expandtab = true -- use spaces instead of a real tab character (\t).
o.shiftround = true
o.shiftwidth = 2 -- number of spaces to use for each level of indentation when autoindenting or using >> / <<.
o.softtabstop = 2 -- how many spaces <Tab> or <BS> counts for while typing/deleting.
o.tabstop = 2 -- how many spaces a literal <Tab> character *displays as* when the file actually has a "\t" char inside.
o.linebreak = true -- Wrap lines at convenient points
