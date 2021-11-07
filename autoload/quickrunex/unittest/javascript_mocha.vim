" File: javascript_mocha.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run Mocha selecting tests.
" Link: See https://mochajs.org/#g---grep-pattern
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

function! s:parse_mocha_opts(path) abort
  if !filereadable(a:path)
    throw a:path . ' is not exists.'
  endif
  let file = readfile(a:path, 'b')
  let current_path = expand('%:p')
  let root_path = findfile('package.json', current_path . ';')
  let root_path = fnamemodify(root_path, ':p:h')
  let opts = []
  for l in file
    if l =~ '\.js'
      let lines = split(l, ' ')
      call add(opts, printf('%s %s/%s', lines[0], root_path, lines[1]))
      let s:opt_file_relative_flag = 1
    else
      call add(opts, l)
    endif
  endfor
  return opts
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

function! s:move_to_package_json_path()
  let current_path = expand('%:p')
  let root_path = findfile('package.json', current_path . ';')
  let root_path = fnamemodify(root_path, ':p:h')
  execute ':lcd ' . root_path
endfunction

function! s:detect_optfile(filename) abort
  let current_path = expand('%:p')
  let optpath = findfile(a:filename, current_path . ';')
  if filereadable(optpath)
    return optpath
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
  let file = expand('%:p')

  let a:session['config']['command'] = s:bin
  let optfile = 'mocha.opts'
  if has_key(a:session['config'], 'opts')
    let optfile = a:session['config']['opts']
  endif
  let optpath = s:detect_optfile(optfile)
  let opts = s:parse_mocha_opts(optpath)

  " If opts file require project specific js file, convert to absolute path.
  if s:opt_file_relative_flag == 0
    let cmdopt = a:session['config']['cmdopt'] . '--opts ' . optpath
  else
    let opt = join(opts)
    let cmdopt = a:session['config']['cmdopt'] . opt
  endif

  " Add -g pattern(execute test method or all tests)
  if line == ''
    let cmdopt = cmdopt . ' ' . file
  else
    let pattern = s:pick_name(line)
    let cmdopt = cmdopt . ' -g ' . pattern . ' ' . file
  endi

  let a:session['config']['command'] = s:bin
  let a:session['config']['cmdopt'] = cmdopt
  let a:session['config']['exec'] = ['%c %o %a']
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
