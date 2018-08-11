" File: python_unit.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Python unittesting runner Django selecting tests.
" Link: See http://docs.djangoproject.jp/en/latest/topics/testing.html#running-tests
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

let s:current = ''

function! quickrunex#unittest#python_django#run(session, context)
  let file = s:get_manage_py()
  let root = fnamemodify(file, ':p:h')
  let base = root

  if exists('+autochdir') && &autochdir
    let s:current = getcwd()
    set noautochdir
    execute ':lcd ' . base
  endif

  let filepath = expand('%:p')
  let line = s:get_signeture()
  let test_fw = get(a:session['config'], 'test_fw', 'unittest')
  let delimiter = '.'

  if test_fw == 'pytest'
    let delimiter = '::'
  else
    let root = substitute(root, '\/', '\.', '')
    " Extract `${package_name}.${class_name}.${method_name}`.
    let filepath = substitute(filepath, '\/', '\.', '')
    let filepath = substitute(filepath, root, '', 'g')
    let filepath = substitute(filepath, '\/', '\.', 'g')
    let filepath = substitute(filepath, '\.', '', '1')
    let filepath = fnamemodify(filepath, ':t:r')
  endif

  if s:is_test_class(line)
    let classname = s:pick_classname(line)
    let cmdopt    = printf('%s%s%s', filepath, delimiter, classname)
  elseif s:is_test_func(line)
    let defname = s:pick_defname(line)
    let cmdopt  = printf('%s%s%s', filepath, delimiter, defname)
  elseif s:is_test_method(line)
    let defname   = s:pick_defname(line)
    let classname = s:search_classname()
    let cmdopt    = printf('%s%s%s%s%s', filepath, delimiter, classname, delimiter, defname)
  elseif s:is_method(line) " not test method.
    let classname = s:search_classname()
    let cmdopt = printf('%s%s%s', filepath, delimiter, classname)
  else "not test function or class. all test.
    let cmdopt = filepath
  endif

  let a:session['config']['cmdopt'] = printf('%s %s', a:session['config']['cmdopt'], cmdopt)
  let a:session['config']['command'] = file
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

function! quickrunex#unittest#python_django#finish()
  set autochdir
  execute ':cd ' . s:current
endfunction

function! s:get_manage_py()
  let file = findfile('manage.py', expand('%:p') . ';')
  return file
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
