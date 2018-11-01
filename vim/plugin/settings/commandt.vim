" Use escape to cancel search window.
"if &term =~ "xterm" || &term =~ "screen"
"    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
"endif

let g:CommandTWildIgnore = &wildignore . ",moc_*.cpp"
let g:CommandTTraverseSCM = "pwd"
