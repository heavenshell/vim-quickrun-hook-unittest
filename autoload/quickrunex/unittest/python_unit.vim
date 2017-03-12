" File: python_unit.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Python unittesting runner nose's selecting tests.
" Link: See http://nose.readthedocs.org/en/latest/usage.html#selecting-tests
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#python_unit#run(session, context)
  let filepath = expand('%:p')
  let line = s:get_signeture()

  if s:is_test_class(line)
    let classname = s:pick_classname(line)
    let cmdopt    = printf('%s:%s', filepath, classname)
  elseif s:is_test_func(line)
    let defname = s:pick_defname(line)
    let cmdopt  = printf('%s:%s', filepath, defname)
  elseif s:is_test_method(line)
    let defname   = s:pick_defname(line)
    let classname = s:search_classname()
    let cmdopt    = printf('%s:%s.%s', filepath, classname, defname)
  elseif s:is_method(line) " not test method.
    let classname = s:search_classname()
    let cmdopt = printf('%s:%s', filepath, classname)
  else "not test function or class. all test.
    let cmdopt = filepath
  endif
  let a:session['config']['cmdopt'] = printf('%s %s', a:session['config']['cmdopt'], cmdopt)
  let a:session['config']['exec'] = ['%c %o']
endfunction

function! s:get_signeture()
  let line = getline('.')

  if line !~# '^\s*def\s\|^class\s'
    if line =~# '\s*@'
      let pos = search('^\s*def\s\|^class\s', 'Wn')
      let line = getline(pos)
    else
      let pos = search('^\s*def\s\|^class\s', 'bWn')
      let line = getline(pos)
    endif
  endif
  return line
endfunction

function! s:is_test_class(line)
  return a:line =~# '^class\s\+\S*[Tt]est.*'
endfunction

function! s:is_test_func(line)
  return a:line =~# '^def\s\+\(\S*[^[:alnum:]-.]\)\?[Tt]est.*'
endfunction

function! s:is_test_method(line)
  return a:line =~# '^\s\+def\s\+\(\S*[^[:alnum:]-.]\)\?[Tt]est.*'
endfunction

function! s:is_method(line)
  return a:line =~# '^\s\+def\s'
endfunction

function! s:search_classname()
  let classpos = search('^class\s', 'bWn')
  let classname = getline(classpos)
  let classname = s:pick_classname(classname)
  return classname
endfunction

function! s:pick_classname(string)
  let classname = substitute(a:string, '(.*$', '', '')
  let classname = substitute(classname, '^class\s\+', '', '')
  return classname
endfunction

function! s:pick_defname(string)
  let defname = substitute(a:string, '(.*$', '', '')
  let defname = substitute(defname, '^\s*def\s\+', '', '')
  return defname
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

