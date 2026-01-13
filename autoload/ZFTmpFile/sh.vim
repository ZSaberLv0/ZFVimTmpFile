
function! ZFTmpFile#sh#initAction(filePath)
    call setline(1, [
                \   'WORK_DIR=$(cd "$(dirname "$0")"; pwd)',
                \   '',
                \   '# echo "hello world"',
                \   '',
                \ ])
    update
    normal! G
endfunction

function! ZFTmpFile#sh#saveAction(filePath)
    let path = fnamemodify(a:filePath, ':.')
    let result = system('sh "' . path . '"')
    echo result
endfunction

