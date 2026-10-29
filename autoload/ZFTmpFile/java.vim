
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
                \   '        // System.out.println(String.format("hello world: %s", curTime));',
                \   '    }',
                \   '',
                \   '}',
                \   '',
                \ ])
    update
    normal! 12j
endfunction

function! ZFTmpFile#java#createAction(state)
    let a:state['filePath'] = a:state['filePath'] . '/Hello.java'
endfunction

function! ZFTmpFile#java#saveAction(filePath)
    echo system('java "' . a:filePath . '"')
endfunction

