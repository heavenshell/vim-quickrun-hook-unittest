" File: rust_test.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Rust selecting tests.
" Link: See https://doc.rust-lang.org/cargo/guide/tests.html
" License: zlib License
let s:save_cpo = &cpo
set cpo&vim

let s:current_path = ''
let s:src_path = ''
let s:opt_file_relative_flag = 0

function! s:get_test()
  let line = getline('.')
  let pos = line('.')

  if line !~# '\m\C#\[test\]'
    " Find #[test] attribute
    if line =~# '\s*@'
      let pos = search('\m\C#\[test\]', 'cWn')
      let line = getline(pos)
    else
      let pos = search('\m\C#\[test\]', 'bcWn')
      let line = getline(pos)
    endif

    " Find test function
    let pos = search('fn\s*\w*(*.)\s*{', 'bcWn')
    let line = getline(pos)
  else
    return ''
  endif
  return line
endfunction

function! s:get_root() abort
  let current_path = expand('%:p')
  let root_path = findfile('Cargo.toml', printf('%s;', current_path))
  return root_path
endfunction

function! s:pick_name(string)
  let name = substitute(a:string, '(.*$', '', '')
  let name = substitute(name, '^\s*fn\s\+', '', '')
  return name
endfunction

function! quickrunex#unittest#rust#run(session, context)
  if exists('+autochdir') && &autochdir
    let base = fnamemodify(s:get_root(), ':h')
    let s:current = getcwd()
    set noautochdir
    execute printf(':lcd %s', base)
  endif

  let line = s:get_test()
  let pattern = s:pick_name(line)

  let cmd = 'cargo'
  let cmdopt = printf('%s', pattern)

  let a:session['config']['command'] = cmd
  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c test %o']
endfunction

function! quickrunex#unittest#rust#finish()
  set autochdir
  execute printf(':lcd %s', s:current)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
