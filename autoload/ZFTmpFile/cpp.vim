
function! ZFTmpFile#cpp#initAction(filePath)
    call setline(1, [
                \   "#include <stdio.h>",
                \   "#include <string>",
                \   "#include <vector>",
                \   "#include <map>",
                \   "using namespace std;",
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
    if empty(get(g:, 'ZFTmpFile_cpp_standard', ''))
        let cmd .= ' -std=c++11'
    else
        let cmd .= ' -std=' . get(g:, 'ZFTmpFile_cpp_standard', '')
    endif
    let cmd .= ' ' . get(g:, 'ZFTmpFile_cpp_flags', '')
    let cmd .= ' -x c++'
    let compile = system(cmd . ' "' . a:filePath . '" -o "' . o . '"')
    let result = system('"' . o . '"')
    call delete(o)
    echo compile
    echo result
endfunction

