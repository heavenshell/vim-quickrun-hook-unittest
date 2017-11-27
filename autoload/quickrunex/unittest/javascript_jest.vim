" File: javascript_jest.vim
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

function! s:detect_bin()
  let jest = ''
  if executable('jest') == 0
    let current_path = expand('%:p')
    let root_path = finddir('node_modules', current_path . ';')
    let jest = root_path . '/.bin/jest'
  else
    let jest = exepath('jest')
    if jest == ''
      return ''
    endif
  endif

  return jest
endfunction

function! s:pick_name(string)
  let name = matchstr(a:string, "'.*'", 0)
  return name
endfunction

function! quickrunex#unittest#javascript_jest#run(session, context)
  if s:bin == ''
    let s:bin = s:detect_bin()
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
  " let cmdopt = cmdopt . ' --clearCache'

  let a:session['config']['command'] = s:bin
  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
