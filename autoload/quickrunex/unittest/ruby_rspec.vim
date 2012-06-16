" File: ruby_rspec.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 0.0.1
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: Run rspec's selecting tests.
" Link: See http://rspec.info/
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! quickrunex#unittest#ruby_rspec#run(session, context)
  let lineno = line('.')
  let cmdopt = a:session['config']['cmdopt'] . ' -l' . lineno
  let a:session['config']['cmdopt'] = cmdopt
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

