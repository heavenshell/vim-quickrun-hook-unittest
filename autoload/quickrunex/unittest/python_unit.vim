" File: python_unittest.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Python unittesting runner nose's selecting tests.
" Link: See http://nose.readthedocs.org/en/latest/usage.html#selecting-tests
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#python_unit#run(session, context)
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
  let classpos = search('^class\sTest*.', 'bwWn')
  let classname = getline(classpos)
  let classname = substitute(classname, '(.*$', '', '')
  let classname = substitute(classname, '^class\s', '', '')
  let filepath = expand('%:p')
  let cmdopt = printf('%s:%s.%s', filepath, classname, defname)

  let a:session['config']['exec'] = '%c %o' . ' ' . cmdopt
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

