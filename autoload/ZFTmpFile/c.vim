
function! ZFTmpFile#c#initAction(filePath)
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

function! ZFTmpFile#c#saveAction(filePath)
    let o = ZFTmpFilePath()
    let cmd = 'gcc'
    let cmd .= ' -x c'
    let compile = system(cmd . ' "' . a:filePath . '" -o "' . o . '"')
    let result = system('"' . o . '"')
    call delete(o)
    echo compile
    echo result
endfunction

