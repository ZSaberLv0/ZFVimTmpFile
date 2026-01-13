
function! ZFTmpFile#go#initAction(filePath)
    call setline(1, [
                \   'package main',
                \   'import "fmt"',
                \   '',
                \   'func main() {',
                \   '    // fmt.Printf("hello %s\n", "world")',
                \   '}',
                \   '',
                \ ])
    update
    normal! 4j
endfunction

function! ZFTmpFile#go#saveAction(filePath)
    let path = fnamemodify(a:filePath, ':.')
    let pathTmp = path . '.go'
    silent! noautocmd call writefile(readfile(path, 'b'), pathTmp, 'b')
    let result = system('go run "' . pathTmp . '"')
    call ZFTmpFile_rm(pathTmp)
    echo result
endfunction

