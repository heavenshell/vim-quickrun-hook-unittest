" File: php_unit.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Stagehand_TestRunner(PHP test runner I/F)'s selecting tests.
" Link: See http://piece-framework.com/projects/stagehand-testrunner/wiki
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#php_unit#run(session, context)
  let lineno = line('.')
  let line = getline('.')

  if line =~ '^\s*public\sfunction\|^\s*function*.'
    let defname = line
  else
    let pos = search('^\s*public\sfunction*.\|^\s*function*.', 'bwWn')
    let defname = getline(pos)
    if pos == 0
      return
    endif
  endif

  let method = substitute(defname, '^\s*public\sfunction\|^\s*function', '', '')
  let end    = strridx(method, '(')
  let method = strpart(method, 0, end)
  let filename = bufname('%')

  let cmdopt = a:session['config']['cmdopt'] . ' --test-method ' . method . ' ' . filename

  let a:session['config']['cmdopt'] = cmdopt
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

