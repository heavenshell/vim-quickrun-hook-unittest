# Quickrun hook for unittest

QuickRun hook for enable to unittest by selecting method.

For example.

```python
from unittest import TestCase

class TestFoo(TestCase):
    def test_foo(self):
        pass

    def test_bar(TestCase):
        pass
```

QuickRun execute all tests.
But if you want to run only `test_bar()` method.

## Example

### Python

![Python](./assets/python.gif)

### Jest

![Jest](./assets/jest.gif)

## Install

Install the distributed files into Vim runtime directory which is usually
~/.vim/, or $HOME/vimfiles on Windows.

If you install pathogen provided by Tim Pope, you should extract the
file into 'bundle' directory.

## Usage

1. Add below example to your `.vimrc` or `_vimrc`.

  ```viml
  nnoremap <silent> ,r :QuickRun -mode n -runner job -hook/unittest/enable 1<CR>
  ```

2. Open your unittest file.
3. Move cursor to test method scope.
4. For example, move cursor next to def test_foo(self) line.
5. Type `,r` and then execute QuickRun automatically.
6. QuickRun output only test_foo() test result.

## Test runners

This plugin required awesome testing framework/runner to run.

- Python
  - [nose(Python unittesting framework)](http://nose.readthedocs.org/en/latest/)
  - [py.test(Python unittesting framework)](http://pytest.org/latest/index.html)
  - [Django](https://docs.djangoproject.com/en/1.10/topics/testing/overview/#running-tests)
- PHP
  - [Stagehand_TestRunner:PHP continuous test runner](http://piece-framework.com/projects/stagehand-testrunner/wiki)
- Ruby
  - [RSpec: Ruby testing tool for Behaviour-Driven Development](http://rspec.info/)
  - [minitest/unit: a small and incredibly fast unit testing framework](https://github.com/seattlerb/minitest)
- JavaScript / TypeScript
  - [Mocha - the fun, simple, flexible JavaScript test framework](https://mochajs.org)
  - [Jest - Delightful JavaScript Testing](http://facebook.github.io/jest/)
  - [Deno](https://deno.land/manual/testing)
- Rust(`cargo test`)
  - [Rust - Rust Programming Language](https://doc.rust-lang.org/stable/rust-by-example/testing.html)

## Example QuickRun configs

```viml
augroup QuickRunUnitTest
  autocmd!
  autocmd BufWinEnter,BufNewFile *test.php setlocal filetype=php.unit
  " Choose UnitTest, py.test or Django.
  autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.unit
  " autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.pytest
  " autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.django
  autocmd BufWinEnter,BufNewFile *.t       setlocal filetype=perl.unit
  autocmd BufWinEnter,BufNewFile *_spec.rb setlocal filetype=ruby.rspec
  autocmd BufWinEnter,BufNewFile *_test.rb setlocal filetype=ruby.minitest
  autocmd BufWinEnter,BufNewFile *_test.go setlocal filetype=go.test
  " TypeScript support only Jest
  autocmd BufWinEnter,BufNewFile *.spec.ts setlocal filetype=typescript.jest
  " Choose Mocha or Jest
  " autocmd BufWinEnter,BufNewFile *.test.js setlocal filetype=javascript.mocha
  " autocmd BufWinEnter,BufNewFile *.test.js setlocal filetype=javascript.jest
  autocmd BufWinEnter,BufNewFile *test.ts setlocal filetype=typescript.deno
  autocmd BufWinEnter,BufNewFile *test.tsx setlocal filetype=typescript.deno
augroup END
let g:quickrun_config = {}
let g:quickrun_config['php.unit']         = { 'command': 'testrunner', 'cmdopt': 'phpunit' }
let g:quickrun_config['python.unit']      = { 'command': 'nosetests',  'cmdopt': '-v -s'   }
let g:quickrun_config['python.pytest']    = { 'command': 'py.test',    'cmdopt': '-v'      }
" Django unittest
let g:quickrun_config['python.django']    = { 'command': 'python',     'cmdopt': 'test --pararell=2 --keepdb -v2'}
" pytest-django
" let g:quickrun_config['python.django']    = { 'command': 'python',     'cmdopt': 'test --noinput -- --verbose --reuse-db', 'test_fw': 'pytest' }
let g:quickrun_config['ruby.rspec']       = { 'command': 'rspec',      'cmdopt': '-f d'    }
let g:quickrun_config['ruby.minitest']    = { 'command': 'ruby'                            }
let g:quickrun_config['go.test']          = { 'command': 'go',         'cmdopt': 'test -v' }
let g:quickrun_config['typescript.jest']  = { 'command': 'jest'  }
let g:quickrun_config['javascript.mocha'] = { 'command': 'mocha' }
let g:quickrun_config['javascript.jest']  = { 'command': 'jest'  }
```

### Extra config

If you using jest in monorepo(lerna) and enable autochdir, you can set jest.config.

```console
let g:quickrun_hook_unittest_enable_jest_config = 1
" If you don't set below path, default jest.config.json was used.
let g:quickrun_hook_unittest_jest_config_path = '/path/to/jest.config.json
```

Since Jest v27, default testEnvironment was changed from `jsdom` to `node`.
QuickRunUnitTest keep backward compatible with previous behaviour as `jsdom`.

If you want change to node, you can set like following.

```console
let g:quickrun_hook_unittest_jest_test_environment = 'node'
```

This option is affect only jest in monorepo(lerna) and enable autochdir.

## LICENSE

zlib License(Same as vim-quickrun)
