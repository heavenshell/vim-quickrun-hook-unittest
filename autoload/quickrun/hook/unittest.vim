" File: unittest.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: QuickRun hook script for unittest
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

let s:hook = {}

function! quickrun#hook#unittest#new()
  return deepcopy(s:hook)
endfunction

function! s:hook.on_module_loaded(session, context)
  if !has_key(a:session['config'], 'hook/unittest/enable')
    return
  endif
  if a:session['config']['hook/unittest/enable'] != 1
    return
  endif

  try
    let name = substitute(&filetype, '\.', '_', 'g')
    call quickrunex#unittest#{name}#run(a:session, a:context)
  catch
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
