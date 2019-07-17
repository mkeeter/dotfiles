nmap <leader>a :GrepperRg 

let g:grepper       = {}
let g:grepper.tools = ['rg']

autocmd BufWinEnter quickfix nnoremap <silent> <buffer> q :cclose<cr>:lclose<cr>
