Quickrun hook for unittest
==========================

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
But if you want to run only test_bar() method.

Install
-------

Install the distributed files into Vim runtime directory which is usually
~/.vim/, or $HOME/vimfiles on Windows.

If you install pathogen that provided from Tim Pope, you should extract the
file into 'bundle' directory.

Usage
-----

1. Add below example to your .vimrc or _vimrc.

```viml
nnoremap <silent> ,r :QuickRun -mode n -runner vimproc:updatetime=10 -hook/unittest/enable 1<CR>
```

2. Open your unittest file.
3. Move cursor to test method scope.
4. For example, move cursor next to def test_foo(self) line.
5. Type `,r` and then execute QuickRun automatically.
6. QuickRun output only test_foo() test result.

Test runners
------------

This plugin required awesome testing flamework/runner to run.

- Python
  - [nose(Python unittesting flamework)](http://nose.readthedocs.org/en/latest/)
  - [pyt.test(Python unittesting flamework)](http://pytest.org/latest/index.html)
- PHP
  - [Stagehand_TestRunner:PHP continuous test runner](http://piece-framework.com/projects/stagehand-testrunner/wiki)
- RSpec
  - [RSpec: Ruby testing tool for Behaviour-Driven Development](http://rspec.info/)


Example QuickRun configs
------------------------

```viml
augroup QuickRunUnitTest
  autocmd!
  autocmd BufWinEnter,BufNewFile *test.php setlocal filetype=php.unit
  " Choose UnitTest or py.test.
  autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.unit
  "autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.pytest
  autocmd BufWinEnter,BufNewFile *.t setlocal filetype=perl.unit
  autocmd BufWinEnter,BufNewFile *_spec.rb setlocal filetype=ruby.rspec
augroup END
let g:quickrun_config = {}
let g:quickrun_config['php.unit']    = {'command': 'testrunner', 'cmdopt': 'phpunit'}
let g:quickrun_config['python.unit'] = {'command': 'nosetests', 'cmdopt': '-v -s'}
let g:quickrun_config['python.pytest'] = {'command': 'py.test', 'cmdopt': '-v'}
let g:quickrun_config['ruby.rspec']  = {'command': 'rspec', 'cmdopt': '-f d'}
```
