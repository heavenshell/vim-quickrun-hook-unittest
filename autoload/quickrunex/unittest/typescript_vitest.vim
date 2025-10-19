" File: typescript_vitest.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run vitest selecting tests.
" Link: See https://vitest.dev/guide/cli.html#options
" License: zlib License
let s:save_cpo = &cpo
set cpo&vim

let s:vitest_config_path = printf('%s/vitest.config.ts', expand('<sfile>:p:h'))
let g:quickrun_hook_unittest_enable_vitest_config = get(g:, 'quickrun_hook_unittest_enable_vitest_config', 0)
let g:quickrun_hook_unittest_vitest_config_path = get(g:, 'quickrun_hook_unittest_vitest_config_path', s:vitest_config_path)
let g:quickrun_hook_unittest_vitest_dom = get(g:, 'quickrun_hook_unittest_vitest_dom', '')

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

function! s:get_monorepo_root() abort
  let root = findfile('pnpm-workspace.yaml', expand('%:p') . ';')
  if root != ''
    return fnamemodify(root, ':h')
  endif
  return ''
  let root = findfile('lerna.json', expand('%:p') . ';')
  if root != ''
    return fnamemodify(root, ':h')
  endif
  return ''
endfunction

function! s:get_root() abort
  let current_path = expand('%:p')
  let root_path = finddir('node_modules', current_path . ';')
  return root_path
endfunction

function! s:detect_bin()
  let vitest = ''
  if executable('vitest') == 0
    let root_path = s:get_root()
    let vitest = root_path . '/.bin/vitest'
    if filereadable(vitest) == 0
      let root = findfile('pnpm-workspace.yaml', expand('%:p') . ';')
      if root != ''
        let vitest = printf('%s/node_modules/.bin/vitest', fnamemodify(root, ':h'))
      endif

      let root = findfile('lerna.json', expand('%:p') . ';')
      if root != ''
        let vitest = printf('%s/node_modules/.bin/vitest', fnamemodify(root, ':h'))
      endif
    endif
  else
    let vitest = exepath('vitest')
    if vitest == ''
      return ''
    endif
  endif

  return vitest
endfunction

function! s:pick_name(string)
  let name = matchstr(a:string, "'.*'", 0)
  return name
endfunction

function! quickrunex#unittest#typescript_vitest#run(session, context)
  if s:bin == ''
    let s:bin = s:detect_bin()
  endif
  let rootDir = ''
  if exists('+autochdir') && &autochdir
    let monorepo_root = s:get_monorepo_root()
    if monorepo_root == ''
      let base = fnamemodify(s:get_root(), ':h')
    else
      let base = monorepo_root
      let rootDir = printf(' --root=%s', base)
      if g:quickrun_hook_unittest_enable_vitest_config ==# 1
        let rootDir = rootDir . printf(' -c=%s', g:quickrun_hook_unittest_vitest_config_path)
      endif
      if g:quickrun_hook_unittest_vitest_dom !=# ''
        let rootDir = printf('%s --dom=%s', rootDir, g:quickrun_hook_unittest_vitest_dom)
      endif
    endif
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
  if rootDir != ''
    let cmdopt = cmdopt . rootDir
  endif

  let a:session['config']['command'] = s:bin
  let a:session['config']['cmdopt'] .= cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

function! quickrunex#unittest#typescript_vitest#finish()
  set autochdir
  execute ':lcd ' . s:current
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
