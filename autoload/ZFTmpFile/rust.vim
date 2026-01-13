
function! ZFTmpFile#rust#initAction(filePath)
    call setline(1, [
                \   '',
                \   'fn main() {',
                \   '    // println!("hello world");',
                \   '}',
                \   '',
                \ ])
    update
    normal! 2j
endfunction

function! ZFTmpFile#rust#saveAction(filePath)
    let tmpFile = ZFTmpFilePath()
    let compileResult = system(printf('rustc "%s" -o "%s"', a:filePath, tmpFile))
    let compileSuccess = v:shell_error
    if !empty(compileResult)
        echo compileResult
    endif
    if compileSuccess == 0
        let runResult = system(printf('"%s"', tmpFile))
        if !empty(runResult)
            echo runResult
        endif
    endif
    call ZFTmpFile_rm(tmpFile)
endfunction

