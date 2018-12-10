if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
