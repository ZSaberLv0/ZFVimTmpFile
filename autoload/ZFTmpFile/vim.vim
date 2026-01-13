
function! ZFTmpFile#vim#initAction(filePath)
    call setline(1, [
                \   '',
                \   "\" echo printf('hello world')",
                \   '',
                \ ])
    update
    normal! G
endfunction

function! ZFTmpFile#vim#saveAction(filePath)
    execute 'source ' . substitute(a:filePath, ' ', '\\ ', 'g')
endfunction

