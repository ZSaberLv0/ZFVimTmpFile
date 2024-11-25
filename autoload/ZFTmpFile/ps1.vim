
function! ZFTmpFile#ps1#saveAction(filePath)
    let path = substitute(fnamemodify(a:filePath, ':.'), '/', '\\', 'g')
    let pathTmp = path . '.ZFTmpFile_powershell.ps1'
    let cmd = 'copy /y "' . path . '" "' . pathTmp . '" >nul 2>&1'
    let cmd .= ' && Powershell.exe -executionpolicy remotesigned -File "' . pathTmp . '"'
    let result = ''
    try
        let result = system(cmd)
    endtry
    call ZFTmpFile_rm(substitute(pathTmp, '\\', '/', 'g'))
    if empty(result)
        return
    endif
    echo ZFTmpFile_fixEncoding(result)
endfunction

