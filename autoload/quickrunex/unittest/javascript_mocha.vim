" File: javascript_mocha.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Mocha selecting tests.
" Link: See https://mochajs.org/#g---grep-pattern
" License: zlib License
let s:save_cpo = &cpo
set cpo&vim

let s:bin = ''

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
  let mocha = ''
  if executable('mocha') == 0
    let current_path = expand('%:p')
    let root_path = finddir('node_modules', current_path . ';')
    let mocha = root_path . '/.bin/mocha'
  else
    let mocha = exepath('mocha')
    if mocha == ''
      return ''
    endif
  endif

  return mocha
endfunction

function! s:detect_optfile() abort
  let current_path = expand('%:p')
  let root_path = finddir('node_modules', current_path . ';')
  let root_path = fnamemodify(root_path, ':h')
  " TODO Get from `.vimrc`.
  if filereadable(root_path . '/test/mocha.opts')
    return root_path . '/test/mocha.opts'
  endif

  return ''
endfunction

function! s:pick_name(string)
  let name = matchstr(a:string, "'.*'", 0)
  return name
endfunction

function! quickrunex#unittest#javascript_mocha#run(session, context)
  if s:bin == ''
    let s:bin = s:detect_bin()
  endif

  let line = s:get_signeture()
  let pattern = s:pick_name(line)
  let file = expand('%:p')
  let optpath = s:detect_optfile()

  let a:session['config']['command'] = s:bin
  let cmdopt = a:session['config']['cmdopt'] . '--opts ' . optpath. ' -g ' . pattern . ' ' . file

  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c %o %a']

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
