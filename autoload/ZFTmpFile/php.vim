
function! ZFTmpFile#php#initAction(filePath)
    call setline(1, [
                \   '<?php',
                \   'function test() {',
                \   '    print_r("hello world");',
                \   '}',
                \   'test()',
                \   '?>',
                \ ])
    update
    normal! 2j
endfunction

function! ZFTmpFile#php#saveAction(filePath)
    echo system('php "' . a:filePath . '"')
endfunction

