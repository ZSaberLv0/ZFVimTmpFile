
function! ZFTmpFile#rust#initAction(filePath)
    call setline(1, [
                \   "",
                \   "fn main() {",
                \   "    println!(\"hello world\");",
                \   "}",
                \   "",
                \ ])
    update
endfunction

function! ZFTmpFile#rust#saveAction(filePath)
    let compileResult = system(printf('rustc "%s" -o "%s"', a:filePath, a:filePath . '.tmp'))
    let compileSuccess = v:shell_error
    if !empty(compileResult)
        echo compileResult
    endif
    if compileSuccess == 0
        let runResult = system(printf('"%s"', a:filePath . '.tmp'))
        if !empty(runResult)
            echo runResult
        endif
    endif
    silent! call delete(a:filePath . '.tmp')
endfunction

function! ZFTmpFile#rust#cleanupAction(filePath)
    silent! call delete(a:filePath . '.tmp')
endfunction

