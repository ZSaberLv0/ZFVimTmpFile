
function! ZFTmpFile#dosbatch#initAction(filePath)
    call setline(1, [
                \   '@echo off',
                \   'setlocal',
                \   'setlocal enabledelayedexpansion',
                \   'set WORK_DIR=%~dp0',
                \   '',
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

    " fix encoding
    let encoding = s:getEncoding()
    if !empty(encoding) && exists('*iconv')
        let result = iconv(result, encoding, &encoding)
    endif

    echo result
endfunction

function! s:getEncoding()
    if !exists('s:WindowsCodePage')
        let cp = system("@echo off && for /f \"tokens=2* delims=: \" %a in ('chcp') do (echo %a)")
        let cp = 'cp' . substitute(cp, '[\r\n]', '', 'g')
        let s:WindowsCodePage = cp
    endif
    return s:WindowsCodePage
endfunction

