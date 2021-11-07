" File: typescript_deno.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run deno selecting tests.
" Link: See https://deno.land/manual/testing#filtering
" License: zlib License
let s:save_cpo = &cpo
set cpo&vim

let s:bin = ''

function! s:get_signeture()
  let line = getline('.')

  if line =~# '\(Deno.\)\?test'
    " Same line
    return line
  endif

  let pos = search('\(Deno.\)\?test', 'bWn')
  if pos ==# 0
    return line
  endif

  let patterns = [
    \ 'test(".*"',
    \ "test('.*'",
    \ 'name:\s*\(".*"\)',
    \ "name:\s*\('.*'\)",
    \ ]
  let line = ''
  for pattern in patterns
    let pos = search(pattern, 'bWn')
    if pos != 0
      let line = getline(pos)
      break
    endif
  endfor
  return line
endfunction

function! s:get_root() abort
  let current_path = expand('%:p')
  let root_path = finddir('node_modules', current_path . ';')
  return root_path
endfunction

function! s:detect_bin()
  let deno = exepath('deno')
  if deno == ''
    return ''
  endif

  return deno
endfunction

function! s:pick_name(string)
  let pattern = '".*"' . '\|' . "'.*"
  return matchstr(a:string, pattern, 0)
endfunction

function! quickrunex#unittest#typescript_deno#run(session, context)
  if s:bin == ''
    let s:bin = s:detect_bin()
  endif

  let line = s:get_signeture()
  let file = expand('%:p')

  let $NO_COLOR = 'true'

  if line == ''
    let cmdopt = file
  else
    let pattern = s:pick_name(line)
    let cmdopt = '--filter ' . pattern . ' ' . file
  endif

  let a:session['config']['command'] = s:bin
  let a:session['config']['cmdopt'] = ' test --allow-all ' . cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

function! quickrunex#unittest#typescript_deno#finish()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
