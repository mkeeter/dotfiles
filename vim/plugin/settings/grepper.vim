nmap <leader>a :GrepperRg 
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)

let g:grepper       = {}
let g:grepper.tools = ['rg']

autocmd BufWinEnter quickfix nnoremap <silent> <buffer> q :cclose<cr>:lclose<cr>
