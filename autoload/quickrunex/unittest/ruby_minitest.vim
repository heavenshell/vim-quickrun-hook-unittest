" File: ruby_minitest.vim
" Author: BimbaLaszlo <bimbalaszlo@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Ruby minitest testing tool unit test's selecting tests.
" Link: See https://github.com/seattlerb/minitest
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#ruby_minitest#run(session, context)
  let lineno = line('.')
  let line = getline('.')

  if line =~ '^\s*def\stest_*.'
    let defname = line
  else
    let pos = search('^\s*def\stest_*.', 'bwWn')
    let defname = getline(pos)
    if pos == 0
      return
    endif
  endif

  let defname = substitute(defname, '(.*$', '', '')
  let defname = substitute(defname, '^\s*def\s\|^def\s', '', '')

  let a:session['config']['args'] = ' --name ' . defname
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
