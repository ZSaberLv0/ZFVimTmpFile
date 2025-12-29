
function! ZFTmpFile#ruby#saveAction(filePath)
    echo system(printf('ruby "%s"', a:filePath))
endfunction

