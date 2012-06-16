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
