
function! ZFTmpFile#lua#saveAction(filePath)
    echo system('lua "' . a:filePath . '"')
endfunction

