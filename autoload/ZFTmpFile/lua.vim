
function! ZFTmpFile#lua#initAction(filePath)
    call setline(1, [
                \   '',
                \   "-- print(string.format('hello %s', 'world'))",
                \   '',
                \ ])
    update
    normal! G
endfunction

function! ZFTmpFile#lua#saveAction(filePath)
    echo system('lua "' . a:filePath . '"')
endfunction

