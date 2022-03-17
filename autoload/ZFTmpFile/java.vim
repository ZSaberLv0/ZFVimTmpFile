
function! ZFTmpFile#java#initAction(filePath)
    call setline(1, [
                \   '',
                \   'public class Hello {',
                \   '    public static void main(String[] args) {',
                \   '        System.out.println("hello world");',
                \   '    }',
                \   '}',
                \   '',
                \ ])
    update
endfunction

function! ZFTmpFile#java#saveAction(filePath)
    let tmp = ZFTmpFilePath() . '.java'
    call ZFTmpFile_cp(a:filePath, tmp)
    echo system('java "' . tmp . '"')
    call ZFTmpFile_rm(tmp)
endfunction

