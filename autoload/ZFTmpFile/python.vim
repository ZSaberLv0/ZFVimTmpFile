
function! ZFTmpFile#python#initAction(filePath)
    call setline(1, [
                \   "# -*- coding: utf-8",
                \   "",
                \ ])
    update
endfunction

function! ZFTmpFile#python#saveAction(filePath)
    if 0
    elseif executable('python3')
        let py = 'python3'
    elseif executable('py3')
        let py = 'py3'
    elseif executable('python')
        let py = 'python'
    elseif executable('py')
        let py = 'py'
    else
        return
    endif
    let path = fnamemodify(a:filePath, ':.')
    let result = system(py . ' "' . path . '"')
    echo result
endfunction

