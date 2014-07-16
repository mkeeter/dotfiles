" Show bookmarks by default
let NERDTreeShowBookmarks=1

" Change pane width to 40 characters
let g:NERDTreeWinSize = 40

" Close if NERDtree is the only window remaining
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
