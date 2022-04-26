temp file and autocmds for ease

# Usage

* create temp file and run when save

    ```
    :ZFTmpFile [filetype]
    ```

    `zs` to save and run the file, `q` to quit

* run current file

    ```
    :ZFTmpFileRunCurrent
    ```

    or enable for existing file

    ```
    :ZFTmpFileEnableCurrent
    ```


# Config

* `let g:ZFTmpFile_keymap_saveAndRun = 'zs'`
* `let g:ZFTmpFile_keymap_quit = 'q'`
* `let g:ZFTmpFile_storeResult = 't'`

    when set, store result in this register

* see [here](https://github.com/ZSaberLv0/ZFVimTmpFile/tree/master/autoload/ZFTmpFile) for supported `filetype`s


# Add your own type

to add your own `filetype`, supply these functions (all optional):

```
function! ZFTmpFile_YourFileType_convertFilePath(filePath)
    return YourConvertFilePath(a:filePath)
endfunction

function! ZFTmpFile_YourFileType_initAction(filePath)
    call YourInitAction(a:filePath)
endfunction

function! ZFTmpFile_YourFileType_saveAction(filePath)
    call YourSaveAction(a:filePath)
endfunction

function! ZFTmpFile_YourFileType_cleanupAction(filePath)
    call YourCleanupAction(a:filePath)
endfunction
```

or, supply autoload functions (`:h autoload`):

```
function! ZFTmpFile#YourFileType#convertFilePath(filePath)
    return YourConvertFilePath(a:filePath)
endfunction

function! ZFTmpFile#YourFileType#initAction(filePath)
    call YourInitAction(a:filePath)
endfunction

function! ZFTmpFile#YourFileType#saveAction(filePath)
    call YourSaveAction(a:filePath)
endfunction

function! ZFTmpFile#YourFileType#cleanupAction(filePath)
    call YourCleanupAction(a:filePath)
endfunction
```

note, if `filetype` contains chars other than `[a-z0-9_]`,
it's replaced to `_`

