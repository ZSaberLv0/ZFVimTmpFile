
function! ZFTmpFile#dosbatch#initAction(filePath)
    call setline(1, [
                \   '@echo off',
                \   'setlocal',
                \   'setlocal enabledelayedexpansion',
                \   'set WORK_DIR=%~dp0',
                \   '',
                \   'set v=world',
                \   'rem echo "hello %v%"',
                \   '',
                \ ])
    setlocal fileformat=dos
    update
    normal! G
endfunction

function! ZFTmpFile#dosbatch#saveAction(filePath)
    let path = substitute(fnamemodify(a:filePath, ':.'), '/', '\\', 'g')
    let pathTmp = path . '.ZFTmpFile_dosbatch.bat'
    let cmd = 'copy /y "' . path . '" "' . pathTmp . '" >nul 2>&1'
    let cmd .= ' && "' . pathTmp . '"'
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

