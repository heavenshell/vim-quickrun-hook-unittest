" File: go_test.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Golang selecting tests.
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#go_test#run(session, context)
  let line = s:get_signeture()
  let funcname = s:pick_funcname(line)

  let cmdopt = a:session['config']['cmdopt'] . ' -run=' . funcname
  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

function! s:get_signeture()
  let pos = search('^func\sTest*', 'bWn')
  let line = getline(pos)
  return line
endfunction

function! s:pick_funcname(string)
  let funcname = substitute(a:string, '(.*$', '', '')
  let funcname = substitute(funcname, '^func\s\+', '', '')
  return funcname
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
