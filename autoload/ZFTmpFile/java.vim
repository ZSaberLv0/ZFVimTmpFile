
function! ZFTmpFile#java#initAction(filePath)
    call setline(1, [
                \   '',
                \   'import java.text.SimpleDateFormat;',
                \   'import java.util.ArrayList;',
                \   'import java.util.Date;',
                \   'import java.util.HashMap;',
                \   'import java.util.List;',
                \   'import java.util.Map;',
                \   '',
                \   'public class Hello {',
                \   '',
                \   '    public static void main(String[] args) {',
                \   '        String curTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());',
                \   '        System.out.println(String.format("hello world: %s", curTime));',
                \   '    }',
                \   '',
                \   '}',
                \   '',
                \ ])
    update
    normal! 12j
endfunction

function! ZFTmpFile#java#saveAction(filePath)
    let tmp = ZFTmpFilePath() . '.java'
    call ZFTmpFile_cp(a:filePath, tmp)
    echo system('java "' . tmp . '"')
    call ZFTmpFile_rm(tmp)
endfunction

