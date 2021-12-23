
function! ZFTmpFile#vim#saveAction(filePath)
    execute 'source ' . substitute(a:filePath, ' ', '\\ ', 'g')
endfunction

