
function! ZFTmpFile#ruby#initAction(filePath)
    call setline(1, [
                \   '',
                \   "puts format('hello %s', 'world')",
                \   '',
                \ ])
    update
    normal! G
endfunction

function! ZFTmpFile#ruby#saveAction(filePath)
    echo system(printf('ruby "%s"', a:filePath))
endfunction

