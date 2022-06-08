
if exists('*ZF_ModuleInstaller')
    function! ZF_TmpFile_install_javascript()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'jsdom jquery')
    endfunction
    call ZF_ModuleInstaller('ZF_TmpFile_install_javascript', 'call ZF_TmpFile_install_javascript()')
endif

