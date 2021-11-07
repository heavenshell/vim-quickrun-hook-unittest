" File: unittest.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" Version: 1.0.0
" WebPage: http://github.com/heavenshell/vim-quickrun-unittest/
" Description: QuickRun hook script for unittest
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

let s:hook = {'config': {'enable': 0}}

function! quickrun#hook#unittest#new()
  return deepcopy(s:hook)
endfunction

function! s:get_unittest_name(srcfile) abort
  let ft = &filetype
  if !has_key(g:quickrun_unittest_config, ft)
    return ''
  endif
  let configs = g:quickrun_unittest_config[ft]
  let items = keys(configs)

  let filename = fnamemodify(a:srcfile, ':t')
  for pattern in items
    if filename =~# printf('%s$', pattern)
      return configs[pattern]
    endif
  endfor

  return ''
endfunction

function! s:hook.on_module_loaded(session, context)
  if self.config.enable == 1
    try
      let config = get(g:, 'quickrun_unittest_config', {})
      let name = ''
      if empty(config) || !has_key(config, &filetype)
        " Fallback to old way.
        " Get from multiple filetypes
        " multiple filetypes are side-effect to deno with vim-lsp.
        " :LspDefinition has been failing.
        let name = substitute(&filetype, '\.', '_', 'g')
      else
        " Get from global config
        let configs = s:get_unittest_name(a:session['config']['srcfile'])
        let name = substitute(configs['ft'], '\.', '_', 'g')
        for [key, value] in items(configs['config'])
          let a:session['config'][key] = value
        endfor
      endif

      if name ==# ''
        return
      endif
      call quickrunex#unittest#{name}#run(a:session, a:context)
    catch
    endtry
  endif
endfunction

function! s:hook.on_finish(session, context)
  if self.config.enable == 1
    try
      let name = substitute(&filetype, '\.', '_', 'g')
      call quickrunex#unittest#{name}#finish()
    catch
    endtry
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
