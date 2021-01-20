" File: typescript_jest.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Jest selecting tests.
" Link: See http://facebook.github.io/jest/docs/en/cli.html#testpathpattern-regex
" License: zlib License
let s:save_cpo = &cpo
set cpo&vim

let s:bin = ''
let s:current_path = ''
let s:src_path = ''
let s:opt_file_relative_flag = 0

function! s:get_signeture()
  let line = getline('.')

  if line !~# '^\s*it(\|^describe('
    if line =~# '\s*@'
      let pos = search('^\s*it(\|^describe(', 'Wn')
      let line = getline(pos)
    else
      let pos = search('^\s*it(\|^describe(', 'bWn')
      let line = getline(pos)
    endif
  endif
  return line
endfunction

function! s:get_root() abort
  let current_path = expand('%:p')
  let root_path = finddir('node_modules', current_path . ';')
  return root_path
endfunction

function! s:detect_bin()
  let jest = ''
  if executable('jest') == 0
    let root_path = s:get_root()
    let jest = root_path . '/.bin/jest'
    if filereadable(jest) == 0
      let root = findfile('lerna.json', expand('%:p') . ';')
      if root != ''
        let jest = printf('%s/node_modules/.bin/jest', fnamemodify(root, ':h'))
      endif
    endif
  else
    let jest = exepath('jest')
    if jest == ''
      return ''
    endif
  endif

  return jest
endfunction

function! s:coverage()
  if s:src_path == ''
    let current_path = expand('%:p')
    let s:src_path = finddir('src', current_path . ';')
  endif

  return ' --coverage=!' . s:src_path . '*/**.js'
endfunction

function! s:pick_name(string)
  let name = matchstr(a:string, "'.*'", 0)
  return name
endfunction

function! quickrunex#unittest#typescript_jest#run(session, context)
  if s:bin == ''
    let s:bin = s:detect_bin()
  endif

  if exists('+autochdir') && &autochdir
    let base = fnamemodify(s:get_root(), ':h')
    let s:current = getcwd()
    set noautochdir
    execute ':lcd ' . base
  endif

  let line = s:get_signeture()
  let file = expand('%:p')

  " Add -t pattern(execute test method or all tests)
  if line == ''
    let cmdopt = file
  else
    let pattern = s:pick_name(line)
    let cmdopt = ' -t ' . pattern . ' ' . file
  endi
  let cmdopt .= s:coverage()
  " let cmdopt = cmdopt . ' --clearCache'

  let a:session['config']['command'] = s:bin
  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

function! quickrunex#unittest#typescript_jest#finish()
  set autochdir
  execute ':lcd ' . s:current
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
