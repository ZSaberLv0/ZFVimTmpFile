
function! ZFTmpFile#cpp#initAction(filePath)
    call setline(1, [
                \   "#include <stdio.h>",
                \   "",
                \   "int main(int argc, char **argv)",
                \   "{",
                \   "    printf(\"hello world\\n\");",
                \   "    return 0;",
                \   "}",
                \   "",
                \ ])
    update
endfunction

function! ZFTmpFile#cpp#saveAction(filePath)
    let o = ZFTmpFilePath()
    let cmd = 'g++'
    if get(g:, 'ZFTmpFile_cpp_cpp11', 1)
        let cmd .= ' -std=c++11'
    endif
    let cmd .= ' -x c++'
    let compile = system(cmd . ' "' . a:filePath . '" -o "' . o . '"')
    let result = system('"' . o . '"')
    call delete(o)
    echo compile
    echo result
endfunction

