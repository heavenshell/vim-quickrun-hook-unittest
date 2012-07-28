# coding: utf-8
import unittest

# global position. run all (total 7 tests) run.

def test_function():
    pass
    # run test_function.

def notest_function():
    pass
    # not testcase. run all test.

def this_test_is_run():
    pass
    # run this_test_is_run.

class SampleTestClass(unittest.TestCase):
    # run SampleTestClass class. Name 'Test' not required first.
    def test_method(self):
        pass
        # run SampleTestClass.test_method

    def snake_case_test_run(self):
        pass
        # run SampleTestClass.snake_case_test_running

    def snake_case_nottest_run(self):
        pass
        # not testcase. run SampleTestClass class.

    @classmethod      # decorator line, run SampleTestClass.test_have_decorator
    def test_have_decorator(self):
        pass
        #run SampleTestClass.test_have_decorator

class TestClassSample2(unittest.TestCase):
    # run TestClassSample2 class.

    def TestCamelCase(self):
        pass
        # run TestClassSample2.TestCamelCase

    def ThisTestIsNotRun(self):
        pass
        # not testcase. run TestClassSample2 class.

    def This_TestIsRun(self):
        pass
        # run TestClassSample2.This_TestIsRun



