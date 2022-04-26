
if !exists('g:ZFTmpFile_keymap_saveAndRun')
    let g:ZFTmpFile_keymap_saveAndRun = 'zs'
endif
if !exists('g:ZFTmpFile_keymap_quit')
    let g:ZFTmpFile_keymap_quit = 'q'
endif
if !exists('g:ZFTmpFile_storeResult')
    let g:ZFTmpFile_storeResult = 't'
endif

function! CygpathFix_absPath(path)
    if len(a:path) <= 0|return ''|endif
    if !exists('g:CygpathFix_isCygwin')
        let g:CygpathFix_isCygwin = has('win32unix') && executable('cygpath')
    endif
    let path = fnamemodify(a:path, ':p')
    if !empty(path) && g:CygpathFix_isCygwin
        if 0 " cygpath is really slow
            let path = substitute(system('cygpath -m "' . path . '"'), '[\r\n]', '', 'g')
        else
            if match(path, '^/cygdrive/') >= 0
                let path = toupper(strpart(path, len('/cygdrive/'), 1)) . ':' . strpart(path, len('/cygdrive/') + 1)
            else
                if !exists('g:CygpathFix_cygwinPrefix')
                    let g:CygpathFix_cygwinPrefix = substitute(system('cygpath -m /'), '[\r\n]', '', 'g')
                endif
                let path = g:CygpathFix_cygwinPrefix . path
            endif
        endif
    endif
    return substitute(substitute(path, '\\', '/', 'g'), '\%(\/\)\@<!\/\+$', '', '') " (?<!\/)\/+$
endfunction

function! ZFTmpFilePath(...)
    let filePath = tempname()
    let ft = get(a:, 1, '')
    if !empty(ft)
        let filePath = ZFTmpFile_convertFilePath(filePath, ft)
    endif
    return CygpathFix_absPath(filePath)
endfunction

function! ZFTmpFile_cp(from, to)
    if has('win32') || has('win64')
        call system('copy /y "' . substitute(a:from, '/', '\', 'g') . '" "' . substitute(a:to, '/', '\', 'g') . '" >nul 2>&1')
    else
        call system('yes | cp "' . a:from . '" "' . a:to . '" >/dev/null 2>&1')
    endif
endfunction

function! ZFTmpFile_rm(f)
    if has('win32') || has('win64')
        call system('rmdir /s/q "' . substitute(a:f, '/', '\', 'g') . '"')
    else
        call system('rm -rf "' . a:f . '"')
    endif
endfunction

function! ZFTmpFile(...)
    let ft = get(a:, 1, '')
    execute 'edit ' . ZFTmpFilePath(ft)
    if !empty(ft)
        let &filetype = ft
    endif
    doautocmd User ZFTmpFileInit
    doautocmd User ZFTmpFileInitFinish
    autocmd BufDelete <buffer> call ZF_TmpFile_cleanup()
endfunction
command! -nargs=? -complete=filetype ZFTmpFile :call ZFTmpFile(<f-args>)
command! -nargs=0 ZFTmpFileRunCurrent :call ZFTmpFile_saveAction()
command! -nargs=0 ZFTmpFileEnableCurrent :call s:setupForCurrent()

let s:dataPath = CygpathFix_absPath(expand('<sfile>:p:h:h') . '/autoload/ZFTmpFile')
function! ZFTmpFileSetup(ft)
    if empty(a:ft)
        echo 'you must specify filetype'
        return
    endif
    let ft = s:ftEscape(a:ft)
    let path = s:dataPath . '/' . ft . '.vim'
    execute 'edit ' . path
    if !filereadable(path)
        call setline(1, [
                    \   '',
                    \   '" call ZFTmpFileAlias("existFt", "' . a:ft . '")',
                    \   '',
                    \   'function! ZFTmpFile#' . ft . '#convertFilePath(filePath)',
                    \   '    return a:filePath',
                    \   'endfunction',
                    \   '',
                    \   'function! ZFTmpFile#' . ft . '#initAction(filePath)',
                    \   'endfunction',
                    \   '',
                    \   'function! ZFTmpFile#' . ft . '#saveAction(filePath)',
                    \   'endfunction',
                    \   '',
                    \   'function! ZFTmpFile#' . ft . '#cleanupAction(filePath)',
                    \   'endfunction',
                    \   '',
                    \ ])
    endif
endfunction
command! -nargs=1 -complete=filetype ZFTmpFileSetup :call ZFTmpFileSetup(<q-args>)

function! ZFTmpFileAlias(existFt, aliasFt)
    let aliasFt = s:ftEscape(a:aliasFt)
    execute join([
                \   'function! ZFTmpFile_' . aliasFt . '_convertFilePath(filePath)',
                \   '    return ZFTmpFile_convertFilePath(a:filePath, "' . a:existFt . '")',
                \   'endfunction',
                \ ], "\n")
    execute join([
                \   'function! ZFTmpFile_' . aliasFt . '_initAction(filePath)',
                \   '    call ZFTmpFile_initAction("' . a:existFt . '")',
                \   'endfunction',
                \ ], "\n")
    execute join([
                \   'function! ZFTmpFile_' . aliasFt . '_saveAction(filePath)',
                \   '    call ZFTmpFile_saveAction("' . a:existFt . '")',
                \   'endfunction',
                \ ], "\n")
    execute join([
                \   'function! ZFTmpFile_' . aliasFt . '_cleanupAction(filePath)',
                \   '    call ZFTmpFile_cleanupAction("' . a:existFt . '")',
                \   'endfunction',
                \ ], "\n")
endfunction

augroup ZF_TmpFile_augroup
    autocmd!
    autocmd User ZFTmpFileInit call s:setup()
    autocmd User ZFTmpFileInitFinish silent
    autocmd User ZFTmpFileCleanup silent
augroup END

function! s:setup()
    if !empty(get(g:, 'ZFTmpFile_keymap_saveAndRun', ''))
        execute 'nnoremap <buffer><silent> ' . g:ZFTmpFile_keymap_saveAndRun . ' :call ZFTmpFile_saveAndRun()<cr>'
    endif
    if !empty(get(g:, 'ZFTmpFile_keymap_quit', ''))
        execute 'nnoremap <buffer><silent> ' . g:ZFTmpFile_keymap_quit . ' :bd!<cr>'
    endif
    call ZFTmpFile_initAction()
endfunction

function! s:setupForCurrent()
    if !empty(get(g:, 'ZFTmpFile_keymap_saveAndRun', ''))
        execute 'nnoremap <buffer><silent> ' . g:ZFTmpFile_keymap_saveAndRun . ' :call ZFTmpFile_saveAndRun()<cr>'
    endif
endfunction

function! ZF_TmpFile_cleanup()
    let file = CygpathFix_absPath(expand('<afile>'))
    if filereadable(file)
        call ZFTmpFile_cleanupAction()
        doautocmd User ZFTmpFileCleanup
        if filereadable(file)
            call delete(file)
        endif
    endif
endfunction

function! s:ftEscape(ft)
    return substitute(a:ft, '[^a-z0-9_]', '_', 'g')
endfunction

function! s:autoloadFuncExist(ftEscape, fnName)
    if exists('*' . a:fnName)
        return 1
    endif
    if !exists('s:autoloadFuncChecked')
        let s:autoloadFuncChecked = {}
    endif
    if !exists('s:autoloadFuncChecked[a:ftEscape]')
        let s:autoloadFuncChecked[a:ftEscape] = 1
        let files = split(globpath(&rtp, 'autoload/ZFTmpFile/' . a:ftEscape . '.vim'), "\n")
        for file in files
            execute 'source ' . fnameescape(file)
        endfor
    endif
    return exists('*' . a:fnName)
endfunction

function! s:prepareImplFunc(action, ...)
    let ret = []
    let ft = get(a:, 1, '')
    if empty(ft)
        let ft = &filetype
    endif
    let ftEscape = s:ftEscape(ft)
    if empty(ftEscape)
        return ret
    endif

    let fnName = 'ZFTmpFile#' . ftEscape . '#' . a:action
    if s:autoloadFuncExist(ftEscape, fnName)
        call add(ret, function(fnName))
    endif

    let fnName = 'ZFTmpFile_' . ftEscape . '_' . a:action
    if exists('*' . fnName)
        call add(ret, function(fnName))
    endif

    return ret
endfunction

function! ZFTmpFile_convertFilePath(filePath, ...)
    let filePath = a:filePath
    for Fn in s:prepareImplFunc('convertFilePath', get(a:, 1, ''))
        let tmp = Fn(filePath)
        if !empty(tmp)
            let filePath = tmp
        endif
    endfor
    return filePath
endfunction

function! ZFTmpFile_initAction(...)
    let filePath = CygpathFix_absPath(expand('%'))
    for Fn in s:prepareImplFunc('initAction', get(a:, 1, ''))
        call Fn(filePath)
    endfor
endfunction

function! ZFTmpFile_saveAction()
    let moreSaved = &more
    set nomore
    try
        call s:ZFTmpFile_saveAction()
    catch
    endtry
    let &more = moreSaved
endfunction

function! s:ZFTmpFile_saveAction(...)
    let Fns = s:prepareImplFunc('saveAction', get(a:, 1, ''))
    if empty(Fns)
        return
    endif

    let filePath = CygpathFix_absPath(expand('%'))
    let ft = &filetype

    redraw!
    echo '[ZFTmpFile] run as ' . ft

    let result = ''
    if exists('*execute')
        try
            let result = execute('for Fn in Fns | call Fn(filePath) | endfor', '')
        catch
            let result = v:exception
        endtry
    else
        try
            redir => result
            for Fn in Fns
                call Fn(filePath)
            endfor
        finally
            redir END
        endtry
    endif

    redraw!
    echo '[ZFTmpFile] run as ' . ft . ' finished'
    let result = substitute(result, '^[\r\n]\+', '', 'g')
    let result = substitute(result, '[\r\n]\+$', '', 'g')
    if !empty(result)
        echo result
    endif

    if g:ZFTmpFile_storeResult != ''
        execute 'let @' . g:ZFTmpFile_storeResult . ' = result'
    endif
endfunction

function! ZFTmpFile_cleanupAction(...)
    let filePath = CygpathFix_absPath(expand('%'))
    for Fn in s:prepareImplFunc('cleanupAction', get(a:, 1, ''))
        call Fn(filePath)
    endfor
endfunction

function! ZFTmpFile_saveAndRun()
    " https://github.com/neoclide/coc.nvim/issues/1977
    let b:coc_diagnostic_disable = 1

    write
    call ZFTmpFile_saveAction()

    try
        unlet b:coc_diagnostic_disable
    catch
    endtry
endfunction

