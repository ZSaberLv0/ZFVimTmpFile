
function! ZFTmpFile#php#initAction(filePath)
    call setline(1, [
                \   '<?php',
                \   'function test() {',
                \   '}',
                \   'test()',
                \   '?>',
                \ ])
    update
endfunction

function! ZFTmpFile#php#saveAction(filePath)
    echo system('php "' . a:filePath . '"')
endfunction

