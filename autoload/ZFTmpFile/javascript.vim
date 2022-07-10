
function! ZFTmpFile#javascript#initAction(filePath)
    call setline(1, [
                \   '// ============================================================',
                \   '// require: npm install -g jsdom jquery',
                \   'try {',
                \   '    const JSDOM = require("jsdom").JSDOM;',
                \   '    const _html = `',
                \   '    <!DOCTYPE html>',
                \   '    <html>',
                \   '        <head>',
                \   '            <meta charset="UTF-8" />',
                \   '        </head>',
                \   '        <body/>',
                \   '    </html>',
                \   '    `;',
                \   '    const window = new JSDOM(_html).window;',
                \   '    global.window = window;',
                \   '    const document = window.document;',
                \   '    global.document = document;',
                \   '} catch(err) {}',
                \   'try {',
                \   '    $ = global.jQuery = require("jquery")',
                \   '} catch(err) {}',
                \   '// ============================================================',
                \   '',
                \   'console.log($.fn.jquery);',
                \   '',
                \ ])
    update
    normal! G
endfunction

function! ZFTmpFile#javascript#saveAction(filePath)
    let nodePath = substitute(system('npm root -g'), '[\r\n]', '', 'g')
    if !empty(nodePath) && isdirectory(nodePath)
        if has('windows') && !has('unix')
            let cmd = 'SET NODE_PATH="' . nodePath . '" && '
        else
            let cmd = 'NODE_PATH="' . nodePath . '" '
        endif
    else
        let cmd = ''
    endif

    echo system(cmd . 'node "' . a:filePath . '"')
endfunction

