(setq pyel-test-py-functions '("def pyel_test_copy_method_458(n):
 x = {1:['one'],2:'two',3:'three'}
 y = x
 z = x.copy()
 if n == 1:
  return x is z
 
 if n == 2:
  return x[1] is z[1]" "def pyel_test_popitem_method_457(n):
 x = {1:'one',2:'two',3:'three'}
 y = x.popitem()
 if n == 1:
  return y
 
 if n == 2:
  return repr(x)" "def pyel_test_values_method_456(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.values()
 
 if n == 2:
  return y.values()
 
 if n == 3:
  return z.values()" "def pyel_test_keys_method_455(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.keys()
 
 if n == 2:
  return y.keys()
 
 if n == 3:
  return z.keys()" "def pyel_test_items_method_454(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.items()
 
 if n == 2:
  return y.items()
 
 if n == 3:
  return z.items()" "def pyel_test_get_method_453(n):
 x = {1:'one',2:'two',3:'three'}
 if n == 1:
  return x[1]
 
 if n == 2:
  return x[1] == x.get(1)
 
 if n == 3:
  return x.get(3, 'd')
 
 if n == 4:
  return x.get(4, 'd')" "def pyel_test_strip_method_452():
 x = 'hello'
 return x.strip('hlo')" "def pyel_test_split_method_451():
 x = 'a b c'
 y = x.split()
 return y" "def pyel_test_split_method_450(n):
 y = 'a x b x d x'.split()
 if n == 1:
  return y
 
 if n == 2:
  return len(y)" "def pyel_test_upper_method_449(n):
 x = 'aB'
 y = x
 y = x.upper()
 if n == 1:
  return y
 
 if n == 2:
  return x" "def pyel_test_lower_method_448(n):
 x = 'aB'
 y = x
 y = x.lower()
 if n == 1:
  return y
 
 if n == 2:
  return x" "def pyel_test_reverse_method_447(n):
 x = [1,2,3]
 y = x
 x.reverse()
 if n == 1:
  return x
 
 if n == 2:
  return x is y" "def pyel_test_pop_method_446(n):
 x = [[1],'s',(2,), 1, 4]
 y = x
 a = x.pop()
 b = x.pop(0)
 c = x.pop(2)
  
 if n == 1:
  return a
 
 if n == 2:
  return b
 
 if n == 3:
  return c
 
 if n == 4:
  return x is y" "def pyel_test_pop_method_445(n):
 x = {1:'one',2:'two',3:'three'}
 y = x.pop(2)
 if n == 1:
  return y
 
 if n == 2:
  return repr(x)" "def pyel_test_extend_method_444(n):
 x = [1]
 y = x
 x.extend([1,'2',(3,)])
 if n == 1:
  return x is y
 
 if n == 2:
  return x" "def pyel_test_extend_method_443(n):
 x = [1]
 y = x
 x.extend((1,'2',(3,)))
 if n == 1:
  return x is y
 
 if n == 2:
  return x" "def pyel_test_extend_method_442(n):
 x = [1]
 y = x
 x.extend('extended')
 if n == 1:
  return x is y
 
 if n == 2:
  return x" "def pyel_test_extend_method_441(n):
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 x = [1]
 y = x
 x.extend(obj)
 if n == 1:
  return y is x
 
 if n == 2:
  return x" "def pyel_test_count_method_440(n):
 x = [1,2,3,3,[2],'s']
 if n == 1:
  return x.count(3)
 
 if n == 2:
  return x.count(2)
 
 if n == 3:
  return x.count([3,4])
 
 if n == 4:
  return x.count('s')" "def pyel_test_count_method_439(n):
 x = (1,2,3,3,[2],'s')
 if n == 1:
  return x.count(3)
 
 if n == 2:
  return x.count(2)
 
 if n == 3:
  return x.count([3,4])
 
 if n == 4:
  return x.count('s')" "def pyel_test_remove_method_438():
 x = [1,'2','2',(1,)]
 y = x
 x.remove('2')
 return x is y" "def pyel_test_remove_method_437():
 x = [1,'2','2',(1,)]
 x.remove('2')
 return x" "def pyel_test_remove_method_436():
 x = [1,'2','2',(1,)]
 x.remove(1)
 return x" "def pyel_test_remove_method_435():
 x = [1,'2','2',(1,)]
 x.remove((1,))
 return x" "def pyel_test_index_method_434(n):
 x = [1,(1,2),'5']
 if n == 1:
  return x.index(1)
 
 if n == 2:
  return x.index((1,2))
 
 if n == 3:
  return x.index('5')" "def pyel_test_index_method_433(n):
 x = 'importantstring'
 if n == 1:
  return x.index('t')
 
 if n == 2:
  return x.index('or')
 
 if n == 3:
  return x.index('g')
 
 if n == 4:
  return x.index(x)" "def pyel_test_index_method_432():
 x = 'str.ing'
 return x.index('.')" "def pyel_test_index_method_431(n):
 x = (1,2,'tree',(3,))
 if n == 1:
  return x.index(1)
 
 if n == 2:
  return x.index('tree')
 
 if n == 3:
  return x.index((3,))" "def pyel_test_insert_430(n):
 x = [1,2,3]
 y = x
 x.insert(1,'hi')
 if n == 1:
  return x
 
 if n == 2:
  return x is y" "def pyel_test_append_429(n):
 a = [1,2,3]
 c = ['a','a']
 b = a
 a.append('hi')
 if n == 1:
  return a
 
 if n == 2:
  return a is b
 
 if n == 3:
  a.append(c)
  return a is b
 
 if n == 4:
  a.append(c)
  return a[3] is c" "def pyel_test_abs_function_428():
 class C:
  def __abs__(self):
   'doc'
   return 'hi'
 obj = C()
 return abs(obj)" "def pyel_test_type_427(n):
 class testc: pass
 x = testc()
 y = type(x)
 if n == 1:
  return repr(type(x))
 
 if n == 2:
  return y is testc" "def pyel_test_list_function_426(n):
 a = [1]
 b = [a,1]
 c = list(b)
 if n == 1:
  return c is b
 
 if n == 2:
  return c == b
 
 if n == 3:
  return c[0] is a" "def pyel_test_list_function_425(n):
 a = [1]
 b = (a, 1)
 c = list(b)
 if n == 1:
  return c
 
 if n == 2:
  return c[0] is a" "def pyel_test_list_function_424():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 return list(obj)" "def pyel_test_len_function_423(n):
 a = [1,2,3,'5']
 b = []
 c = 'str'
 d = (1,2,3,4)
 if n == 1:
  return len(a)
 
 if n == 2:
  return len(b)
 
 if n == 3:
  return len(c)
 
 if n == 4:
  return len(d)" "def pyel_test_special_method_lookup_299(n):
 class adder:
  def __init__(self, n):
   self.x = n
  def __call__ (self, n):
   return self.x + n
 c = adder(10)
 d = adder(10)
 d.__call__ = lambda : 'hi'
 if n == 1:
  return c(6)
 
 if n == 2:
  return repr(c.__call__)
 
 if n == 3:
  return d.__call__" "def pyel_test_objects_298(n):
 class tclass():
  '''a test class'''
  cvar = 12
  def __init__(self, x):
   self.a = x + 10
  def get(self):
   return self.a
  def set(self,n):
   self.a = n
 x = tclass(4)
 if n == 1:
  return tclass.__name__
 
 if n == 2:
  return tclass.get
 
 if n == 3:
  return tclass.set
 
 if n == 4:
  return tclass.cvar
 
 if n == 5:
  tclass.v = 'hi'
  return tclass.v
 
 if n == 6:
  tclass.set(tclass, 23)
  return tclass.a
 
 if n == 7:
  tclass.set(tclass, 19)
  return tclass.get(tclass)
 
 if n == 8:
  tclass.add5 = lambda self: self.cvar + 5
  return tclass.add5
 
 if n == 9:
  return repr(x)
 
 if n == 10:
  return x.__class__ == tclass
 
 if n == 11:
  return x.__class__.__name__
 
 if n == 12:
  return x.a
 
 if n == 13:
  x.a = 2
  return x.a
 
 if n == 14:
  x.cvar = 4
  return  x.cvar, tclass.cvar
 
 if n == 15:
  x.set(10); y = x.get
  return y()
 
 if n == 16:
  tclass.sixmore = lambda self: self.a + 6
  y = x.sixmore
  x.a = 2
  return y()" "def pyel_test_objects_297(n):
 class one:
  def __init__(self,x):
   self.n = x
  def m(self):
   return self.n + 1
 class two:
  def __init__(self):
   self.other = one(5)
 x = two()
 if n == 1:
  return x.other.n
 
 if n == 2:
  return x.other.m()" "def pyel_test_function_arguments_233(n):
 def func(__a,__b,c=1,d='two',*rest,**kwargs):
  return [__a,__b,c,d,rest,kwargs]
 if n == 1:
  return repr(func(1,2))
 
 if n == 2:
  return repr(func(1,2,3))
 
 if n == 3:
  return repr(func(1,2,3,4))
 
 if n == 4:
  return repr(func(1,2,3,4,5))
 
 if n == 5:
  return repr(func(1,2,3,4,5,6))
 
 if n == 6:
  return repr(func(1,2,3,4,5,6,x = 's'))
 
 if n == 7:
  return repr(func(1,2,3,4,5,6,x = 's',y = 23))
 
 if n == 8:
  return repr(func(x = 's',__b = 324,__a = 'n',))
 
 if n == 9:
  return repr(func(x = 's',__b = 324,__a = 'n',d = 2))" "def pyel_test_list_85(n):
 a = [1,2,'b']
 b = [1,[1,'3',a,[],3]]
 if n == 1:
  return a
 
 if n == 2:
  return b" "def pyel_test_assign_33():
 a = 1
 return a" "def pyel_test_assign_32():
 class a: pass
 a.b = 1
 return a.b" "def pyel_test_assign_22(n):
 a,b = 1,2
 if n == 1:
  return a
 
 if n == 2:
  return b" "def pyel_test_assign_21(n):
 x = [1,0,9]
 f = lambda: 3
 class C: pass
 C.a = 3
 a, C.v, x[2] = C.a,1.1, x[x[1]]
 if n == 1:
  return a
 
 if n == 2:
  return C.v
 
 if n == 3:
  return x[2]" "def pyel_test_assign_20(n):
 a = 1
 b = 2
 a,b= b,a
 if n == 1:
  return a
 
 if n == 2:
  return b" "def pyel_test_assign_19(n):
 a = [1,2]
 b = (3,4)
 x,y = a
 xx,yy = b
 if n == 1:
  return x
 
 if n == 2:
  return y
 
 if n == 3:
  return xx
 
 if n == 4:
  return yy" "def pyel_test_assign_18(n):
 class C:
  a = [11,22,33]
 x,y,z = C.a
 if n == 1:
  return x
 
 if n == 2:
  return y
 
 if n == 3:
  return z" "def pyel_test_assign_17():
 a = 1
 b = 2
 c = 3
 d = a,b,c
 return d" "def pyel_test_assign_1(n):
 a = b = c = 9
 if n == 1:
  return a
 
 if n == 2:
  return b
 
 if n == 3:
  return c"))(ert-deftest pyel-strip-method3 nil (equal (eval (pyel "def _pyel21312():
 '
 hello 	'.strip('heo')
_pyel21312()")) "hello"))
(ert-deftest pyel-strip-method2 nil (equal (eval (pyel "def _pyel21312():
 'hello'.strip('heo')
_pyel21312()")) "ll"))
(ert-deftest pyel-split-method3 nil (equal (eval (pyel "def _pyel21312():
 'a b c'.split()
_pyel21312()")) (quote ("a" "b" "c"))))
(ert-deftest pyel-join-method3 nil (equal (eval (pyel "def _pyel21312():
 'X'.join(('f','g'))
_pyel21312()")) "fXg"))
(ert-deftest pyel-join-method2 nil (equal (eval (pyel "def _pyel21312():
 ' '.join([str(x) for x in range(3)])
_pyel21312()")) "0 1 2"))
(ert-deftest pyel-join-method1 nil (equal (eval (pyel "def _pyel21312():
 ''.join(['a','b']))
_pyel21312()")) "ab"))
(ert-deftest pyel-count-method13 nil (equal (eval (pyel "def _pyel21312():
 'xxxxx'.count('x')
_pyel21312()")) 5))
(ert-deftest pyel-count-method12 nil (equal (eval (pyel "def _pyel21312():
 'xxxx'.count('xx')
_pyel21312()")) 2))
(ert-deftest pyel-count-method11 nil (equal (eval (pyel "def _pyel21312():
 'xxxx'.count('xxxx')
_pyel21312()")) 1))
(ert-deftest pyel-count-method10 nil (equal (eval (pyel "def _pyel21312():
 'x.xx'.count('.')
_pyel21312()")) 1))
(ert-deftest pyel-count-method1 nil (equal (eval (pyel "def _pyel21312():
 (1,1,1).count(1)
_pyel21312()")) 3))
(ert-deftest pyel-chr-function2 nil (equal (eval (pyel "def _pyel21312():
 chr(70)
_pyel21312()")) "F"))
(ert-deftest pyel-chr-function1 nil (equal (eval (pyel "def _pyel21312():
 chr(50)
_pyel21312()")) "2"))
(ert-deftest pyel-abs-function3 nil (equal (eval (pyel "def _pyel21312():
 abs(3)
_pyel21312()")) 3))
(ert-deftest pyel-abs-function2 nil (equal (eval (pyel "def _pyel21312():
 abs(-3)
_pyel21312()")) 3))
(ert-deftest pyel-type9 nil (equal (eval (pyel "def _pyel21312():
 type(t)
_pyel21312()")) "<class 'bool'>"))
(ert-deftest pyel-type8 nil (equal (eval (pyel "def _pyel21312():
 type(3)
_pyel21312()")) (quote integer)))
(ert-deftest pyel-type7 nil (equal (eval (pyel "def _pyel21312():
 type(3.3)
_pyel21312()")) (quote float)))
(ert-deftest pyel-type6 nil (equal (eval (pyel "def _pyel21312():
 type('3')
_pyel21312()")) (quote string)))
(ert-deftest pyel-type5 nil (equal (eval (pyel "def _pyel21312():
 type([3])
_pyel21312()")) (quote cons)))
(ert-deftest pyel-type4 nil (equal (eval (pyel "def _pyel21312():
 type((3,))
_pyel21312()")) (quote vector)))
(ert-deftest pyel-type3 nil (equal (eval (pyel "def _pyel21312():
 type({3:'3'})
_pyel21312()")) (quote hash-table)))
(ert-deftest pyel-eval1 nil (equal (eval (pyel "def _pyel21312():
 x = 23
 eval('x')
_pyel21312()")) 23))
(ert-deftest pyel-pow4 nil (equal (eval (pyel "def _pyel21312():
 pow(2,5,5)
_pyel21312()")) 2))
(ert-deftest pyel-pow3 nil (equal (eval (pyel "def _pyel21312():
 pow(3,7,20)
_pyel21312()")) 7))
(ert-deftest pyel-pow2 nil (equal (eval (pyel "def _pyel21312():
 pow(3,7)
_pyel21312()")) 2187))
(ert-deftest pyel-pow1 nil (equal (eval (pyel "def _pyel21312():
 pow(2,2)
_pyel21312()")) 4))
(ert-deftest pyel-bin-function2 nil (equal (eval (pyel "def _pyel21312():
 bin(123)
_pyel21312()")) "0b1111011"))
(ert-deftest pyel-bin-function1 nil (equal (eval (pyel "def _pyel21312():
 bin(3456312)
_pyel21312()")) "0b1101001011110100111000"))
(ert-deftest pyel-hex-function2 nil (equal (eval (pyel "def _pyel21312():
 hex(23)
_pyel21312()")) "0x17"))
(ert-deftest pyel-hex-function1 nil (equal (eval (pyel "def _pyel21312():
 hex(123232332)
_pyel21312()")) "0x758604c"))
(ert-deftest pyel-repr7 nil (equal (eval (pyel "def _pyel21312():
 repr('somestring')
_pyel21312()")) "\"\\\"somestring\\\"\""))
(ert-deftest pyel-repr6 nil (equal (eval (pyel "def _pyel21312():
 repr(342)
_pyel21312()")) "342"))
(ert-deftest pyel-repr5 nil (equal (eval (pyel "def _pyel21312():
 x = [1,2,'hi']
 repr(x)
_pyel21312()")) "[1, 2, \"hi\"]"))
(ert-deftest pyel-repr4 nil (equal (eval (pyel "def _pyel21312():
 x = (1,'two',3)
 repr(x)
_pyel21312()")) "(1, \"two\", 3)"))
(ert-deftest pyel-repr3 nil (equal (eval (pyel "def _pyel21312():
 x = {1: 'one', 5: 'five', 12: 'telve'}
 repr(x)
_pyel21312()")) "{1: \"one\", 5: \"five\", 12: \"telve\"}"))
(ert-deftest pyel-repr2 nil (equal (eval (pyel "def _pyel21312():
 f = lambda : False
 repr(f)
_pyel21312()")) "<function <lambda> at 0x18b071>"))
(ert-deftest pyel-repr1 nil (equal (eval (pyel "def _pyel21312():
 def __ff_(): pass
 repr(__ff_)
_pyel21312()")) "<function --ff- at 0x18b071>"))
(ert-deftest pyel-str8 nil (equal (eval (pyel "def _pyel21312():
 str('somestring')
_pyel21312()")) "\"somestring\""))
(ert-deftest pyel-str7 nil (equal (eval (pyel "def _pyel21312():
 str(\"'dstring'\")
_pyel21312()")) "\"'dstring'\""))
(ert-deftest pyel-str6 nil (equal (eval (pyel "def _pyel21312():
 str(342)
_pyel21312()")) "342"))
(ert-deftest pyel-str5 nil (equal (eval (pyel "def _pyel21312():
 x = [1,2,'hi']
 str(x)
_pyel21312()")) "[1, 2, \"hi\"]"))
(ert-deftest pyel-str4 nil (equal (eval (pyel "def _pyel21312():
 x = (1,'two',3)
 str(x)
_pyel21312()")) "(1, \"two\", 3)"))
(ert-deftest pyel-str3 nil (equal (eval (pyel "def _pyel21312():
 x = {1: 'one', 5: 'five', 12: 'telve'};
 str(x)
_pyel21312()")) "{1: \"one\", 5: \"five\", 12: \"telve\"}"))
(ert-deftest pyel-str2 nil (equal (eval (pyel "def _pyel21312():
 f = lambda : False
 str(f)
_pyel21312()")) "<function <lambda> at 0x18b071>"))
(ert-deftest pyel-str1 nil (equal (eval (pyel "def _pyel21312():
 def __ff_(): pass
 str(__ff_)
_pyel21312()")) "<function --ff- at 0x18b071>"))
(ert-deftest pyel-list-function9 nil (equal (eval (pyel "def _pyel21312():
 list('string')
_pyel21312()")) (quote ("s" "t" "r" "i" "n" "g"))))
(ert-deftest pyel-list-function8 nil (equal (eval (pyel "def _pyel21312():
 list([1,2,'3',(2,)])
_pyel21312()")) (quote (1 2 "3" [2]))))
(ert-deftest pyel-list-function2 nil (equal (eval (pyel "def _pyel21312():
 list({1:'one', 2:'two', 3:'three'})
_pyel21312()")) (quote (3 2 1))))
(ert-deftest pyel-range-function3 nil (equal (eval (pyel "def _pyel21312():
 range(5)
_pyel21312()")) (quote (0 1 2 3 4))))
(ert-deftest pyel-range-function2 nil (equal (eval (pyel "def _pyel21312():
 range(2,7)
_pyel21312()")) (quote (2 3 4 5 6))))
(ert-deftest pyel-range-function1 nil (equal (eval (pyel "def _pyel21312():
 range(2,20,3)
_pyel21312()")) (quote (2 5 8 11 14 17))))
(ert-deftest pyel-len-function2 nil (equal (eval (pyel "def _pyel21312():
 len('')
_pyel21312()")) 0))
(ert-deftest pyel-len-function1 nil (equal (eval (pyel "def _pyel21312():
 len([3,4])
_pyel21312()")) 2))
(ert-deftest pyel-list5 nil (equal (eval (pyel "def _pyel21312():
 []
_pyel21312()")) nil))
(ert-deftest pyel-list4 nil (equal (eval (pyel "def _pyel21312():
 ['a',1,2]
_pyel21312()")) (quote ("a" 1 2))))
(ert-deftest pyel-list1 nil (equal (eval (pyel "def _pyel21312():
 [[[1]]]
_pyel21312()")) (quote (((1))))))
(ert-deftest pyel-num3 nil (equal (eval (pyel "def _pyel21312():
 3
_pyel21312()")) 3))
(ert-deftest pyel-num2 nil (equal (eval (pyel "def _pyel21312():
 4.23
_pyel21312()")) 4.23))
(ert-deftest pyel-num1 nil (equal (eval (pyel "def _pyel21312():
 3e2
_pyel21312()")) 300.0))
(ert-deftest pyel-test-assign-1 nil (equal (eval (pyel "pyel_test_assign_1(1)")) 9))
(ert-deftest pyel-test-assign-2 nil (equal (eval (pyel "pyel_test_assign_1(2)")) 9))
(ert-deftest pyel-test-assign-3 nil (equal (eval (pyel "pyel_test_assign_1(3)")) 9))
(ert-deftest pyel-test-assign-4 nil (equal (eval (pyel "pyel_test_assign_17()")) [1 2 3]))
(ert-deftest pyel-test-assign-5 nil (equal (eval (pyel "pyel_test_assign_18(1)")) 11))
(ert-deftest pyel-test-assign-6 nil (equal (eval (pyel "pyel_test_assign_18(2)")) 22))
(ert-deftest pyel-test-assign-7 nil (equal (eval (pyel "pyel_test_assign_18(3)")) 33))
(ert-deftest pyel-test-assign-8 nil (equal (eval (pyel "pyel_test_assign_19(1)")) 1))
(ert-deftest pyel-test-assign-9 nil (equal (eval (pyel "pyel_test_assign_19(2)")) 2))
(ert-deftest pyel-test-assign-10 nil (equal (eval (pyel "pyel_test_assign_19(3)")) 3))
(ert-deftest pyel-test-assign-11 nil (equal (eval (pyel "pyel_test_assign_19(4)")) 3))
(ert-deftest pyel-test-assign-12 nil (equal (eval (pyel "pyel_test_assign_20(1)")) 2))
(ert-deftest pyel-test-assign-13 nil (equal (eval (pyel "pyel_test_assign_20(2)")) 1))
(ert-deftest pyel-test-assign-14 nil (equal (eval (pyel "pyel_test_assign_21(1)")) 3))
(ert-deftest pyel-test-assign-15 nil (equal (eval (pyel "pyel_test_assign_21(2)")) 1.1))
(ert-deftest pyel-test-assign-16 nil (equal (eval (pyel "pyel_test_assign_21(3)")) 1))
(ert-deftest pyel-test-assign-17 nil (equal (eval (pyel "pyel_test_assign_22(1)")) 1))
(ert-deftest pyel-test-assign-18 nil (equal (eval (pyel "pyel_test_assign_22(2)")) 2))
(ert-deftest pyel-test-assign-19 nil (equal (eval (pyel "pyel_test_assign_32()")) 1))
(ert-deftest pyel-test-assign-20 nil (equal (eval (pyel "pyel_test_assign_33()")) 1))
(ert-deftest pyel-test-list-2 nil (equal (eval (pyel "pyel_test_list_85(1)")) (quote (1 2 "b"))))
(ert-deftest pyel-test-list-3 nil (equal (eval (pyel "pyel_test_list_85(2)")) (quote (1 (1 "3" (1 2 "b") nil 3)))))
(ert-deftest pyel-test-function_arguments-1 nil (equal (eval (pyel "pyel_test_function_arguments_233(1)")) "[1, 2, 1, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-2 nil (equal (eval (pyel "pyel_test_function_arguments_233(2)")) "[1, 2, 3, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-3 nil (equal (eval (pyel "pyel_test_function_arguments_233(3)")) "[1, 2, 3, 4, [], {}]"))
(ert-deftest pyel-test-function_arguments-4 nil (equal (eval (pyel "pyel_test_function_arguments_233(4)")) "[1, 2, 3, 4, [5], {}]"))
(ert-deftest pyel-test-function_arguments-5 nil (equal (eval (pyel "pyel_test_function_arguments_233(5)")) "[1, 2, 3, 4, [5, 6], {}]"))
(ert-deftest pyel-test-function_arguments-6 nil (equal (eval (pyel "pyel_test_function_arguments_233(6)")) "[1, 2, 3, 4, [5, 6], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-7 nil (equal (eval (pyel "pyel_test_function_arguments_233(7)")) "[1, 2, 3, 4, [5, 6], {y: 23, x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-8 nil (equal (eval (pyel "pyel_test_function_arguments_233(8)")) "[\"n\", 324, 1, \"two\", [], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-9 nil (equal (eval (pyel "pyel_test_function_arguments_233(9)")) "[\"n\", 324, 1, 2, [], {x: \"s\"}]"))
(ert-deftest pyel-test-objects-1 nil (equal (eval (pyel "pyel_test_objects_297(1)")) 5))
(ert-deftest pyel-test-objects-2 nil (equal (eval (pyel "pyel_test_objects_297(2)")) 6))
(ert-deftest pyel-test-objects-3 nil (equal (eval (pyel "pyel_test_objects_298(1)")) "tclass"))
(ert-deftest pyel-test-objects-4 nil (equal (eval (pyel "pyel_test_objects_298(2)")) (lambda (self) (getattr self a))))
(ert-deftest pyel-test-objects-5 nil (equal (eval (pyel "pyel_test_objects_298(3)")) (lambda (self n) (setattr self a n))))
(ert-deftest pyel-test-objects-6 nil (equal (eval (pyel "pyel_test_objects_298(4)")) 12))
(ert-deftest pyel-test-objects-7 nil (equal (eval (pyel "pyel_test_objects_298(5)")) "hi"))
(ert-deftest pyel-test-objects-8 nil (equal (eval (pyel "pyel_test_objects_298(6)")) 23))
(ert-deftest pyel-test-objects-9 nil (equal (eval (pyel "pyel_test_objects_298(7)")) 19))
(ert-deftest pyel-test-objects-10 nil (equal (eval (pyel "pyel_test_objects_298(8)")) (lambda (self) nil (pyel-+ (getattr self cvar) 5))))
(ert-deftest pyel-test-objects-11 nil (equal (eval (pyel "pyel_test_objects_298(9)")) "<class 'object'>"))
(ert-deftest pyel-test-objects-12 nil (equal (eval (pyel "pyel_test_objects_298(10)")) t))
(ert-deftest pyel-test-objects-13 nil (equal (eval (pyel "pyel_test_objects_298(11)")) "tclass"))
(ert-deftest pyel-test-objects-14 nil (equal (eval (pyel "pyel_test_objects_298(12)")) 14))
(ert-deftest pyel-test-objects-15 nil (equal (eval (pyel "pyel_test_objects_298(13)")) 2))
(ert-deftest pyel-test-objects-16 nil (equal (eval (pyel "pyel_test_objects_298(14)")) [4 12]))
(ert-deftest pyel-test-objects-17 nil (equal (eval (pyel "pyel_test_objects_298(15)")) 10))
(ert-deftest pyel-test-objects-18 nil (equal (eval (pyel "pyel_test_objects_298(16)")) 8))
(ert-deftest pyel-test-special_method_lookup-1 nil (equal (eval (pyel "pyel_test_special_method_lookup_299(1)")) 16))
(ert-deftest pyel-test-special_method_lookup-2 nil (equal (eval (pyel "pyel_test_special_method_lookup_299(2)")) "<bound method adder.__call__ of adder object at 0x18b071>"))
(ert-deftest pyel-test-special_method_lookup-3 nil (equal (eval (pyel "pyel_test_special_method_lookup_299(3)")) (lambda nil nil "hi")))
(ert-deftest pyel-test-len_function-3 nil (equal (eval (pyel "pyel_test_len_function_423(1)")) 4))
(ert-deftest pyel-test-len_function-4 nil (equal (eval (pyel "pyel_test_len_function_423(2)")) 0))
(ert-deftest pyel-test-len_function-5 nil (equal (eval (pyel "pyel_test_len_function_423(3)")) 3))
(ert-deftest pyel-test-len_function-6 nil (equal (eval (pyel "pyel_test_len_function_423(4)")) 4))
(ert-deftest pyel-test-list_function-1 nil (equal (eval (pyel "pyel_test_list_function_424()")) (quote ("5" "4" "3" "2" "1"))))
(ert-deftest pyel-test-list_function-3 nil (equal (eval (pyel "pyel_test_list_function_425(1)")) (quote ((1) 1))))
(ert-deftest pyel-test-list_function-4 nil (equal (eval (pyel "pyel_test_list_function_425(2)")) t))
(ert-deftest pyel-test-list_function-5 nil (equal (eval (pyel "pyel_test_list_function_426(1)")) nil))
(ert-deftest pyel-test-list_function-6 nil (equal (eval (pyel "pyel_test_list_function_426(2)")) t))
(ert-deftest pyel-test-list_function-7 nil (equal (eval (pyel "pyel_test_list_function_426(3)")) t))
(ert-deftest pyel-test-type-1 nil (equal (eval (pyel "pyel_test_type_427(1)")) "<class 'testc'>"))
(ert-deftest pyel-test-type-2 nil (equal (eval (pyel "pyel_test_type_427(2)")) t))
(ert-deftest pyel-test-abs_function-1 nil (equal (eval (pyel "pyel_test_abs_function_428()")) "hi"))
(ert-deftest pyel-test-append-1 nil (equal (eval (pyel "pyel_test_append_429(1)")) (quote (1 2 3 "hi"))))
(ert-deftest pyel-test-append-2 nil (equal (eval (pyel "pyel_test_append_429(2)")) t))
(ert-deftest pyel-test-append-3 nil (equal (eval (pyel "pyel_test_append_429(3)")) t))
(ert-deftest pyel-test-append-4 nil (equal (eval (pyel "pyel_test_append_429(4)")) t))
(ert-deftest pyel-test-insert-1 nil (equal (eval (pyel "pyel_test_insert_430(1)")) (quote (1 "hi" 2 3))))
(ert-deftest pyel-test-insert-2 nil (equal (eval (pyel "pyel_test_insert_430(2)")) t))
(ert-deftest pyel-test-index_method-1 nil (equal (eval (pyel "pyel_test_index_method_431(1)")) 0))
(ert-deftest pyel-test-index_method-2 nil (equal (eval (pyel "pyel_test_index_method_431(2)")) 2))
(ert-deftest pyel-test-index_method-3 nil (equal (eval (pyel "pyel_test_index_method_431(3)")) 3))
(ert-deftest pyel-test-index_method-4 nil (equal (eval (pyel "pyel_test_index_method_432()")) 3))
(ert-deftest pyel-test-index_method-5 nil (equal (eval (pyel "pyel_test_index_method_433(1)")) 5))
(ert-deftest pyel-test-index_method-6 nil (equal (eval (pyel "pyel_test_index_method_433(2)")) 3))
(ert-deftest pyel-test-index_method-7 nil (equal (eval (pyel "pyel_test_index_method_433(3)")) 14))
(ert-deftest pyel-test-index_method-8 nil (equal (eval (pyel "pyel_test_index_method_433(4)")) 0))
(ert-deftest pyel-test-index_method-9 nil (equal (eval (pyel "pyel_test_index_method_434(1)")) 0))
(ert-deftest pyel-test-index_method-10 nil (equal (eval (pyel "pyel_test_index_method_434(2)")) 1))
(ert-deftest pyel-test-index_method-11 nil (equal (eval (pyel "pyel_test_index_method_434(3)")) 2))
(ert-deftest pyel-test-remove_method-1 nil (equal (eval (pyel "pyel_test_remove_method_435()")) (quote (1 "2" "2"))))
(ert-deftest pyel-test-remove_method-2 nil (equal (eval (pyel "pyel_test_remove_method_436()")) (quote ("2" "2" [1]))))
(ert-deftest pyel-test-remove_method-3 nil (equal (eval (pyel "pyel_test_remove_method_437()")) (quote (1 "2" [1]))))
(ert-deftest pyel-test-remove_method-4 nil (equal (eval (pyel "pyel_test_remove_method_438()")) t))
(ert-deftest pyel-test-count_method-2 nil (equal (eval (pyel "pyel_test_count_method_439(1)")) 2))
(ert-deftest pyel-test-count_method-3 nil (equal (eval (pyel "pyel_test_count_method_439(2)")) 1))
(ert-deftest pyel-test-count_method-4 nil (equal (eval (pyel "pyel_test_count_method_439(3)")) 1))
(ert-deftest pyel-test-count_method-5 nil (equal (eval (pyel "pyel_test_count_method_439(4)")) 1))
(ert-deftest pyel-test-count_method-6 nil (equal (eval (pyel "pyel_test_count_method_440(1)")) 2))
(ert-deftest pyel-test-count_method-7 nil (equal (eval (pyel "pyel_test_count_method_440(2)")) 1))
(ert-deftest pyel-test-count_method-8 nil (equal (eval (pyel "pyel_test_count_method_440(3)")) 1))
(ert-deftest pyel-test-count_method-9 nil (equal (eval (pyel "pyel_test_count_method_440(4)")) 1))
(ert-deftest pyel-test-extend_method-1 nil (equal (eval (pyel "pyel_test_extend_method_441(1)")) t))
(ert-deftest pyel-test-extend_method-2 nil (equal (eval (pyel "pyel_test_extend_method_441(2)")) (quote (1 "5" "4" "3" "2" "1"))))
(ert-deftest pyel-test-extend_method-3 nil (equal (eval (pyel "pyel_test_extend_method_442(1)")) t))
(ert-deftest pyel-test-extend_method-4 nil (equal (eval (pyel "pyel_test_extend_method_442(2)")) (quote (1 "e" "x" "t" "e" "n" "d" "e" "d"))))
(ert-deftest pyel-test-extend_method-5 nil (equal (eval (pyel "pyel_test_extend_method_443(1)")) t))
(ert-deftest pyel-test-extend_method-6 nil (equal (eval (pyel "pyel_test_extend_method_443(2)")) (quote (1 1 "2" [3]))))
(ert-deftest pyel-test-extend_method-7 nil (equal (eval (pyel "pyel_test_extend_method_444(1)")) t))
(ert-deftest pyel-test-extend_method-8 nil (equal (eval (pyel "pyel_test_extend_method_444(2)")) (quote (1 1 "2" [3]))))
(ert-deftest pyel-test-pop_method-1 nil (equal (eval (pyel "pyel_test_pop_method_445(1)")) "two"))
(ert-deftest pyel-test-pop_method-2 nil (equal (eval (pyel "pyel_test_pop_method_445(2)")) "{1: \"one\", 3: \"three\"}"))
(ert-deftest pyel-test-pop_method-3 nil (equal (eval (pyel "pyel_test_pop_method_446(1)")) 4))
(ert-deftest pyel-test-pop_method-4 nil (equal (eval (pyel "pyel_test_pop_method_446(2)")) (quote (1))))
(ert-deftest pyel-test-pop_method-5 nil (equal (eval (pyel "pyel_test_pop_method_446(3)")) 1))
(ert-deftest pyel-test-pop_method-6 nil (equal (eval (pyel "pyel_test_pop_method_446(4)")) t))
(ert-deftest pyel-test-reverse_method-1 nil (equal (eval (pyel "pyel_test_reverse_method_447(1)")) (quote (3 2 1))))
(ert-deftest pyel-test-reverse_method-2 nil (equal (eval (pyel "pyel_test_reverse_method_447(2)")) t))
(ert-deftest pyel-test-lower_method-1 nil (equal (eval (pyel "pyel_test_lower_method_448(1)")) "ab"))
(ert-deftest pyel-test-lower_method-2 nil (equal (eval (pyel "pyel_test_lower_method_448(2)")) "aB"))
(ert-deftest pyel-test-upper_method-1 nil (equal (eval (pyel "pyel_test_upper_method_449(1)")) "AB"))
(ert-deftest pyel-test-upper_method-2 nil (equal (eval (pyel "pyel_test_upper_method_449(2)")) "aB"))
(ert-deftest pyel-test-split_method-1 nil (equal (eval (pyel "pyel_test_split_method_450(1)")) (quote ("a" "x" "b" "x" "d" "x"))))
(ert-deftest pyel-test-split_method-2 nil (equal (eval (pyel "pyel_test_split_method_450(2)")) 6))
(ert-deftest pyel-test-split_method-4 nil (equal (eval (pyel "pyel_test_split_method_451()")) (quote ("a" "b" "c"))))
(ert-deftest pyel-test-strip_method-1 nil (equal (eval (pyel "pyel_test_strip_method_452()")) "e"))
(ert-deftest pyel-test-get_method-1 nil (equal (eval (pyel "pyel_test_get_method_453(1)")) "one"))
(ert-deftest pyel-test-get_method-2 nil (equal (eval (pyel "pyel_test_get_method_453(2)")) t))
(ert-deftest pyel-test-get_method-3 nil (equal (eval (pyel "pyel_test_get_method_453(3)")) "three"))
(ert-deftest pyel-test-get_method-4 nil (equal (eval (pyel "pyel_test_get_method_453(4)")) "d"))
(ert-deftest pyel-test-items_method-1 nil (equal (eval (pyel "pyel_test_items_method_454(1)")) (quote ((3 "three") (2 "two") (1 "one")))))
(ert-deftest pyel-test-items_method-2 nil (equal (eval (pyel "pyel_test_items_method_454(2)")) (quote ((8 88)))))
(ert-deftest pyel-test-items_method-3 nil (equal (eval (pyel "pyel_test_items_method_454(3)")) nil))
(ert-deftest pyel-test-keys_method-1 nil (equal (eval (pyel "pyel_test_keys_method_455(1)")) (quote (3 2 1))))
(ert-deftest pyel-test-keys_method-2 nil (equal (eval (pyel "pyel_test_keys_method_455(2)")) (quote ((8)))))
(ert-deftest pyel-test-keys_method-3 nil (equal (eval (pyel "pyel_test_keys_method_455(3)")) nil))
(ert-deftest pyel-test-values_method-1 nil (equal (eval (pyel "pyel_test_values_method_456(1)")) (quote ("three" "two" "one"))))
(ert-deftest pyel-test-values_method-2 nil (equal (eval (pyel "pyel_test_values_method_456(2)")) (quote (88))))
(ert-deftest pyel-test-values_method-3 nil (equal (eval (pyel "pyel_test_values_method_456(3)")) nil))
(ert-deftest pyel-test-popitem_method-1 nil (equal (eval (pyel "pyel_test_popitem_method_457(1)")) (quote (1 "one"))))
(ert-deftest pyel-test-popitem_method-2 nil (equal (eval (pyel "pyel_test_popitem_method_457(2)")) "{2: \"two\", 3: \"three\"}"))
(ert-deftest pyel-test-copy_method-1 nil (equal (eval (pyel "pyel_test_copy_method_458(1)")) nil))
(ert-deftest pyel-test-copy_method-2 nil (equal (eval (pyel "pyel_test_copy_method_458(2)")) t))
(ert-deftest pyel-el-ast-test-conditional-expressions-422 nil (string= (pyel "1 if True else 0" nil nil t) "(if-exp (name  \"True\" 'load 1 5) (num 1 1 0) (num 0 1 15) 1 0)
"))
(ert-deftest pyel-py-ast-test-conditional-expressions-421 nil (equal (py-ast "1 if True else 0") "Module(body=[Expr(value=IfExp(test=Name(id='True', ctx=Load()), body=Num(n=1), orelse=Num(n=0)))])
"))
(ert-deftest pyel-transform-test-conditional-expressions-420 nil (equal (pyel "1 if True else 0") (quote (if t 1 0))))
(ert-deftest pyel-el-ast-test-conditional-expressions-419 nil (string= (pyel "true() if tst() else false()" nil nil t) "(if-exp (call  (name  \"tst\" 'load 1 10) nil nil nil nil 1 10) (call  (name  \"true\" 'load 1 0) nil nil nil nil 1 0) (call  (name  \"false\" 'load 1 21) nil nil nil nil 1 21) 1 0)
"))
(ert-deftest pyel-py-ast-test-conditional-expressions-418 nil (equal (py-ast "true() if tst() else false()") "Module(body=[Expr(value=IfExp(test=Call(func=Name(id='tst', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), body=Call(func=Name(id='true', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), orelse=Call(func=Name(id='false', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)))])
"))
(ert-deftest pyel-transform-test-conditional-expressions-417 nil (equal (pyel "true() if tst() else false()") (quote (if (pyel-fcall tst) (pyel-fcall true) (pyel-fcall false)))))
(ert-deftest pyel-el-ast-test-conditional-expressions-416 nil (string= (pyel "a[1] if a[2:2] else a[2]" nil nil t) "(if-exp (subscript (name  \"a\" 'load 1 8) (slice (num 2 1 10) (num 2 1 12) nil) 'load 1 8) (subscript (name  \"a\" 'load 1 0) (index (num 1 1 2) nil nil) 'load 1 0) (subscript (name  \"a\" 'load 1 20) (index (num 2 1 22) nil nil) 'load 1 20) 1 0)
"))
(ert-deftest pyel-py-ast-test-conditional-expressions-415 nil (equal (py-ast "a[1] if a[2:2] else a[2]") "Module(body=[Expr(value=IfExp(test=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=Num(n=2), step=None), ctx=Load()), body=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), orelse=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())))])
"))
(ert-deftest pyel-transform-test-conditional-expressions-414 nil (equal (pyel "a[1] if a[2:2] else a[2]") (quote (if (pyel-subscript-load-slice a 2 2 nil) (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2)))))
(ert-deftest pyel-el-ast-test-boolop-413 nil (string= (pyel "a or b" nil nil t) "(boolop or ((name  \"a\" 'load 1 0) (name  \"b\" 'load 1 5)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-412 nil (equal (py-ast "a or b") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-411 nil (equal (pyel "a or b") (quote (or a b))))
(ert-deftest pyel-el-ast-test-boolop-410 nil (string= (pyel "a or b or c" nil nil t) "(boolop or ((name  \"a\" 'load 1 0) (name  \"b\" 'load 1 5) (name  \"c\" 'load 1 10)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-409 nil (equal (py-ast "a or b or c") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-408 nil (equal (pyel "a or b or c") (quote (or a b c))))
(ert-deftest pyel-el-ast-test-boolop-407 nil (string= (pyel "a.c or b.c() or a[2]" nil nil t) "(boolop or ((attribute  (name  \"a\" 'load 1 0) \"c\" 'load 1 0) (call  (attribute  (name  \"b\" 'load 1 7) \"c\" 'load 1 7) nil nil nil nil 1 7) (subscript (name  \"a\" 'load 1 16) (index (num 2 1 18) nil nil) 'load 1 16)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-406 nil (equal (py-ast "a.c or b.c() or a[2]") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-405 nil (equal (pyel "a.c or b.c() or a[2]") (quote (or (getattr a c) (call-method b c) (pyel-subscript-load-index a 2)))))
(ert-deftest pyel-el-ast-test-boolop-404 nil (string= (pyel "a and b" nil nil t) "(boolop and ((name  \"a\" 'load 1 0) (name  \"b\" 'load 1 6)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-403 nil (equal (py-ast "a and b") "Module(body=[Expr(value=BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-402 nil (equal (pyel "a and b") (quote (and a b))))
(ert-deftest pyel-el-ast-test-boolop-401 nil (string= (pyel "a and b or c" nil nil t) "(boolop or ((boolop and ((name  \"a\" 'load 1 0) (name  \"b\" 'load 1 6)) 1 0) (name  \"c\" 'load 1 11)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-400 nil (equal (py-ast "a and b or c") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]), Name(id='c', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-399 nil (equal (pyel "a and b or c") (quote (or (and a b) c))))
(ert-deftest pyel-el-ast-test-boolop-398 nil (string= (pyel "a[2] and b.f() or c.e" nil nil t) "(boolop or ((boolop and ((subscript (name  \"a\" 'load 1 0) (index (num 2 1 2) nil nil) 'load 1 0) (call  (attribute  (name  \"b\" 'load 1 9) \"f\" 'load 1 9) nil nil nil nil 1 9)) 1 0) (attribute  (name  \"c\" 'load 1 18) \"e\" 'load 1 18)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-397 nil (equal (py-ast "a[2] and b.f() or c.e") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-boolop-396 nil (equal (pyel "a[2] and b.f() or c.e") (quote (or (and (pyel-subscript-load-index a 2) (call-method b f)) (getattr c e)))))
(ert-deftest pyel-el-ast-test-boolop-395 nil (string= (pyel "a.e and b[2] or c.e() and 2 " nil nil t) "(boolop or ((boolop and ((attribute  (name  \"a\" 'load 1 0) \"e\" 'load 1 0) (subscript (name  \"b\" 'load 1 8) (index (num 2 1 10) nil nil) 'load 1 8)) 1 0) (boolop and ((call  (attribute  (name  \"c\" 'load 1 16) \"e\" 'load 1 16) nil nil nil nil 1 16) (num 2 1 26)) 1 16)) 1 0)
"))
(ert-deftest pyel-py-ast-test-boolop-394 nil (equal (py-ast "a.e and b[2] or c.e() and 2 ") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]), BoolOp(op=And(), values=[Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Num(n=2)])]))])
"))
(ert-deftest pyel-transform-test-boolop-393 nil (equal (pyel "a.e and b[2] or c.e() and 2 ") (quote (or (and (getattr a e) (pyel-subscript-load-index b 2)) (and (call-method c e) 2)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-392 nil (string= (pyel "[x*x for x in range(10)]" nil nil t) "(list-comp (bin-op  (name  \"x\" 'load 1 1) * (name  \"x\" 'load 1 3) 1 1) ((comprehension (name  \"x\" 'store 1 9) (call  (name  \"range\" 'load 1 14) ((num 10 1 20)) nil nil nil 1 14) ())) 1 1)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-391 nil (equal (py-ast "[x*x for x in range(10)]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])
"))
(ert-deftest pyel-transform-test-list-comprehensions-390 nil (equal (pyel "[x*x for x in range(10)]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-389 nil (string= (pyel "[x*x for x in range(10) if x > 5]" nil nil t) "(list-comp (bin-op  (name  \"x\" 'load 1 1) * (name  \"x\" 'load 1 3) 1 1) ((comprehension (name  \"x\" 'store 1 9) (call  (name  \"range\" 'load 1 14) ((num 10 1 20)) nil nil nil 1 14) ((compare  (name  \"x\" 'load 1 27) (\">\") ((num 5 1 31)) 1 27)))) 1 1)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-388 nil (equal (py-ast "[x*x for x in range(10) if x > 5]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)])])]))])
"))
(ert-deftest pyel-transform-test-list-comprehensions-387 nil (equal (pyel "[x*x for x in range(10) if x > 5]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) if (pyel-> x 5) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-386 nil (string= (pyel "[x*x for x in range(10) if x > 5 if x < 8]" nil nil t) "(list-comp (bin-op  (name  \"x\" 'load 1 1) * (name  \"x\" 'load 1 3) 1 1) ((comprehension (name  \"x\" 'store 1 9) (call  (name  \"range\" 'load 1 14) ((num 10 1 20)) nil nil nil 1 14) ((compare  (name  \"x\" 'load 1 27) (\">\") ((num 5 1 31)) 1 27) (compare  (name  \"x\" 'load 1 36) (\"<\") ((num 8 1 40)) 1 36)))) 1 1)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-385 nil (equal (py-ast "[x*x for x in range(10) if x > 5 if x < 8]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)]), Compare(left=Name(id='x', ctx=Load()), ops=[Lt()], comparators=[Num(n=8)])])]))])
"))
(ert-deftest pyel-transform-test-list-comprehensions-384 nil (equal (pyel "[x*x for x in range(10) if x > 5 if x < 8]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) if (and (pyel-> x 5) (pyel-< x 8)) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-383 nil (string= (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]" nil nil t) "(assert  (compare  (list-comp (tuple  ((name  \"x\" 'load 1 9) (name  \"y\" 'load 1 12)) 'load 1 9) ((comprehension (name  \"x\" 'store 1 19) (list ((num 1 1 25) (num 2 1 27) (num 3 1 29)) 'load 1 24) ()) (comprehension (name  \"y\" 'store 1 36) (list ((num 3 1 42) (num 1 1 44) (num 4 1 46)) 'load 1 41) ((compare  (name  \"x\" 'load 1 52) (\"!=\") ((name  \"y\" 'load 1 57)) 1 52)))) 1 8) (\"==\") ((list ((tuple  ((num 1 1 65) (num 3 1 68)) 'load 1 65) (tuple  ((num 1 1 73) (num 4 1 76)) 'load 1 73) (tuple  ((num 2 1 81) (num 3 1 84)) 'load 1 81) (tuple  ((num 2 1 89) (num 1 1 92)) 'load 1 89) (tuple  ((num 2 1 97) (num 4 1 100)) 'load 1 97) (tuple  ((num 3 1 105) (num 1 1 108)) 'load 1 105) (tuple  ((num 3 1 113) (num 4 1 116)) 'load 1 113)) 'load 1 63)) 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-382 nil (equal (py-ast "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]") "Module(body=[Assert(test=Compare(left=ListComp(elt=Tuple(elts=[Name(id='x', ctx=Load()), Name(id='y', ctx=Load())], ctx=Load()), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load()), ifs=[]), comprehension(target=Name(id='y', ctx=Store()), iter=List(elts=[Num(n=3), Num(n=1), Num(n=4)], ctx=Load()), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[NotEq()], comparators=[Name(id='y', ctx=Load())])])]), ops=[Eq()], comparators=[List(elts=[Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=1), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=4)], ctx=Load())], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-list-comprehensions-381 nil (equal (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]") (quote (assert (pyel-== (let ((__list__ nil)) (loop for x in (py-list (list 1 2 3)) do (loop for y in (py-list (list 3 1 4)) if (pyel-!= x y) do (setq __list__ (cons (vector x y) __list__)))) (reverse __list__)) (list (vector 1 3) (vector 1 4) (vector 2 3) (vector 2 1) (vector 2 4) (vector 3 1) (vector 3 4))) t nil))))
(ert-deftest pyel-el-ast-test-list-comprehensions-380 nil (string= (pyel "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]" nil nil t) "(assign  ((name  \"matrix\" 'store 2 0)) (list ((list ((num 1 2 11) (num 2 2 14) (num 3 2 17) (num 4 2 20)) 'load 2 10) (list ((num 5 2 24) (num 6 2 27) (num 7 2 30) (num 8 2 33)) 'load 2 23) (list ((num 9 2 37) (num 10 2 40) (num 11 2 44) (num 12 2 48)) 'load 2 36)) 'load 2 9) 2 0)
(assign  ((name  \"_x\" 'store 3 0)) (list-comp (list-comp (subscript (name  \"row\" 'load 3 7) (index (name  \"i\" 'load 3 11) nil nil) 'load 3 7) ((comprehension (name  \"row\" 'store 3 18) (name  \"matrix\" 'load 3 25) ())) 3 7) ((comprehension (name  \"i\" 'store 3 37) (call  (name  \"range\" 'load 3 42) ((num 4 3 48)) nil nil nil 3 42) ())) 3 6) 3 0)
(assert  (compare  (name  \"_x\" 'load 4 7) (\"==\") ((list ((list ((num 1 4 15) (num 5 4 18) (num 9 4 21)) 'load 4 14) (list ((num 2 4 26) (num 6 4 29) (num 10 4 32)) 'load 4 25) (list ((num 3 4 38) (num 7 4 41) (num 11 4 44)) 'load 4 37) (list ((num 4 4 50) (num 8 4 53) (num 12 4 56)) 'load 4 49)) 'load 4 13)) 4 7) nil 4 0)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-379 nil (equal (py-ast "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]") "Module(body=[Assign(targets=[Name(id='matrix', ctx=Store())], value=List(elts=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load()), List(elts=[Num(n=5), Num(n=6), Num(n=7), Num(n=8)], ctx=Load()), List(elts=[Num(n=9), Num(n=10), Num(n=11), Num(n=12)], ctx=Load())], ctx=Load())), Assign(targets=[Name(id='_x', ctx=Store())], value=ListComp(elt=ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])]), generators=[comprehension(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Name(id='_x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-list-comprehensions-378 nil (equal (pyel "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]") (quote (progn (pyel-set matrix (list (list 1 2 3 4) (list 5 6 7 8) (list 9 10 11 12))) (pyel-set -x (let ((__list__ nil)) (loop for i in (py-list (pyel-fcall py-range 4)) do (setq __list__ (cons (let ((__list__ nil)) (loop for row in (py-list matrix) do (setq __list__ (cons (pyel-subscript-load-index row i) __list__))) (reverse __list__)) __list__))) (reverse __list__))) (assert (pyel-== -x (list (list 1 5 9) (list 2 6 10) (list 3 7 11) (list 4 8 12))) t nil)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-377 nil (string= (pyel "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
" nil nil t) "(assign  ((name  \"transposed\" 'store 2 0)) (list nil 'load 2 13) 2 0)
(for  (name  \"i\" 'store 3 4) (call  (name  \"range\" 'load 3 9) ((num 4 3 15)) nil nil nil 3 9) ((call  (attribute  (name  \"transposed\" 'load 4 1) \"append\" 'load 4 1) ((list-comp (subscript (name  \"row\" 'load 4 20) (index (name  \"i\" 'load 4 24) nil nil) 'load 4 20) ((comprehension (name  \"row\" 'store 4 31) (name  \"matrix\" 'load 4 38) ())) 4 20)) nil nil nil 4 1)) nil 3 0)
(assert  (compare  (name  \"transposed\" 'load 5 7) (\"==\") ((list ((list ((num 1 5 23) (num 5 5 26) (num 9 5 29)) 'load 5 22) (list ((num 2 5 34) (num 6 5 37) (num 10 5 40)) 'load 5 33) (list ((num 3 5 46) (num 7 5 49) (num 11 5 52)) 'load 5 45) (list ((num 4 5 58) (num 8 5 61) (num 12 5 64)) 'load 5 57)) 'load 5 21)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-376 nil (equal (py-ast "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
") "Module(body=[Assign(targets=[Name(id='transposed', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), body=[Expr(value=Call(func=Attribute(value=Name(id='transposed', ctx=Load()), attr='append', ctx=Load()), args=[ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])])], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='transposed', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-list-comprehensions-375 nil (equal (pyel "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
") (quote (progn (pyel-set transposed (list)) (py-for i in (pyel-fcall py-range 4) (pyel-append-method->2<- transposed (let ((__list__ nil)) (loop for row in (py-list matrix) do (setq __list__ (cons (pyel-subscript-load-index row i) __list__))) (reverse __list__)))) (assert (pyel-== transposed (list (list 1 5 9) (list 2 6 10) (list 3 7 11) (list 4 8 12))) t nil)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-374 nil (string= (pyel "{x: [y*y for y in range(x)] for x in range(20)}" nil nil t) "(dict-comp (name  \"x\" 'load 1 1) (list-comp (bin-op  (name  \"y\" 'load 1 5) * (name  \"y\" 'load 1 7) 1 5) ((comprehension (name  \"y\" 'store 1 13) (call  (name  \"range\" 'load 1 18) ((name  \"x\" 'load 1 24)) nil nil nil 1 18) ())) 1 5) ((comprehension (name  \"x\" 'store 1 32) (call  (name  \"range\" 'load 1 37) ((num 20 1 43)) nil nil nil 1 37) ())) 1 1)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-373 nil (equal (py-ast "{x: [y*y for y in range(x)] for x in range(20)}") "Module(body=[Expr(value=DictComp(key=Name(id='x', ctx=Load()), value=ListComp(elt=BinOp(left=Name(id='y', ctx=Load()), op=Mult(), right=Name(id='y', ctx=Load())), generators=[comprehension(target=Name(id='y', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ifs=[])]), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=20)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])
"))
(ert-deftest pyel-transform-test-list-comprehensions-372 nil (equal (pyel "{x: [y*y for y in range(x)] for x in range(20)}") (quote (let ((__dict__ (make-hash-table :test (quote equal)))) (loop for x in (py-list (pyel-fcall py-range 20)) do (puthash x (let ((__list__ nil)) (loop for y in (py-list (pyel-fcall py-range x)) do (setq __list__ (cons (pyel-* y y) __list__))) (reverse __list__)) __dict__)) __dict__))))
(ert-deftest pyel-el-ast-test-list-comprehensions-371 nil (string= (pyel "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (dict-comp (name  \"x\" 'load 1 5) (call  (name  \"number_to_string\" 'load 1 8) ((name  \"x\" 'load 1 25)) nil nil nil 1 8) ((comprehension (name  \"x\" 'store 1 32) (call  (name  \"range\" 'load 1 37) ((num 10 1 43)) nil nil nil 1 37) ())) 1 5) 1 0)
(assert  (compare  (call  (name  \"hash_table_count\" 'load 2 7) ((name  \"x\" 'load 2 24)) nil nil nil 2 7) (\"==\") ((num 10 2 30)) 2 7) nil 2 0)
(assert  (compare  (subscript (name  \"x\" 'load 3 7) (index (num 1 3 9) nil nil) 'load 3 7) (\"==\") ((str \"1\" 3 15)) 3 7) nil 3 0)
(assert  (compare  (subscript (name  \"x\" 'load 4 7) (index (num 9 4 9) nil nil) 'load 4 7) (\"==\") ((str \"9\" 4 15)) 4 7) nil 4 0)
"))
(ert-deftest pyel-py-ast-test-list-comprehensions-370 nil (equal (py-ast "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=DictComp(key=Name(id='x', ctx=Load()), value=Call(func=Name(id='number_to_string', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Call(func=Name(id='hash_table_count', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=10)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='1')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=9)), ctx=Load()), ops=[Eq()], comparators=[Str(s='9')]), msg=None)])
"))
(ert-deftest pyel-transform-test-list-comprehensions-369 nil (equal (pyel "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
") (quote (progn (pyel-set x (let ((__dict__ (make-hash-table :test (quote equal)))) (loop for x in (py-list (pyel-fcall py-range 10)) do (puthash x (pyel-fcall number-to-string x) __dict__)) __dict__)) (assert (pyel-== (pyel-fcall hash-table-count x) 10) t nil) (assert (pyel-== (pyel-subscript-load-index x 1) "1") t nil) (assert (pyel-== (pyel-subscript-load-index x 9) "9") t nil)))))
(ert-deftest pyel-el-ast-test-try-368 nil (string= (pyel "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (str \"\" 1 4) 1 0)
(try ((bin-op  (num 1 3 1) / (num 0 3 5) 3 1) (assign  ((name  \"x\" 'store 4 1)) (str \"yes\" 4 5) 4 1)) ((except-handler nil nil ((assign  ((name  \"x\" 'store 6 1)) (str \"no\" 6 5) 6 1)) 5 0)) () 2 0)
(assert  (compare  (name  \"x\" 'load 7 7) (\"==\") ((str \"no\" 7 12)) 7 7) nil 7 0)
"))
(ert-deftest pyel-py-ast-test-try-367 nil (equal (py-ast "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='')), TryExcept(body=[Expr(value=BinOp(left=Num(n=1), op=Div(), right=Num(n=0))), Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='yes'))], handlers=[ExceptHandler(type=None, name=None, body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='no'))])], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Str(s='no')]), msg=None)])
"))
(ert-deftest pyel-transform-test-try-366 nil (equal (pyel "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'") (quote (progn (pyel-set x "") (condition-case nil (pyel-/ 1 0) (pyel-set x "yes") (error (pyel-set x "no"))) (assert (pyel-== x "no") t nil)))))
(ert-deftest pyel-el-ast-test-try-365 nil (string= (pyel "try:
 _a()
except:
 try:
  _x()
 except:
  _b()" nil nil t) "(try ((call  (name  \"_a\" 'load 2 1) nil nil nil nil 2 1)) ((except-handler nil nil ((try ((call  (name  \"_x\" 'load 5 2) nil nil nil nil 5 2)) ((except-handler nil nil ((call  (name  \"_b\" 'load 7 2) nil nil nil nil 7 2)) 6 1)) () 4 1)) 3 0)) () 1 0)
"))
(ert-deftest pyel-py-ast-test-try-364 nil (equal (py-ast "try:
 _a()
except:
 try:
  _x()
 except:
  _b()") "Module(body=[TryExcept(body=[Expr(value=Call(func=Name(id='_a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[TryExcept(body=[Expr(value=Call(func=Name(id='_x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[Expr(value=Call(func=Name(id='_b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])], orelse=[])])
"))
(ert-deftest pyel-transform-test-try-363 nil (equal (pyel "try:
 _a()
except:
 try:
  _x()
 except:
  _b()") (quote (condition-case nil (pyel-fcall -a) (error (condition-case nil (pyel-fcall -x) (error (pyel-fcall -b))))))))
(ert-deftest pyel-el-ast-test-aug-assign-362 nil (string= (pyel "a += b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) + (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-361 nil (equal (py-ast "a += b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Add(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-360 nil (equal (pyel "a += b") (quote (pyel-set a (pyel-+ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-359 nil (string= (pyel "a -= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) - (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-358 nil (equal (py-ast "a -= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Sub(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-357 nil (equal (pyel "a -= b") (quote (pyel-set a (pyel-- a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-356 nil (string= (pyel "a /= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) / (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-355 nil (equal (py-ast "a /= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Div(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-354 nil (equal (pyel "a /= b") (quote (pyel-set a (pyel-/ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-353 nil (string= (pyel "a *= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) * (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-352 nil (equal (py-ast "a *= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Mult(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-351 nil (equal (pyel "a *= b") (quote (pyel-set a (pyel-* a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-350 nil (string= (pyel "a **= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) ** (name  \"b\" 'load 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-349 nil (equal (py-ast "a **= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Pow(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-348 nil (equal (pyel "a **= b") (quote (pyel-set a (pyel-** a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-347 nil (string= (pyel "a ^= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) ^ (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-346 nil (equal (py-ast "a ^= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitXor(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-345 nil (equal (pyel "a ^= b") (quote (pyel-set a (pyel-^ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-344 nil (string= (pyel "a |= b" nil nil t) "(aug-assign (name  \"a\" 'store 1 0) | (name  \"b\" 'load 1 5) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-343 nil (equal (py-ast "a |= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitOr(), value=Name(id='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-342 nil (equal (pyel "a |= b") (quote (pyel-set a (pyel-| a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-341 nil (string= (pyel "a = 3
  b = 4
  a += b + 1
  assert a == 8" nil nil t) "PYEL ERROR"))
(ert-deftest pyel-py-ast-test-aug-assign-340 nil (equal (py-ast "a = 3
  b = 4
  a += b + 1
  assert a == 8") "Traceback (most recent call last):
  File \"/tmp/pyel-ast.py\", line 5, in <module>
    assert a == 8\"\"\")))
  File \"/usr/lib/python3.2/ast.py\", line 36, in parse
    return compile(source, filename, mode, PyCF_ONLY_AST)
  File \"<unknown>\", line 2
    b = 4
    ^
IndentationError: unexpected indent
"))
(ert-deftest pyel-transform-test-aug-assign-339 nil (equal (pyel "a = 3
  b = 4
  a += b + 1
  assert a == 8") (quote "PYEL ERROR")))
(ert-deftest pyel-el-ast-test-aug-assign-338 nil (string= (pyel "a.b += a[2]" nil nil t) "(aug-assign (attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0) + (subscript (name  \"a\" 'load 1 7) (index (num 2 1 9) nil nil) 'load 1 7) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-337 nil (equal (py-ast "a.b += a[2]") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-336 nil (equal (pyel "a.b += a[2]") (quote (setattr a b (pyel-+ (getattr a b) (pyel-subscript-load-index a 2))))))
(ert-deftest pyel-el-ast-test-aug-assign-335 nil (string= (pyel "a.b += 4" nil nil t) "(aug-assign (attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0) + (num 4 1 7) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-334 nil (equal (py-ast "a.b += 4") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Num(n=4))])
"))
(ert-deftest pyel-transform-test-aug-assign-333 nil (equal (pyel "a.b += 4") (quote (setattr a b (pyel-+ (getattr a b) 4)))))
(ert-deftest pyel-el-ast-test-aug-assign-332 nil (string= (pyel "a.b += d.e" nil nil t) "(aug-assign (attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0) + (attribute  (name  \"d\" 'load 1 7) \"e\" 'load 1 7) 1 0)
"))
(ert-deftest pyel-py-ast-test-aug-assign-331 nil (equal (py-ast "a.b += d.e") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-aug-assign-330 nil (equal (pyel "a.b += d.e") (quote (setattr a b (pyel-+ (getattr a b) (getattr d e))))))
(ert-deftest pyel-el-ast-test-lambda-329 nil (string= (pyel "lambda x,y,z=4,*g: print(z);x()" nil nil t) "(lambda ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4 1 13)) nil )) ((call  (name  \"print\" 'load 1 19) ((name  \"z\" 'load 1 25)) nil nil nil 1 19)) 1 0)
(call  (name  \"x\" 'load 1 28) nil nil nil nil 1 28)
"))
(ert-deftest pyel-py-ast-test-lambda-328 nil (equal (py-ast "lambda x,y,z=4,*g: print(z);x()") "Module(body=[Expr(value=Lambda(args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))), Expr(value=Call(func=Name(id='x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-lambda-327 nil (equal (pyel "lambda x,y,z=4,*g: print(z);x()") (quote (progn (lambda (x y &optional z &rest g) nil (setq z (or z 4)) (py-print nil nil nil z)) (pyel-fcall x)))))
(ert-deftest pyel-el-ast-test-lambda-326 nil (string= (pyel "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (call  (name  \"range\" 'load 1 4) ((num 2 1 10) (num 9 1 13)) nil nil nil 1 4) 1 0)
(assign  ((name  \"x2\" 'store 2 0)) (call  (name  \"reduce\" 'load 2 5) ((lambda ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((bin-op  (name  \"a\" 'load 2 23) + (name  \"b\" 'load 2 25) 2 23)) 2 12) (name  \"x\" 'load 2 28)) nil nil nil 2 5) 2 0)
(assert  (compare  (name  \"x2\" 'load 3 7) (\"==\") ((num 35 3 13)) 3 7) nil 3 0)
"))
(ert-deftest pyel-py-ast-test-lambda-325 nil (equal (py-ast "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='range', ctx=Load()), args=[Num(n=2), Num(n=9)], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='x2', ctx=Store())], value=Call(func=Name(id='reduce', ctx=Load()), args=[Lambda(args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load()))), Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x2', ctx=Load()), ops=[Eq()], comparators=[Num(n=35)]), msg=None)])
"))
(ert-deftest pyel-transform-test-lambda-324 nil (equal (pyel "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35") (quote (progn (pyel-set x (pyel-fcall py-range 2 9)) (pyel-set x2 (pyel-fcall reduce (lambda (a b) nil (pyel-+ a b)) x)) (assert (pyel-== x2 35) t nil)))))
(ert-deftest pyel-el-ast-test-global-323 nil (string= (pyel "def a():
 global x
 x = 3
 y = 1" nil nil t) "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x) 2 1) (assign  ((name  \"x\" 'store 3 1)) (num 3 3 5) 3 1) (assign  ((name  \"y\" 'store 4 1)) (num 1 4 5) 4 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-global-322 nil (equal (py-ast "def a():
 global x
 x = 3
 y = 1") "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=3)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-global-321 nil (equal (pyel "def a():
 global x
 x = 3
 y = 1") (quote (def a nil nil (let (y) (pyel-set x 3) (pyel-set y 1))))))
(ert-deftest pyel-el-ast-test-global-320 nil (string= (pyel "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (num 1 1 4) 1 0)
(assign  ((name  \"y\" 'store 2 0)) (num 1 2 4) 2 0)
(def \" func \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x) 4 1) (assign  ((name  \"x\" 'store 5 1)) (num 7 5 5) 5 1) (assign  ((name  \"y\" 'store 6 1)) (num 7 6 5) 6 1)) nil nil 3 0 )
(call  (name  \"func\" 'load 7 0) nil nil nil nil 7 0)
(assert  (compare  (name  \"x\" 'load 8 7) (\"==\") ((num 7 8 12)) 8 7) nil 8 0)
(assert  (compare  (name  \"y\" 'load 9 7) (\"==\") ((num 1 9 12)) 9 7) nil 9 0)
"))
(ert-deftest pyel-py-ast-test-global-319 nil (equal (py-ast "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=1)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1)), FunctionDef(name='func', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=7)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=7))], decorator_list=[], returns=None), Expr(value=Call(func=Name(id='func', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Num(n=7)]), msg=None), Assert(test=Compare(left=Name(id='y', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)]), msg=None)])
"))
(ert-deftest pyel-transform-test-global-318 nil (equal (pyel "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
") (quote (progn (pyel-set x 1) (pyel-set y 1) (def func nil nil (let (y) (pyel-set x 7) (pyel-set y 7))) (pyel-fcall func) (assert (pyel-== x 7) t nil) (assert (pyel-== y 1) t nil)))))
(ert-deftest pyel-el-ast-test-for-loop-317 nil (string= (pyel "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10" nil nil t) "(assign  ((name  \"b\" 'store 1 0)) (list ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11)) 'load 1 4) 1 0)
(assign  ((name  \"c\" 'store 2 0)) (num 0 2 4) 2 0)
(for  (name  \"a\" 'store 3 4) (name  \"b\" 'load 3 9) ((assign  ((name  \"c\" 'store 4 1)) (bin-op  (name  \"c\" 'load 4 5) + (name  \"a\" 'load 4 9) 4 5) 4 1)) nil 3 0)
(assert  (compare  (name  \"c\" 'load 5 7) (\"==\") ((num 10 5 10)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-for-loop-316 nil (equal (py-ast "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10") "Module(body=[Assign(targets=[Name(id='b', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Name(id='c', ctx=Store())], value=Num(n=0)), For(target=Name(id='a', ctx=Store()), iter=Name(id='b', ctx=Load()), body=[Assign(targets=[Name(id='c', ctx=Store())], value=BinOp(left=Name(id='c', ctx=Load()), op=Add(), right=Name(id='a', ctx=Load())))], orelse=[]), Assert(test=Compare(left=Name(id='c', ctx=Load()), ops=[Eq()], comparators=[Num(n=10)]), msg=None)])
"))
(ert-deftest pyel-transform-test-for-loop-315 nil (equal (pyel "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10") (quote (progn (pyel-set b (list 1 2 3 4)) (pyel-set c 0) (py-for a in b (pyel-set c (pyel-+ c a))) (assert (pyel-== c 10) t nil)))))
(ert-deftest pyel-el-ast-test-for-loop-314 nil (string= (pyel "for i in range(n):
 break" nil nil t) "(for  (name  \"i\" 'store 1 4) (call  (name  \"range\" 'load 1 9) ((name  \"n\" 'load 1 15)) nil nil nil 1 9) ((break 2 1)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-for-loop-313 nil (equal (py-ast "for i in range(n):
 break") "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Break()], orelse=[])])
"))
(ert-deftest pyel-transform-test-for-loop-312 nil (equal (pyel "for i in range(n):
 break") (quote (py-for i in (pyel-fcall py-range n) (break)))))
(ert-deftest pyel-el-ast-test-for-loop-311 nil (string= (pyel "for i in range(n):
 continue" nil nil t) "(for  (name  \"i\" 'store 1 4) (call  (name  \"range\" 'load 1 9) ((name  \"n\" 'load 1 15)) nil nil nil 1 9) ((continue 2 1)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-for-loop-310 nil (equal (py-ast "for i in range(n):
 continue") "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Continue()], orelse=[])])
"))
(ert-deftest pyel-transform-test-for-loop-309 nil (equal (pyel "for i in range(n):
 continue") (quote (py-for i in (pyel-fcall py-range n) (continue)))))
(ert-deftest pyel-el-ast-test-for-loop-308 nil (string= (pyel "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (list nil 'load 1 4) 1 0)
(for  (name  \"i\" 'store 2 4) (call  (name  \"range\" 'load 2 9) ((num 5 2 15)) nil nil nil 2 9) ((if  (compare  (name  \"i\" 'load 3 4) (\"==\") ((num 2 3 9)) 3 4) ((continue 4 2)) nil 3 1) (call  (attribute  (name  \"x\" 'load 5 1) \"append\" 'load 5 1) ((name  \"i\" 'load 5 10)) nil nil nil 5 1)) nil 2 0)
(assert  (compare  (name  \"x\" 'load 6 7) (\"==\") ((list ((num 0 6 13) (num 1 6 15) (num 3 6 17) (num 4 6 19)) 'load 6 12)) 6 7) nil 6 0)
"))
(ert-deftest pyel-py-ast-test-for-loop-307 nil (equal (py-ast "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=5)], keywords=[], starargs=None, kwargs=None), body=[If(test=Compare(left=Name(id='i', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), body=[Continue()], orelse=[]), Expr(value=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='append', ctx=Load()), args=[Name(id='i', ctx=Load())], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=0), Num(n=1), Num(n=3), Num(n=4)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-for-loop-306 nil (equal (pyel "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]") (quote (progn (pyel-set x (list)) (py-for i in (pyel-fcall py-range 5) (if (pyel-== i 2) (continue)) (pyel-append-method->2<- x i)) (assert (pyel-== x (list 0 1 3 4)) t nil)))))
(ert-deftest pyel-el-ast-test-assert-305 nil (string= (pyel "assert sldk()" nil nil t) "(assert  (call  (name  \"sldk\" 'load 1 7) nil nil nil nil 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-assert-304 nil (equal (py-ast "assert sldk()") "Module(body=[Assert(test=Call(func=Name(id='sldk', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), msg=None)])
"))
(ert-deftest pyel-transform-test-assert-303 nil (equal (pyel "assert sldk()") (quote (assert (pyel-fcall sldk) t nil))))
(ert-deftest pyel-el-ast-test-assert-302 nil (string= (pyel "assert adk,'messsage'" nil nil t) "(assert  (name  \"adk\" 'load 1 7) (str \"messsage\" 1 11) 1 0)
"))
(ert-deftest pyel-py-ast-test-assert-301 nil (equal (py-ast "assert adk,'messsage'") "Module(body=[Assert(test=Name(id='adk', ctx=Load()), msg=Str(s='messsage'))])
"))
(ert-deftest pyel-transform-test-assert-300 nil (equal (pyel "assert adk,'messsage'") (quote (assert adk t "messsage"))))
(ert-deftest pyel-el-ast-test-subscript-296 nil (string= (pyel "a = '1X23'
assert a[1] == 'X'" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (str \"1X23\" 1 4) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (index (num 1 2 9) nil nil) 'load 2 7) (\"==\") ((str \"X\" 2 15)) 2 7) nil 2 0)
"))
(ert-deftest pyel-py-ast-test-subscript-295 nil (equal (py-ast "a = '1X23'
assert a[1] == 'X'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='1X23')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='X')]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-294 nil (equal (pyel "a = '1X23'
assert a[1] == 'X'") (quote (progn (pyel-set a "1X23") (assert (pyel-== (pyel-subscript-load-index a 1) "X") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-293 nil (string= (pyel "a = [1,2,3,4]
assert a[1] == 2" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (list ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11)) 'load 1 4) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (index (num 1 2 9) nil nil) 'load 2 7) (\"==\") ((num 2 2 15)) 2 7) nil 2 0)
"))
(ert-deftest pyel-py-ast-test-subscript-292 nil (equal (py-ast "a = [1,2,3,4]
assert a[1] == 2") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-291 nil (equal (pyel "a = [1,2,3,4]
assert a[1] == 2") (quote (progn (pyel-set a (list 1 2 3 4)) (assert (pyel-== (pyel-subscript-load-index a 1) 2) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-290 nil (string= (pyel "a = (1,2,3,4)
assert a[1] == 2" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (tuple  ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11)) 'load 1 5) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (index (num 1 2 9) nil nil) 'load 2 7) (\"==\") ((num 2 2 15)) 2 7) nil 2 0)
"))
(ert-deftest pyel-py-ast-test-subscript-289 nil (equal (py-ast "a = (1,2,3,4)
assert a[1] == 2") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-288 nil (equal (pyel "a = (1,2,3,4)
assert a[1] == 2") (quote (progn (pyel-set a (vector 1 2 3 4)) (assert (pyel-== (pyel-subscript-load-index a 1) 2) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-287 nil (string= (pyel "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5" nil nil t) "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"value\" 'load 3 9) + (num 4 3 17) 3 9) 3 2)) nil nil 2 1 )) nil 1 0)
(assign  ((name  \"x\" 'store 4 0)) (call  (name  \"a\" 'load 4 4) nil nil nil nil 4 4) 4 0)
(assert  (compare  (subscript (name  \"x\" 'load 5 7) (index (num 1 5 9) nil nil) 'load 5 7) (\"==\") ((num 5 5 15)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-subscript-286 nil (equal (py-ast "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='value', ctx=Load()), op=Add(), right=Num(n=4)))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-285 nil (equal (pyel "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5") (quote (progn (define-class a nil (def --getitem-- (self value) nil (pyel-+ value 4))) (pyel-set x (pyel-fcall a)) (assert (pyel-== (pyel-subscript-load-index x 1) 5) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-284 nil (string= (pyel "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (tuple  ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11) (num 5 1 13)) 'load 1 5) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (slice (num 1 2 9) (num 4 2 11) nil) 'load 2 7) (\"==\") ((tuple  ((num 2 2 18) (num 3 2 20) (num 4 2 22)) 'load 2 18)) 2 7) nil 2 0)
(assert  (compare  (subscript (name  \"a\" 'load 3 7) (slice 0 (num 4 3 10) nil) 'load 3 7) (\"==\") ((tuple  ((num 1 3 17) (num 2 3 19) (num 3 3 21) (num 4 3 23)) 'load 3 17)) 3 7) nil 3 0)
(assert  (compare  (subscript (name  \"a\" 'load 4 7) (slice (num 2 4 9) nil nil) 'load 4 7) (\"==\") ((tuple  ((num 3 4 17) (num 4 4 19) (num 5 4 21)) 'load 4 17)) 4 7) nil 4 0)
(assert  (compare  (subscript (name  \"a\" 'load 5 7) (slice 0 nil nil) 'load 5 7) (\"==\") ((tuple  ((num 1 5 16) (num 2 5 18) (num 3 5 20) (num 4 5 22) (num 5 5 24)) 'load 5 16)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-subscript-283 nil (equal (py-ast "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-282 nil (equal (pyel "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)") (quote (progn (pyel-set a (vector 1 2 3 4 5)) (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) (vector 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) (vector 1 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) (vector 3 4 5)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) (vector 1 2 3 4 5)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-281 nil (string= (pyel "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (list ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11) (num 5 1 13)) 'load 1 4) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (slice (num 1 2 9) (num 4 2 11) nil) 'load 2 7) (\"==\") ((list ((num 2 2 18) (num 3 2 20) (num 4 2 22)) 'load 2 17)) 2 7) nil 2 0)
(assert  (compare  (subscript (name  \"a\" 'load 3 7) (slice 0 (num 4 3 10) nil) 'load 3 7) (\"==\") ((list ((num 1 3 17) (num 2 3 19) (num 3 3 21) (num 4 3 23)) 'load 3 16)) 3 7) nil 3 0)
(assert  (compare  (subscript (name  \"a\" 'load 4 7) (slice (num 2 4 9) nil nil) 'load 4 7) (\"==\") ((list ((num 3 4 17) (num 4 4 19) (num 5 4 21)) 'load 4 16)) 4 7) nil 4 0)
(assert  (compare  (subscript (name  \"a\" 'load 5 7) (slice 0 nil nil) 'load 5 7) (\"==\") ((list ((num 1 5 16) (num 2 5 18) (num 3 5 20) (num 4 5 22) (num 5 5 24)) 'load 5 15)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-subscript-280 nil (equal (py-ast "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-279 nil (equal (pyel "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]") (quote (progn (pyel-set a (list 1 2 3 4 5)) (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) (list 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) (list 1 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) (list 3 4 5)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) (list 1 2 3 4 5)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-278 nil (string= (pyel "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (str \"012345678\" 1 4) 1 0)
(assert  (compare  (subscript (name  \"a\" 'load 2 7) (slice (num 1 2 9) (num 4 2 11) nil) 'load 2 7) (\"==\") ((str \"123\" 2 17)) 2 7) nil 2 0)
(assert  (compare  (subscript (name  \"a\" 'load 3 7) (slice 0 (num 4 3 10) nil) 'load 3 7) (\"==\") ((str \"0123\" 3 16)) 3 7) nil 3 0)
(assert  (compare  (subscript (name  \"a\" 'load 4 7) (slice (num 2 4 9) nil nil) 'load 4 7) (\"==\") ((str \"2345678\" 4 16)) 4 7) nil 4 0)
(assert  (compare  (subscript (name  \"a\" 'load 5 7) (slice 0 nil nil) 'load 5 7) (\"==\") ((str \"012345678\" 5 15)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-subscript-277 nil (equal (py-ast "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='012345678')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='0123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='2345678')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='012345678')]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-276 nil (equal (pyel "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'") (quote (progn (pyel-set a "012345678") (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) "123") t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) "0123") t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) "2345678") t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) "012345678") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-275 nil (string= (pyel "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12" nil nil t) "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (attribute  (name  \"value\" 'load 3 9) \"start\" 'load 3 9) + (attribute  (name  \"value\" 'load 3 23) \"end\" 'load 3 23) 3 9) 3 2)) nil nil 2 1 )) nil 1 0)
(assign  ((name  \"x\" 'store 4 0)) (call  (name  \"a\" 'load 4 4) nil nil nil nil 4 4) 4 0)
(assert  (compare  (subscript (name  \"x\" 'load 5 7) (slice (num 1 5 9) (num 2 5 11) nil) 'load 5 7) (\"==\") ((num 3 5 17)) 5 7) nil 5 0)
(assert  (compare  (subscript (name  \"x\" 'load 6 7) (slice (num 5 6 9) (num 7 6 11) nil) 'load 6 7) (\"==\") ((num 12 6 17)) 6 7) nil 6 0)
"))
(ert-deftest pyel-py-ast-test-subscript-274 nil (equal (py-ast "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Attribute(value=Name(id='value', ctx=Load()), attr='start', ctx=Load()), op=Add(), right=Attribute(value=Name(id='value', ctx=Load()), attr='end', ctx=Load())))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=2), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=5), upper=Num(n=7), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=12)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-273 nil (equal (pyel "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12") (quote (progn (define-class a nil (def --getitem-- (self value) nil (pyel-+ (getattr value start) (getattr value end)))) (pyel-set x (pyel-fcall a)) (assert (pyel-== (pyel-subscript-load-slice x 1 2 nil) 3) t nil) (assert (pyel-== (pyel-subscript-load-slice x 5 7 nil) 12) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-272 nil (string= (pyel "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'" nil nil t) "(def \" __add \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"a\" 'load 2 8) + (name  \"b\" 'load 2 10) 2 8) 2 1)) nil nil 1 0 )
(assign  ((name  \"a\" 'store 3 0)) (list ((num 1 3 5) (num 2 3 7) (num 3 3 9) (num 4 3 11)) 'load 3 4) 3 0)
(assign  ((subscript (name  \"a\" 'load 4 0) (index (num 0 4 2) nil nil) 'store 4 0)) (call  (name  \"__add\" 'load 4 7) ((subscript (name  \"a\" 'load 4 13) (index (num 1 4 15) nil nil) 'load 4 13) (subscript (name  \"a\" 'load 4 18) (index (num 2 4 20) nil nil) 'load 4 18)) nil nil nil 4 7) 4 0)
(assert  (compare  (subscript (name  \"a\" 'load 5 7) (index (num 0 5 9) nil nil) 'load 5 7) (\"==\") ((num 5 5 15)) 5 7) nil 5 0)
(assign  ((subscript (name  \"a\" 'load 6 0) (index (num 2 6 2) nil nil) 'store 6 0)) (str \"str\" 6 7) 6 0)
(assert  (compare  (subscript (name  \"a\" 'load 7 7) (index (num 2 7 9) nil nil) 'load 7 7) (\"==\") ((str \"str\" 7 15)) 7 7) nil 7 0)
"))
(ert-deftest pyel-py-ast-test-subscript-271 nil (equal (py-ast "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'") "Module(body=[FunctionDef(name='__add', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], decorator_list=[], returns=None), Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=Call(func=Name(id='__add', ctx=Load()), args=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-270 nil (equal (pyel "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'") (quote (progn (def --add (a b) nil (pyel-+ a b)) (pyel-set a (list 1 2 3 4)) (pyel-subscript-store-index a 0 (pyel-fcall --add (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2))) (assert (pyel-== (pyel-subscript-load-index a 0) 5) t nil) (pyel-subscript-store-index a 2 "str") (assert (pyel-== (pyel-subscript-load-index a 2) "str") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-269 nil (string= (pyel "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (tuple  ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11)) 'load 1 5) 1 0)
(assign  ((subscript (name  \"a\" 'load 2 0) (index (num 0 2 2) nil nil) 'store 2 0)) (bin-op  (subscript (name  \"a\" 'load 2 7) (index (num 1 2 9) nil nil) 'load 2 7) + (subscript (name  \"a\" 'load 2 14) (index (num 2 2 16) nil nil) 'load 2 14) 2 7) 2 0)
(assert  (compare  (subscript (name  \"aa\" 'load 3 7) (index (num 0 3 10) nil nil) 'load 3 7) (\"==\") ((num 5 3 16)) 3 7) nil 3 0)
(assign  ((subscript (name  \"a\" 'load 4 0) (index (num 2 4 2) nil nil) 'store 4 0)) (str \"str\" 4 7) 4 0)
(assert  (compare  (subscript (name  \"a\" 'load 5 7) (index (num 2 5 9) nil nil) 'load 5 7) (\"==\") ((str \"str\" 5 15)) 5 7) nil 5 0)
"))
(ert-deftest pyel-py-ast-test-subscript-268 nil (equal (py-ast "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=BinOp(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), op=Add(), right=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))), Assert(test=Compare(left=Subscript(value=Name(id='aa', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-267 nil (equal (pyel "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'") (quote (progn (pyel-set a (vector 1 2 3 4)) (pyel-subscript-store-index a 0 (pyel-+ (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2))) (assert (pyel-== (pyel-subscript-load-index aa 0) 5) t nil) (pyel-subscript-store-index a 2 "str") (assert (pyel-== (pyel-subscript-load-index a 2) "str") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-266 nil (string= (pyel "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5" nil nil t) "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load 3 2) \"index\" 'store 3 2)) (name  \"index\" 'load 3 15) 3 2) (assign  ((attribute  (name  \"self\" 'load 4 2) \"value\" 'store 4 2)) (name  \"value\" 'load 4 15) 4 2)) nil nil 2 1 )) nil 1 0)
(assign  ((name  \"x\" 'store 5 0)) (call  (name  \"a\" 'load 5 4) nil nil nil nil 5 4) 5 0)
(assign  ((subscript (name  \"x\" 'load 6 0) (index (num 3 6 2) nil nil) 'store 6 0)) (num 5 6 7) 6 0)
(assert  (compare  (attribute  (name  \"x\" 'load 7 7) \"index\" 'load 7 7) (\"==\") ((num 3 7 18)) 7 7) nil 7 0)
(assert  (compare  (attribute  (name  \"x\" 'load 8 7) \"value\" 'load 8 7) (\"==\") ((num 5 8 18)) 8 7) nil 8 0)
"))
(ert-deftest pyel-py-ast-test-subscript-265 nil (equal (py-ast "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__setitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='index', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='index', ctx=Store())], value=Name(id='index', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='value', ctx=Store())], value=Name(id='value', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Store())], value=Num(n=5)), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='index', ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='value', ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-264 nil (equal (pyel "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5") (quote (progn (define-class a nil (def --setitem-- (self index value) nil (setattr self index index) (setattr self value value))) (pyel-set x (pyel-fcall a)) (pyel-subscript-store-index x 3 5) (assert (pyel-== (getattr x index) 3) t nil) (assert (pyel-== (getattr x value) 5) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-263 nil (string= (pyel "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (list ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11) (num 5 1 13) (num 6 1 15)) 'load 1 4) 1 0)
(assign  ((subscript (name  \"a\" 'load 2 0) (slice (num 1 2 2) (num 4 2 4) nil) 'store 2 0)) (list ((num 5 2 10) (num 4 2 12) (str \"f\" 2 14)) 'load 2 9) 2 0)
(assert  (compare  (name  \"a\" 'load 3 7) (\"==\") ((list ((num 1 3 13) (num 5 3 15) (num 4 3 17) (str \"f\" 3 19) (num 5 3 23) (num 6 3 25)) 'load 3 12)) 3 7) nil 3 0)
(assign  ((subscript (name  \"a\" 'load 4 0) (slice 0 (num 3 4 3) nil) 'store 4 0)) (list ((str \"a\" 4 9) (num 4 4 13) (num 2.2 4 15)) 'load 4 8) 4 0)
(assert  (compare  (name  \"a\" 'load 5 7) (\"==\") ((list ((str \"a\" 5 13) (num 4 5 17) (num 2.2 5 19) (str \"f\" 5 23) (num 5 5 27) (num 6 5 29)) 'load 5 12)) 5 7) nil 5 0)
(assign  ((subscript (name  \"a\" 'load 6 0) (slice (num 3 6 2) nil nil) 'store 6 0)) (list ((num 3 6 9) (num 3 6 11)) 'load 6 8) 6 0)
(assert  (compare  (name  \"a\" 'load 7 7) (\"==\") ((list ((str \"a\" 7 13) (num 4 7 18) (num 2.2 7 21) (num 3 7 26) (num 3 7 29) (num 6 7 32)) 'load 7 12)) 7 7) nil 7 0)
"))
(ert-deftest pyel-py-ast-test-subscript-262 nil (equal (py-ast "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=List(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=List(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=List(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-261 nil (equal (pyel "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]") (quote (progn (pyel-set a (list 1 2 3 4 5 6)) (pyel-subscript-store-slice a 1 4 nil (list 5 4 "f")) (assert (pyel-== a (list 1 5 4 "f" 5 6)) t nil) (pyel-subscript-store-slice a 0 3 nil (list "a" 4 2.2)) (assert (pyel-== a (list "a" 4 2.2 "f" 5 6)) t nil) (pyel-subscript-store-slice a 3 nil nil (list 3 3)) (assert (pyel-== a (list "a" 4 2.2 3 3 6)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-260 nil (string= (pyel "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (tuple  ((num 1 1 5) (num 2 1 7) (num 3 1 9) (num 4 1 11) (num 5 1 13) (num 6 1 15)) 'load 1 5) 1 0)
(assign  ((subscript (name  \"a\" 'load 2 0) (slice (num 1 2 2) (num 4 2 4) nil) 'store 2 0)) (tuple  ((num 5 2 10) (num 4 2 12) (str \"f\" 2 14)) 'load 2 10) 2 0)
(assert  (compare  (name  \"a\" 'load 3 7) (\"==\") ((tuple  ((num 1 3 13) (num 5 3 15) (num 4 3 17) (str \"f\" 3 19) (num 5 3 23) (num 6 3 25)) 'load 3 13)) 3 7) nil 3 0)
(assign  ((subscript (name  \"a\" 'load 4 0) (slice 0 (num 3 4 3) nil) 'store 4 0)) (tuple  ((str \"a\" 4 9) (num 4 4 13) (num 2.2 4 15)) 'load 4 9) 4 0)
(assert  (compare  (name  \"a\" 'load 5 7) (\"==\") ((tuple  ((str \"a\" 5 13) (num 4 5 17) (num 2.2 5 19) (str \"f\" 5 23) (num 5 5 27) (num 6 5 29)) 'load 5 13)) 5 7) nil 5 0)
(assign  ((subscript (name  \"a\" 'load 6 0) (slice (num 3 6 2) nil nil) 'store 6 0)) (tuple  ((num 3 6 9) (num 3 6 11)) 'load 6 9) 6 0)
(assert  (compare  (name  \"a\" 'load 7 7) (\"==\") ((tuple  ((str \"a\" 7 13) (num 4 7 18) (num 2.2 7 21) (num 3 7 26) (num 3 7 29) (num 6 7 32)) 'load 7 13)) 7 7) nil 7 0)
"))
(ert-deftest pyel-py-ast-test-subscript-259 nil (equal (py-ast "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Tuple(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Tuple(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-258 nil (equal (pyel "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)") (quote (progn (pyel-set a (vector 1 2 3 4 5 6)) (pyel-subscript-store-slice a 1 4 nil (vector 5 4 "f")) (assert (pyel-== a (vector 1 5 4 "f" 5 6)) t nil) (pyel-subscript-store-slice a 0 3 nil (vector "a" 4 2.2)) (assert (pyel-== a (vector "a" 4 2.2 "f" 5 6)) t nil) (pyel-subscript-store-slice a 3 nil nil (vector 3 3)) (assert (pyel-== a (vector "a" 4 2.2 3 3 6)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-257 nil (string= (pyel "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (str \"123456\" 1 4) 1 0)
(assign  ((subscript (name  \"a\" 'load 2 0) (slice (num 1 2 2) (num 4 2 4) nil) 'store 2 0)) (str \"54f\" 2 9) 2 0)
(assert  (compare  (name  \"a\" 'load 3 7) (\"==\") ((str \"154f56\" 3 12)) 3 7) nil 3 0)
(assign  ((subscript (name  \"a\" 'load 4 0) (slice 0 (num 3 4 3) nil) 'store 4 0)) (str \"a42\" 4 8) 4 0)
(assert  (compare  (name  \"a\" 'load 5 7) (\"==\") ((str \"a42f56\" 5 12)) 5 7) nil 5 0)
(assign  ((subscript (name  \"a\" 'load 6 0) (slice (num 3 6 2) nil nil) 'store 6 0)) (str \"33\" 6 8) 6 0)
(assert  (compare  (name  \"a\" 'load 7 7) (\"==\") ((str \"a42336\" 7 12)) 7 7) nil 7 0)
"))
(ert-deftest pyel-py-ast-test-subscript-256 nil (equal (py-ast "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='123456')), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Str(s='54f')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='154f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Str(s='a42')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Str(s='33')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42336')]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-255 nil (equal (pyel "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'") (quote (progn (pyel-set a "123456") (pyel-subscript-store-slice a 1 4 nil "54f") (assert (pyel-== a "154f56") t nil) (pyel-subscript-store-slice a 0 3 nil "a42") (assert (pyel-== a "a42f56") t nil) (pyel-subscript-store-slice a 3 nil nil "33") (assert (pyel-== a "a42336") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-254 nil (string= (pyel "class a:
 def __setitem__ (self, index, value):
  self.start = index.start
  self.end = index.end
  self.step = index.step
  self.value = value
x = a()
x[2:3] = [1,2,3]
assert x.start == 2
assert x.end == 3
assert x.value == [1,2,3]" nil nil t) "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load 3 2) \"start\" 'store 3 2)) (attribute  (name  \"index\" 'load 3 15) \"start\" 'load 3 15) 3 2) (assign  ((attribute  (name  \"self\" 'load 4 2) \"end\" 'store 4 2)) (attribute  (name  \"index\" 'load 4 13) \"end\" 'load 4 13) 4 2) (assign  ((attribute  (name  \"self\" 'load 5 2) \"step\" 'store 5 2)) (attribute  (name  \"index\" 'load 5 14) \"step\" 'load 5 14) 5 2) (assign  ((attribute  (name  \"self\" 'load 6 2) \"value\" 'store 6 2)) (name  \"value\" 'load 6 15) 6 2)) nil nil 2 1 )) nil 1 0)
(assign  ((name  \"x\" 'store 7 0)) (call  (name  \"a\" 'load 7 4) nil nil nil nil 7 4) 7 0)
(assign  ((subscript (name  \"x\" 'load 8 0) (slice (num 2 8 2) (num 3 8 4) nil) 'store 8 0)) (list ((num 1 8 10) (num 2 8 12) (num 3 8 14)) 'load 8 9) 8 0)
(assert  (compare  (attribute  (name  \"x\" 'load 9 7) \"start\" 'load 9 7) (\"==\") ((num 2 9 18)) 9 7) nil 9 0)
(assert  (compare  (attribute  (name  \"x\" 'load 10 7) \"end\" 'load 10 7) (\"==\") ((num 3 10 16)) 10 7) nil 10 0)
(assert  (compare  (attribute  (name  \"x\" 'load 11 7) \"value\" 'load 11 7) (\"==\") ((list ((num 1 11 19) (num 2 11 21) (num 3 11 23)) 'load 11 18)) 11 7) nil 11 0)
"))
(ert-deftest pyel-py-ast-test-subscript-253 nil (equal (py-ast "class a:
 def __setitem__ (self, index, value):
  self.start = index.start
  self.end = index.end
  self.step = index.step
  self.value = value
x = a()
x[2:3] = [1,2,3]
assert x.start == 2
assert x.end == 3
assert x.value == [1,2,3]") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__setitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='index', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='start', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='start', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='end', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='end', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='step', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='step', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='value', ctx=Store())], value=Name(id='value', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=2), upper=Num(n=3), step=None), ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='start', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='end', ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='value', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-252 nil (equal (pyel "class a:
 def __setitem__ (self, index, value):
  self.start = index.start
  self.end = index.end
  self.step = index.step
  self.value = value
x = a()
x[2:3] = [1,2,3]
assert x.start == 2
assert x.end == 3
assert x.value == [1,2,3]") (quote (progn (define-class a nil (def --setitem-- (self index value) nil (setattr self start (getattr index start)) (setattr self end (getattr index end)) (setattr self step (getattr index step)) (setattr self value value))) (pyel-set x (pyel-fcall a)) (pyel-subscript-store-slice x 2 3 nil (list 1 2 3)) (assert (pyel-== (getattr x start) 2) t nil) (assert (pyel-== (getattr x end) 3) t nil) (assert (pyel-== (getattr x value) (list 1 2 3)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-251 nil (string= (pyel "a[2] += 3" nil nil t) "(aug-assign (subscript (name  \"a\" 'load 1 0) (index (num 2 1 2) nil nil) 'store 1 0) + (num 3 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-subscript-250 nil (equal (py-ast "a[2] += 3") "Module(body=[AugAssign(target=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), op=Add(), value=Num(n=3))])
"))
(ert-deftest pyel-transform-test-subscript-249 nil (equal (pyel "a[2] += 3") (quote (pyel-subscript-store-index a 2 (pyel-+ (pyel-subscript-load-index a 2) 3)))))
(ert-deftest pyel-el-ast-test-subscript-248 nil (string= (pyel "a[2] += b[3]" nil nil t) "(aug-assign (subscript (name  \"a\" 'load 1 0) (index (num 2 1 2) nil nil) 'store 1 0) + (subscript (name  \"b\" 'load 1 8) (index (num 3 1 10) nil nil) 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-subscript-247 nil (equal (py-ast "a[2] += b[3]") "Module(body=[AugAssign(target=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), op=Add(), value=Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Load()))])
"))
(ert-deftest pyel-transform-test-subscript-246 nil (equal (pyel "a[2] += b[3]") (quote (pyel-subscript-store-index a 2 (pyel-+ (pyel-subscript-load-index a 2) (pyel-subscript-load-index b 3))))))
(ert-deftest pyel-el-ast-test-subscript-245 nil (string= (pyel "[2,3,3][2]" nil nil t) "(subscript (list ((num 2 1 1) (num 3 1 3) (num 3 1 5)) 'load 1 0) (index (num 2 1 8) nil nil) 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-subscript-244 nil (equal (py-ast "[2,3,3][2]") "Module(body=[Expr(value=Subscript(value=List(elts=[Num(n=2), Num(n=3), Num(n=3)], ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))])
"))
(ert-deftest pyel-transform-test-subscript-243 nil (equal (pyel "[2,3,3][2]") (quote (pyel-subscript-load-index (list 2 3 3) 2))))
(ert-deftest pyel-el-ast-test-subscript-242 nil (string= (pyel "assert [1,2,(3,2,8)][2][2] == 8" nil nil t) "(assert  (compare  (subscript (subscript (list ((num 1 1 8) (num 2 1 10) (tuple  ((num 3 1 13) (num 2 1 15) (num 8 1 17)) 'load 1 13)) 'load 1 7) (index (num 2 1 21) nil nil) 'load 1 7) (index (num 2 1 24) nil nil) 'load 1 7) (\"==\") ((num 8 1 30)) 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-subscript-241 nil (equal (py-ast "assert [1,2,(3,2,8)][2][2] == 8") "Module(body=[Assert(test=Compare(left=Subscript(value=Subscript(value=List(elts=[Num(n=1), Num(n=2), Tuple(elts=[Num(n=3), Num(n=2), Num(n=8)], ctx=Load())], ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Num(n=8)]), msg=None)])
"))
(ert-deftest pyel-transform-test-subscript-240 nil (equal (pyel "assert [1,2,(3,2,8)][2][2] == 8") (quote (assert (pyel-== (pyel-subscript-load-index (pyel-subscript-load-index (list 1 2 (vector 3 2 8)) 2) 2) 8) t nil))))
(ert-deftest pyel-el-ast-test-binop-239 nil (string= (pyel "assert 1//2 == 0" nil nil t) "(assert  (compare  (bin-op  (num 1 1 7) // (num 2 1 10) 1 7) (\"==\") ((num 0 1 15)) 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-binop-238 nil (equal (py-ast "assert 1//2 == 0") "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=FloorDiv(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])
"))
(ert-deftest pyel-transform-test-binop-237 nil (equal (pyel "assert 1//2 == 0") (quote (assert (pyel-== (pyel-// 1 2) 0) t nil))))
(ert-deftest pyel-el-ast-test-binop-236 nil (string= (pyel "assert 1/2 == 0.5" nil nil t) "(assert  (compare  (bin-op  (num 1 1 7) / (num 2 1 9) 1 7) (\"==\") ((num 0.5 1 14)) 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-binop-235 nil (equal (py-ast "assert 1/2 == 0.5") "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=Div(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0.5)]), msg=None)])
"))
(ert-deftest pyel-transform-test-binop-234 nil (equal (pyel "assert 1/2 == 0.5") (quote (assert (pyel-== (pyel-/ 1 2) 0.5) t nil))))
(ert-deftest pyel-el-ast-test-def-232 nil (string= (pyel "def a(b,c):
  print('ok')
  a=b" nil nil t) "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((call  (name  \"print\" 'load 2 2) ((str \"ok\" 2 8)) nil nil nil 2 2) (assign  ((name  \"a\" 'store 3 2)) (name  \"b\" 'load 3 4) 3 2)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-231 nil (equal (py-ast "def a(b,c):
  print('ok')
  a=b") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='ok')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-230 nil (equal (pyel "def a(b,c):
  print('ok')
  a=b") (quote (def a (b c) nil (let (a) (py-print nil nil nil "ok") (pyel-set a b))))))
(ert-deftest pyel-el-ast-test-def-229 nil (string= (pyel "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]" nil nil t) "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((if  (compare  (name  \"a\" 'load 2 6) (\"==\") ((call  (name  \"b\" 'load 2 9) nil nil nil nil 2 9)) 2 6) ((call  (name  \"c\" 'load 3 4) nil nil nil nil 3 4) (while  (compare  (name  \"a\" 'load 4 11) (\"<\") ((attribute  (name  \"d\" 'load 4 15) \"b\" 'load 4 15)) 4 11) ((assign  ((tuple  ((name  \"b\" 'store 5 6) (name  \"c\" 'store 5 8)) 'store 5 6)) (tuple  ((num 1 5 12) (num 3 5 14)) 'load 5 12) 5 6)) nil 4 4)) nil 2 2) (assign  ((attribute  (attribute  (name  \"a\" 'load 6 2) \"b\" 'load 6 2) \"c\" 'store 6 2)) (list ((name  \"a\" 'load 6 11) (tuple  ((num 2 6 14) (num 2 6 16)) 'load 6 14)) 'load 6 10) 6 2)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-228 nil (equal (py-ast "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), body=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Attribute(value=Name(id='d', ctx=Load()), attr='b', ctx=Load())]), body=[Assign(targets=[Tuple(elts=[Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()))], orelse=[])], orelse=[]), Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Num(n=2), Num(n=2)], ctx=Load())], ctx=Load()))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-227 nil (equal (pyel "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]") (quote (def a (b c) nil (if (pyel-== a (pyel-fcall b)) (progn (pyel-fcall c) (while (pyel-< a (getattr d b)) (let ((__1__ 1) (__2__ 3)) (pyel-set b __1__) (pyel-set c __2__))))) (setattr (getattr a b) c (list a (vector 2 2)))))))
(ert-deftest pyel-el-ast-test-def-226 nil (string= (pyel "def a():
  return time()" nil nil t) "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((return (call  (name  \"time\" 'load 2 9) nil nil nil nil 2 9) 2 2)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-225 nil (equal (py-ast "def a():
  return time()") "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=Call(func=Name(id='time', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-224 nil (equal (pyel "def a():
  return time()") (quote (def a nil nil (pyel-fcall time)))))
(ert-deftest pyel-el-ast-test-def-223 nil (string= (pyel "def a(x,y=2,z=4):
 print(z)" nil nil t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 2 1 10) (num 4 1 14)) nil )) ((call  (name  \"print\" 'load 2 1) ((name  \"z\" 'load 2 7)) nil nil nil 2 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-222 nil (equal (py-ast "def a(x,y=2,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-221 nil (equal (pyel "def a(x,y=2,z=4):
 print(z)") (quote (def a (x &optional y z) nil (setq z (or z 4)) (setq y (or y 2)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-220 nil (string= (pyel "def a(x=1,y=2,z=4):
 print(z)" nil nil t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 1 1 8) (num 2 1 12) (num 4 1 16)) nil )) ((call  (name  \"print\" 'load 2 1) ((name  \"z\" 'load 2 7)) nil nil nil 2 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-219 nil (equal (py-ast "def a(x=1,y=2,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1), Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-218 nil (equal (pyel "def a(x=1,y=2,z=4):
 print(z)") (quote (def a (&optional x y z) nil (setq z (or z 4)) (setq y (or y 2)) (setq x (or x 1)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-217 nil (string= (pyel "def a(x,y,z=4):
 print(z)" nil nil t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 4 1 12)) nil )) ((call  (name  \"print\" 'load 2 1) ((name  \"z\" 'load 2 7)) nil nil nil 2 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-216 nil (equal (py-ast "def a(x,y,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-215 nil (equal (pyel "def a(x,y,z=4):
 print(z)") (quote (def a (x y &optional z) nil (setq z (or z 4)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-214 nil (string= (pyel "def a(x,y,z=4,*g):
 print(z)" nil nil t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4 1 12)) nil )) ((call  (name  \"print\" 'load 2 1) ((name  \"z\" 'load 2 7)) nil nil nil 2 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-213 nil (equal (py-ast "def a(x,y,z=4,*g):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-212 nil (equal (pyel "def a(x,y,z=4,*g):
 print(z)") (quote (def a (x y &optional z &rest g) nil (setq z (or z 4)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-211 nil (string= (pyel "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4" nil nil t) "(def \" pyel_test \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) c nil nil nil nil ((num 1 1 18)) nil )) ((if  (name  \"ab\" 'load 2 4) ((assign  ((name  \"x\" 'store 3 2)) (bin-op  (name  \"a\" 'load 3 6) + (name  \"b\" 'load 3 8) 3 6) 3 2)) nil 2 1) (assign  ((name  \"y\" 'store 4 1)) (num 3 4 5) 4 1) (call  (name  \"_a_\" 'load 5 1) nil nil nil nil 5 1) (assign  ((attribute  (name  \"z\" 'load 6 1) \"a\" 'store 6 1)) (num 4 6 7) 6 1)) nil nil 1 0 )
"))
(ert-deftest pyel-py-ast-test-def-210 nil (equal (py-ast "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4") "Module(body=[FunctionDef(name='pyel_test', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg='c', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1)], kw_defaults=[]), body=[If(test=Name(id='ab', ctx=Load()), body=[Assign(targets=[Name(id='x', ctx=Store())], value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], orelse=[]), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=3)), Expr(value=Call(func=Name(id='_a_', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Attribute(value=Name(id='z', ctx=Load()), attr='a', ctx=Store())], value=Num(n=4))], decorator_list=[], returns=None)])
"))
(ert-deftest pyel-transform-test-def-209 nil (equal (pyel "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4") (quote (def pyel-test (a &optional b &rest c) nil (setq b (or b 1)) (let (x y) (if ab (pyel-set x (pyel-+ a b))) (pyel-set y 3) (pyel-fcall -a-) (setattr z a 4))))))
(ert-deftest pyel-el-ast-test-while-208 nil (string= (pyel "while (a==b):
  print('hi')" nil nil t) "(while  (compare  (name  \"a\" 'load 1 7) (\"==\") ((name  \"b\" 'load 1 10)) 1 7) ((call  (name  \"print\" 'load 2 2) ((str \"hi\" 2 8)) nil nil nil 2 2)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-while-207 nil (equal (py-ast "while (a==b):
  print('hi')") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None))], orelse=[])])
"))
(ert-deftest pyel-transform-test-while-206 nil (equal (pyel "while (a==b):
  print('hi')") (quote (while (pyel-== a b) (py-print nil nil nil "hi")))))
(ert-deftest pyel-el-ast-test-while-205 nil (string= (pyel "while (a==b):
  print('hi')
  a=b" nil nil t) "(while  (compare  (name  \"a\" 'load 1 7) (\"==\") ((name  \"b\" 'load 1 10)) 1 7) ((call  (name  \"print\" 'load 2 2) ((str \"hi\" 2 8)) nil nil nil 2 2) (assign  ((name  \"a\" 'store 3 2)) (name  \"b\" 'load 3 4) 3 2)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-while-204 nil (equal (py-ast "while (a==b):
  print('hi')
  a=b") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])
"))
(ert-deftest pyel-transform-test-while-203 nil (equal (pyel "while (a==b):
  print('hi')
  a=b") (quote (while (pyel-== a b) (py-print nil nil nil "hi") (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-while-202 nil (string= (pyel "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b" nil nil t) "(while  (compare  (name  \"a\" 'load 1 7) (\"==\") ((name  \"b\" 'load 1 10)) 1 7) ((while  (compare  (name  \"a\" 'load 2 9) (\">\") ((num 2 2 11)) 2 9) ((call  (name  \"b\" 'load 3 4) ((num 3 3 6) (list ((name  \"a\" 'load 3 9) (num 2 3 11)) 'load 3 8)) nil nil nil 3 4) (assign  ((name  \"b\" 'store 4 4)) (attribute  (name  \"c\" 'load 4 6) \"e\" 'load 4 6) 4 4)) nil 2 2) (assign  ((name  \"a\" 'store 5 2)) (name  \"b\" 'load 5 4) 5 2)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-while-201 nil (equal (py-ast "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Num(n=2)]), body=[Expr(value=Call(func=Name(id='b', ctx=Load()), args=[Num(n=3), List(elts=[Name(id='a', ctx=Load()), Num(n=2)], ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))], orelse=[]), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])
"))
(ert-deftest pyel-transform-test-while-200 nil (equal (pyel "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b") (quote (while (pyel-== a b) (while (pyel-> a 2) (pyel-fcall b 3 (list a 2)) (pyel-set b (getattr c e))) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-while-199 nil (string= (pyel "while a:
 if b:
  break
 else:
  c()" nil nil t) "(while  (name  \"a\" 'load 1 6) ((if  (name  \"b\" 'load 2 4) ((break 3 2)) ((call  (name  \"c\" 'load 5 2) nil nil nil nil 5 2)) 2 1)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-while-198 nil (equal (py-ast "while a:
 if b:
  break
 else:
  c()") "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Break()], orelse=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])
"))
(ert-deftest pyel-transform-test-while-197 nil (equal (pyel "while a:
 if b:
  break
 else:
  c()") (quote (while a (if b nil)))))
(ert-deftest pyel-el-ast-test-while-196 nil (string= (pyel "while a:
 if b:
  continue
 c()" nil nil t) "(while  (name  \"a\" 'load 1 6) ((if  (name  \"b\" 'load 2 4) ((continue 3 2)) nil 2 1) (call  (name  \"c\" 'load 4 1) nil nil nil nil 4 1)) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-while-195 nil (equal (py-ast "while a:
 if b:
  continue
 c()") "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Continue()], orelse=[]), Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], orelse=[])])
"))
(ert-deftest pyel-transform-test-while-194 nil (equal (pyel "while a:
 if b:
  continue
 c()") (quote (while a (if b nil) (pyel-fcall c)))))
(ert-deftest pyel-el-ast-test-call-193 nil (string= (pyel "aa()" nil nil t) "(call  (name  \"aa\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-192 nil (equal (py-ast "aa()") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-191 nil (equal (pyel "aa()") (quote (pyel-fcall aa))))
(ert-deftest pyel-el-ast-test-call-190 nil (string= (pyel "aa(b,c(1,2))" nil nil t) "(call  (name  \"aa\" 'load 1 0) ((name  \"b\" 'load 1 3) (call  (name  \"c\" 'load 1 5) ((num 1 1 7) (num 2 1 9)) nil nil nil 1 5)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-189 nil (equal (py-ast "aa(b,c(1,2))") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Name(id='b', ctx=Load()), Call(func=Name(id='c', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-188 nil (equal (pyel "aa(b,c(1,2))") (quote (pyel-fcall aa b (pyel-fcall c 1 2)))))
(ert-deftest pyel-el-ast-test-call-187 nil (string= (pyel "aa=b()" nil nil t) "(assign  ((name  \"aa\" 'store 1 0)) (call  (name  \"b\" 'load 1 3) nil nil nil nil 1 3) 1 0)
"))
(ert-deftest pyel-py-ast-test-call-186 nil (equal (py-ast "aa=b()") "Module(body=[Assign(targets=[Name(id='aa', ctx=Store())], value=Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-185 nil (equal (pyel "aa=b()") (quote (pyel-set aa (pyel-fcall b)))))
(ert-deftest pyel-el-ast-test-call-184 nil (string= (pyel "aa(3,b(c(),[2,(2,3)]))" nil nil t) "(call  (name  \"aa\" 'load 1 0) ((num 3 1 3) (call  (name  \"b\" 'load 1 5) ((call  (name  \"c\" 'load 1 7) nil nil nil nil 1 7) (list ((num 2 1 12) (tuple  ((num 2 1 15) (num 3 1 17)) 'load 1 15)) 'load 1 11)) nil nil nil 1 5)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-183 nil (equal (py-ast "aa(3,b(c(),[2,(2,3)]))") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Num(n=3), Call(func=Name(id='b', ctx=Load()), args=[Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), List(elts=[Num(n=2), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load())], ctx=Load())], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-182 nil (equal (pyel "aa(3,b(c(),[2,(2,3)]))") (quote (pyel-fcall aa 3 (pyel-fcall b (pyel-fcall c) (list 2 (vector 2 3)))))))
(ert-deftest pyel-el-ast-test-call-181 nil (string= (pyel "aa.b()" nil nil t) "(call  (attribute  (name  \"aa\" 'load 1 0) \"b\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-180 nil (equal (py-ast "aa.b()") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-179 nil (equal (pyel "aa.b()") (quote (call-method aa b))))
(ert-deftest pyel-el-ast-test-call-178 nil (string= (pyel "aa.b(1,2)" nil nil t) "(call  (attribute  (name  \"aa\" 'load 1 0) \"b\" 'load 1 0) ((num 1 1 5) (num 2 1 7)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-177 nil (equal (py-ast "aa.b(1,2)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-176 nil (equal (pyel "aa.b(1,2)") (quote (call-method aa b 1 2))))
(ert-deftest pyel-el-ast-test-call-175 nil (string= (pyel "aa.b(1,a.b(1,2,3))" nil nil t) "(call  (attribute  (name  \"aa\" 'load 1 0) \"b\" 'load 1 0) ((num 1 1 5) (call  (attribute  (name  \"a\" 'load 1 7) \"b\" 'load 1 7) ((num 1 1 11) (num 2 1 13) (num 3 1 15)) nil nil nil 1 7)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-174 nil (equal (py-ast "aa.b(1,a.b(1,2,3))") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2), Num(n=3)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-173 nil (equal (pyel "aa.b(1,a.b(1,2,3))") (quote (call-method aa b 1 (call-method a b 1 2 3)))))
(ert-deftest pyel-el-ast-test-call-172 nil (string= (pyel "a.b().c()" nil nil t) "(call  (attribute  (call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) nil nil nil nil 1 0) \"c\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-171 nil (equal (py-ast "a.b().c()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-170 nil (equal (pyel "a.b().c()") (quote (call-method (call-method a b) c))))
(ert-deftest pyel-el-ast-test-call-169 nil (string= (pyel "a.b().c().d()" nil nil t) "(call  (attribute  (call  (attribute  (call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) nil nil nil nil 1 0) \"c\" 'load 1 0) nil nil nil nil 1 0) \"d\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-168 nil (equal (py-ast "a.b().c().d()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='d', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-167 nil (equal (pyel "a.b().c().d()") (quote (call-method (call-method (call-method a b) c) d))))
(ert-deftest pyel-el-ast-test-call-166 nil (string= (pyel "a.b(x.y().e()).c()" nil nil t) "(call  (attribute  (call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) ((call  (attribute  (call  (attribute  (name  \"x\" 'load 1 4) \"y\" 'load 1 4) nil nil nil nil 1 4) \"e\" 'load 1 4) nil nil nil nil 1 4)) nil nil nil 1 0) \"c\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-call-165 nil (equal (py-ast "a.b(x.y().e()).c()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Call(func=Attribute(value=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-call-164 nil (equal (pyel "a.b(x.y().e()).c()") (quote (call-method (call-method a b (call-method (call-method x y) e)) c))))
(ert-deftest pyel-el-ast-test-if-163 nil (string= (pyel "if (a==b):
  b=c
else:
  a = d" nil nil t) "(if  (compare  (name  \"a\" 'load 1 4) (\"==\") ((name  \"b\" 'load 1 7)) 1 4) ((assign  ((name  \"b\" 'store 2 2)) (name  \"c\" 'load 2 4) 2 2)) ((assign  ((name  \"a\" 'store 4 2)) (name  \"d\" 'load 4 6) 4 2)) 1 0)
"))
(ert-deftest pyel-py-ast-test-if-162 nil (equal (py-ast "if (a==b):
  b=c
else:
  a = d") "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='d', ctx=Load()))])])
"))
(ert-deftest pyel-transform-test-if-161 nil (equal (pyel "if (a==b):
  b=c
else:
  a = d") (quote (if (pyel-== a b) (pyel-set b c)))))
(ert-deftest pyel-el-ast-test-if-160 nil (string= (pyel "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b" nil nil t) "(if  (compare  (name  \"a\" 'load 1 4) (\"==\") ((name  \"b\" 'load 1 7)) 1 4) ((assign  ((name  \"b\" 'store 2 3)) (name  \"c\" 'load 2 5) 2 3) (assign  ((name  \"z\" 'store 3 3)) (num 1 3 5) 3 3)) ((assign  ((name  \"a\" 'store 5 2)) (num 4 5 6) 5 2) (assign  ((name  \"b\" 'store 6 2)) (attribute  (name  \"a\" 'load 6 6) \"b\" 'load 6 6) 6 2)) 1 0)
"))
(ert-deftest pyel-py-ast-test-if-159 nil (equal (py-ast "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b") "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load())), Assign(targets=[Name(id='z', ctx=Store())], value=Num(n=1))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=4)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])])
"))
(ert-deftest pyel-transform-test-if-158 nil (equal (pyel "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b") (quote (if (pyel-== a b) (progn (pyel-set b c) (pyel-set z 1)) (pyel-set a 4) (pyel-set b (getattr a b))))))
(ert-deftest pyel-el-ast-test-if-157 nil (string= (pyel "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]" nil nil t) "(if  (compare  (attribute  (name  \"a\" 'load 1 4) \"b\" 'load 1 4) (\"<=\") ((attribute  (name  \"a\" 'load 1 11) \"e\" 'load 1 11)) 1 4) ((assign  ((attribute  (name  \"a\" 'load 2 1) \"b\" 'store 2 1)) (tuple  ((num 2.1 2 6) (num 2 2 10)) 'load 2 6) 2 1)) ((assign  ((attribute  (attribute  (name  \"b\" 'load 4 1) \"a\" 'load 4 1) \"c\" 'store 4 1)) (list ((name  \"a\" 'load 4 8) (dict ((str \"a\" 4 11) (str \"b\" 4 20)) ((num 23.3 4 15) (tuple  ((num 3.2 4 25) (num 3.1 4 29)) 'load 4 25)) 4 10)) 'load 4 7) 4 1)) 1 0)
"))
(ert-deftest pyel-py-ast-test-if-156 nil (equal (py-ast "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]") "Module(body=[If(test=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE()], comparators=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load())]), body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Tuple(elts=[Num(n=2.1), Num(n=2)], ctx=Load()))], orelse=[Assign(targets=[Attribute(value=Attribute(value=Name(id='b', ctx=Load()), attr='a', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=23.3), Tuple(elts=[Num(n=3.2), Num(n=3.1)], ctx=Load())])], ctx=Load()))])])
"))
(ert-deftest pyel-transform-test-if-155 nil (equal (pyel "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]") (quote (if (pyel-<= (getattr a b) (getattr a e)) (setattr a b (vector 2.1 2))))))
(ert-deftest pyel-el-ast-test-compare-154 nil (string= (pyel "a=='d'" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"==\") ((str \"d\" 1 3)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-153 nil (equal (py-ast "a=='d'") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='d')]))])
"))
(ert-deftest pyel-transform-test-compare-152 nil (equal (pyel "a=='d'") (quote (pyel-== a "d"))))
(ert-deftest pyel-el-ast-test-compare-151 nil (string= (pyel "a==b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"==\") ((name  \"b\" 'load 1 3)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-150 nil (equal (py-ast "a==b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-149 nil (equal (pyel "a==b") (quote (pyel-== a b))))
(ert-deftest pyel-el-ast-test-compare-148 nil (string= (pyel "a>=b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\">=\") ((name  \"b\" 'load 1 3)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-147 nil (equal (py-ast "a>=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[GtE()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-146 nil (equal (pyel "a>=b") (quote (pyel->= a b))))
(ert-deftest pyel-el-ast-test-compare-145 nil (string= (pyel "a<=b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"<=\") ((name  \"b\" 'load 1 3)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-144 nil (equal (py-ast "a<=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-143 nil (equal (pyel "a<=b") (quote (pyel-<= a b))))
(ert-deftest pyel-el-ast-test-compare-142 nil (string= (pyel "a<b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"<\") ((name  \"b\" 'load 1 2)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-141 nil (equal (py-ast "a<b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-140 nil (equal (pyel "a<b") (quote (pyel-< a b))))
(ert-deftest pyel-el-ast-test-compare-139 nil (string= (pyel "a>b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\">\") ((name  \"b\" 'load 1 2)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-138 nil (equal (py-ast "a>b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-137 nil (equal (pyel "a>b") (quote (pyel-> a b))))
(ert-deftest pyel-el-ast-test-compare-136 nil (string= (pyel "a!=b" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"!=\") ((name  \"b\" 'load 1 3)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-135 nil (equal (py-ast "a!=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[NotEq()], comparators=[Name(id='b', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-134 nil (equal (pyel "a!=b") (quote (pyel-!= a b))))
(ert-deftest pyel-el-ast-test-compare-133 nil (string= (pyel "(a,b) == [c,d]" nil nil t) "(compare  (tuple  ((name  \"a\" 'load 1 1) (name  \"b\" 'load 1 3)) 'load 1 1) (\"==\") ((list ((name  \"c\" 'load 1 10) (name  \"d\" 'load 1 12)) 'load 1 9)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-132 nil (equal (py-ast "(a,b) == [c,d]") "Module(body=[Expr(value=Compare(left=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()), ops=[Eq()], comparators=[List(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-131 nil (equal (pyel "(a,b) == [c,d]") (quote (pyel-== (vector a b) (list c d)))))
(ert-deftest pyel-el-ast-test-compare-130 nil (string= (pyel "[a == 1]" nil nil t) "(list ((compare  (name  \"a\" 'load 1 1) (\"==\") ((num 1 1 6)) 1 1)) 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-129 nil (equal (py-ast "[a == 1]") "Module(body=[Expr(value=List(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-compare-128 nil (equal (pyel "[a == 1]") (quote (list (pyel-== a 1)))))
(ert-deftest pyel-el-ast-test-compare-127 nil (string= (pyel "((a == 1),)" nil nil t) "(tuple  ((compare  (name  \"a\" 'load 1 2) (\"==\") ((num 1 1 7)) 1 2)) 'load 1 1)
"))
(ert-deftest pyel-py-ast-test-compare-126 nil (equal (py-ast "((a == 1),)") "Module(body=[Expr(value=Tuple(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-compare-125 nil (equal (pyel "((a == 1),)") (quote (vector (pyel-== a 1)))))
(ert-deftest pyel-el-ast-test-compare-124 nil (string= (pyel "a<b<c" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"<\" \"<\") ((name  \"b\" 'load 1 2) (name  \"c\" 'load 1 4)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-123 nil (equal (py-ast "a<b<c") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt(), Lt()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-122 nil (equal (pyel "a<b<c") (quote (and (pyel-< a b) (pyel-< b c)))))
(ert-deftest pyel-el-ast-test-compare-121 nil (string= (pyel "a<=b<c<=d" nil nil t) "(compare  (name  \"a\" 'load 1 0) (\"<=\" \"<\" \"<=\") ((name  \"b\" 'load 1 3) (name  \"c\" 'load 1 5) (name  \"d\" 'load 1 8)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-120 nil (equal (py-ast "a<=b<c<=d") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load()), Name(id='d', ctx=Load())]))])
"))
(ert-deftest pyel-transform-test-compare-119 nil (equal (pyel "a<=b<c<=d") (quote (and (pyel-<= a b) (pyel-< b c) (pyel-<= c d)))))
(ert-deftest pyel-el-ast-test-compare-118 nil (string= (pyel "a.b<=b.c()<c<=3" nil nil t) "(compare  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) (\"<=\" \"<\" \"<=\") ((call  (attribute  (name  \"b\" 'load 1 5) \"c\" 'load 1 5) nil nil nil nil 1 5) (name  \"c\" 'load 1 11) (num 3 1 14)) 1 0)
"))
(ert-deftest pyel-py-ast-test-compare-117 nil (equal (py-ast "a.b<=b.c()<c<=3") "Module(body=[Expr(value=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Name(id='c', ctx=Load()), Num(n=3)]))])
"))
(ert-deftest pyel-transform-test-compare-116 nil (equal (pyel "a.b<=b.c()<c<=3") (quote (and (pyel-<= (getattr a b) (call-method b c)) (pyel-< (call-method b c) c) (pyel-<= c 3)))))
(ert-deftest pyel-el-ast-test-string-115 nil (string= (pyel "'a'" nil nil t) "(str \"a\" 1 0)
"))
(ert-deftest pyel-py-ast-test-string-114 nil (equal (py-ast "'a'") "Module(body=[Expr(value=Str(s='a'))])
"))
(ert-deftest pyel-transform-test-string-113 nil (equal (pyel "'a'") (quote "a")))
(ert-deftest pyel-el-ast-test-string-112 nil (string= (pyel "x = 'a'" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (str \"a\" 1 4) 1 0)
"))
(ert-deftest pyel-py-ast-test-string-111 nil (equal (py-ast "x = 'a'") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='a'))])
"))
(ert-deftest pyel-transform-test-string-110 nil (equal (pyel "x = 'a'") (quote (pyel-set x "a"))))
(ert-deftest pyel-el-ast-test-string-109 nil (string= (pyel "['a','b']" nil nil t) "(list ((str \"a\" 1 1) (str \"b\" 1 5)) 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-string-108 nil (equal (py-ast "['a','b']") "Module(body=[Expr(value=List(elts=[Str(s='a'), Str(s='b')], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-string-107 nil (equal (pyel "['a','b']") (quote (list "a" "b"))))
(ert-deftest pyel-el-ast-test-Tuple-106 nil (string= (pyel "()" nil nil t) "(tuple  nil 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-Tuple-105 nil (equal (py-ast "()") "Module(body=[Expr(value=Tuple(elts=[], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-Tuple-104 nil (equal (pyel "()") (quote (vector))))
(ert-deftest pyel-el-ast-test-Tuple-103 nil (string= (pyel "(a, b)" nil nil t) "(tuple  ((name  \"a\" 'load 1 1) (name  \"b\" 'load 1 4)) 'load 1 1)
"))
(ert-deftest pyel-py-ast-test-Tuple-102 nil (equal (py-ast "(a, b)") "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-Tuple-101 nil (equal (pyel "(a, b)") (quote (vector a b))))
(ert-deftest pyel-el-ast-test-Tuple-100 nil (string= (pyel "(a, (b, (c,d)))" nil nil t) "(tuple  ((name  \"a\" 'load 1 1) (tuple  ((name  \"b\" 'load 1 5) (tuple  ((name  \"c\" 'load 1 9) (name  \"d\" 'load 1 11)) 'load 1 9)) 'load 1 5)) 'load 1 1)
"))
(ert-deftest pyel-py-ast-test-Tuple-99 nil (equal (py-ast "(a, (b, (c,d)))") "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Name(id='b', ctx=Load()), Tuple(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-Tuple-98 nil (equal (pyel "(a, (b, (c,d)))") (quote (vector a (vector b (vector c d))))))
(ert-deftest pyel-el-ast-test-Tuple-97 nil (string= (pyel "((((((((a))))))))" nil nil t) "(name  \"a\" 'load 1 8)
"))
(ert-deftest pyel-py-ast-test-Tuple-96 nil (equal (py-ast "((((((((a))))))))") "Module(body=[Expr(value=Name(id='a', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-Tuple-95 nil (equal (pyel "((((((((a))))))))") (quote a)))
(ert-deftest pyel-el-ast-test-dict-94 nil (string= (pyel "{'a':2, 'b':4}" nil nil t) "(dict ((str \"a\" 1 1) (str \"b\" 1 8)) ((num 2 1 5) (num 4 1 12)) 1 0)
"))
(ert-deftest pyel-py-ast-test-dict-93 nil (equal (py-ast "{'a':2, 'b':4}") "Module(body=[Expr(value=Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=2), Num(n=4)]))])
"))
(ert-deftest pyel-transform-test-dict-92 nil (equal (pyel "{'a':2, 'b':4}") (quote (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "a" 2 __h__) (puthash "b" 4 __h__) __h__))))
(ert-deftest pyel-el-ast-test-dict-91 nil (string= (pyel "a = {a:2, b:4}" nil nil t) "(assign  ((name  \"a\" 'store 1 0)) (dict ((name  \"a\" 'load 1 5) (name  \"b\" 'load 1 10)) ((num 2 1 7) (num 4 1 12)) 1 4) 1 0)
"))
(ert-deftest pyel-py-ast-test-dict-90 nil (equal (py-ast "a = {a:2, b:4}") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Dict(keys=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], values=[Num(n=2), Num(n=4)]))])
"))
(ert-deftest pyel-transform-test-dict-89 nil (equal (pyel "a = {a:2, b:4}") (quote (pyel-set a (let ((__h__ (make-hash-table :test (quote equal)))) (puthash a 2 __h__) (puthash b 4 __h__) __h__)))))
(ert-deftest pyel-el-ast-test-dict-88 nil (string= (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}" nil nil t) "(assign  ((name  \"x\" 'store 1 0)) (dict ((str \"a\" 1 5) (str \"b\" 1 12) (str \"c\" 1 19)) ((num 2 1 9) (num 4 1 16) (dict ((str \"d\" 1 26) (str \"e\" 1 34) (name  \"f\" 'load 1 41)) ((num 1 1 32) (num 2 1 39) (dict ((name  \"g\" 'load 1 44)) ((num 3 1 46)) 1 43)) 1 25)) 1 4) 1 0)
"))
(ert-deftest pyel-py-ast-test-dict-87 nil (equal (py-ast "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Dict(keys=[Str(s='a'), Str(s='b'), Str(s='c')], values=[Num(n=2), Num(n=4), Dict(keys=[Str(s='d'), Str(s='e'), Name(id='f', ctx=Load())], values=[Num(n=1), Num(n=2), Dict(keys=[Name(id='g', ctx=Load())], values=[Num(n=3)])])]))])
"))
(ert-deftest pyel-transform-test-dict-86 nil (equal (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}") (quote (pyel-set x (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "a" 2 __h__) (puthash "b" 4 __h__) (puthash "c" (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "d" 1 __h__) (puthash "e" 2 __h__) (puthash f (let ((__h__ (make-hash-table :test (quote equal)))) (puthash g 3 __h__) __h__) __h__) __h__) __h__) __h__)))))
(ert-deftest pyel-el-ast-test-attribute-84 nil (string= (pyel "a.b" nil nil t) "(attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-83 nil (equal (py-ast "a.b") "Module(body=[Expr(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-82 nil (equal (pyel "a.b") (quote (getattr a b))))
(ert-deftest pyel-el-ast-test-attribute-81 nil (string= (pyel "a.b.c" nil nil t) "(attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-80 nil (equal (py-ast "a.b.c") "Module(body=[Expr(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-79 nil (equal (pyel "a.b.c") (quote (getattr (getattr a b) c))))
(ert-deftest pyel-el-ast-test-attribute-78 nil (string= (pyel "a.b.c.e" nil nil t) "(attribute  (attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'load 1 0) \"e\" 'load 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-77 nil (equal (py-ast "a.b.c.e") "Module(body=[Expr(value=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='e', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-76 nil (equal (pyel "a.b.c.e") (quote (getattr (getattr (getattr a b) c) e))))
(ert-deftest pyel-el-ast-test-attribute-75 nil (string= (pyel "a.b()" nil nil t) "(call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-74 nil (equal (py-ast "a.b()") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-73 nil (equal (pyel "a.b()") (quote (call-method a b))))
(ert-deftest pyel-el-ast-test-attribute-72 nil (string= (pyel "a.b.c()" nil nil t) "(call  (attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-71 nil (equal (py-ast "a.b.c()") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-70 nil (equal (pyel "a.b.c()") (quote (call-method (getattr a b) c))))
(ert-deftest pyel-el-ast-test-attribute-69 nil (string= (pyel "a.b.c.d()" nil nil t) "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'load 1 0) \"d\" 'load 1 0) nil nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-68 nil (equal (py-ast "a.b.c.d()") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-67 nil (equal (pyel "a.b.c.d()") (quote (call-method (getattr (getattr a b) c) d))))
(ert-deftest pyel-el-ast-test-attribute-66 nil (string= (pyel "a.b.c.d(1,3)" nil nil t) "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'load 1 0) \"d\" 'load 1 0) ((num 1 1 8) (num 3 1 10)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-65 nil (equal (py-ast "a.b.c.d(1,3)") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-64 nil (equal (pyel "a.b.c.d(1,3)") (quote (call-method (getattr (getattr a b) c) d 1 3))))
(ert-deftest pyel-el-ast-test-attribute-63 nil (string= (pyel "a.b = 2" nil nil t) "(assign  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0)) (num 2 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-62 nil (equal (py-ast "a.b = 2") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Num(n=2))])
"))
(ert-deftest pyel-transform-test-attribute-61 nil (equal (pyel "a.b = 2") (quote (setattr a b 2))))
(ert-deftest pyel-el-ast-test-attribute-60 nil (string= (pyel "a.b.e = 2" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"e\" 'store 1 0)) (num 2 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-59 nil (equal (py-ast "a.b.e = 2") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='e', ctx=Store())], value=Num(n=2))])
"))
(ert-deftest pyel-transform-test-attribute-58 nil (equal (pyel "a.b.e = 2") (quote (setattr (getattr a b) e 2))))
(ert-deftest pyel-el-ast-test-attribute-57 nil (string= (pyel "a.b.c = d.e" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (attribute  (name  \"d\" 'load 1 8) \"e\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-56 nil (equal (py-ast "a.b.c = d.e") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-55 nil (equal (pyel "a.b.c = d.e") (quote (setattr (getattr a b) c (getattr d e)))))
(ert-deftest pyel-el-ast-test-attribute-54 nil (string= (pyel "a.b.c = d.e.f" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (attribute  (attribute  (name  \"d\" 'load 1 8) \"e\" 'load 1 8) \"f\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-53 nil (equal (py-ast "a.b.c = d.e.f") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-52 nil (equal (pyel "a.b.c = d.e.f") (quote (setattr (getattr a b) c (getattr (getattr d e) f)))))
(ert-deftest pyel-el-ast-test-attribute-51 nil (string= (pyel "a.b.c = d.e()" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (call  (attribute  (name  \"d\" 'load 1 8) \"e\" 'load 1 8) nil nil nil nil 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-50 nil (equal (py-ast "a.b.c = d.e()") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-49 nil (equal (pyel "a.b.c = d.e()") (quote (setattr (getattr a b) c (call-method d e)))))
(ert-deftest pyel-el-ast-test-attribute-48 nil (string= (pyel "a.b.c = d.e.f()" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (call  (attribute  (attribute  (name  \"d\" 'load 1 8) \"e\" 'load 1 8) \"f\" 'load 1 8) nil nil nil nil 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-47 nil (equal (py-ast "a.b.c = d.e.f()") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-46 nil (equal (pyel "a.b.c = d.e.f()") (quote (setattr (getattr a b) c (call-method (getattr d e) f)))))
(ert-deftest pyel-el-ast-test-attribute-45 nil (string= (pyel "a.b.c = d.e.f(1,3)" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (call  (attribute  (attribute  (name  \"d\" 'load 1 8) \"e\" 'load 1 8) \"f\" 'load 1 8) ((num 1 1 14) (num 3 1 16)) nil nil nil 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-44 nil (equal (py-ast "a.b.c = d.e.f(1,3)") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-43 nil (equal (pyel "a.b.c = d.e.f(1,3)") (quote (setattr (getattr a b) c (call-method (getattr d e) f 1 3)))))
(ert-deftest pyel-el-ast-test-attribute-42 nil (string= (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b" nil nil t) "(assign  ((tuple  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0) (attribute  (attribute  (name  \"a\" 'load 1 5) \"b\" 'load 1 5) \"c\" 'store 1 5)) 'store 1 0)) (tuple  ((call  (attribute  (attribute  (name  \"d\" 'load 1 13) \"e\" 'load 1 13) \"f\" 'load 1 13) ((num 1 1 19) (num 3 1 21)) nil nil nil 1 13) (attribute  (attribute  (name  \"e\" 'load 1 25) \"g\" 'load 1 25) \"b\" 'load 1 25)) 'load 1 13) 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-41 nil (equal (py-ast "a.b, a.b.c = d.e.f(1,3), e.g.b") "Module(body=[Assign(targets=[Tuple(elts=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None), Attribute(value=Attribute(value=Name(id='e', ctx=Load()), attr='g', ctx=Load()), attr='b', ctx=Load())], ctx=Load()))])
"))
(ert-deftest pyel-transform-test-attribute-40 nil (equal (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b") (quote (let ((__1__ (call-method (getattr d e) f 1 3)) (__2__ (getattr (getattr e g) b))) (setattr a b __1__) (setattr (getattr a b) c __2__)))))
(ert-deftest pyel-el-ast-test-attribute-39 nil (string= (pyel "a.b(x.y,y)" nil nil t) "(call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) ((attribute  (name  \"x\" 'load 1 4) \"y\" 'load 1 4) (name  \"y\" 'load 1 8)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-38 nil (equal (py-ast "a.b(x.y,y)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), Name(id='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-37 nil (equal (pyel "a.b(x.y,y)") (quote (call-method a b (getattr x y) y))))
(ert-deftest pyel-el-ast-test-attribute-36 nil (string= (pyel "a.b(x.y(g.g()),y.y)" nil nil t) "(call  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) ((call  (attribute  (name  \"x\" 'load 1 4) \"y\" 'load 1 4) ((call  (attribute  (name  \"g\" 'load 1 8) \"g\" 'load 1 8) nil nil nil nil 1 8)) nil nil nil 1 4) (attribute  (name  \"y\" 'load 1 15) \"y\" 'load 1 15)) nil nil nil 1 0)
"))
(ert-deftest pyel-py-ast-test-attribute-35 nil (equal (py-ast "a.b(x.y(g.g()),y.y)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), args=[Call(func=Attribute(value=Name(id='g', ctx=Load()), attr='g', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None), Attribute(value=Name(id='y', ctx=Load()), attr='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-attribute-34 nil (equal (pyel "a.b(x.y(g.g()),y.y)") (quote (call-method a b (call-method x y (call-method g g)) (getattr y y)))))
(ert-deftest pyel-el-ast-test-assign-31 nil (string= (pyel "a.b = c" nil nil t) "(assign  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0)) (name  \"c\" 'load 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-30 nil (equal (py-ast "a.b = c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-29 nil (equal (pyel "a.b = c") (quote (setattr a b c))))
(ert-deftest pyel-el-ast-test-assign-28 nil (string= (pyel "a.b.c = 1" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (num 1 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-27 nil (equal (py-ast "a.b.c = 1") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Num(n=1))])
"))
(ert-deftest pyel-transform-test-assign-26 nil (equal (pyel "a.b.c = 1") (quote (setattr (getattr a b) c 1))))
(ert-deftest pyel-el-ast-test-assign-25 nil (string= (pyel "a.b = d.c" nil nil t) "(assign  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0)) (attribute  (name  \"d\" 'load 1 6) \"c\" 'load 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-24 nil (equal (py-ast "a.b = d.c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-23 nil (equal (pyel "a.b = d.c") (quote (setattr a b (getattr d c)))))
(ert-deftest pyel-el-ast-test-assign-16 nil (string= (pyel "a,b = a.e.e()" nil nil t) "(assign  ((tuple  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 2)) 'store 1 0)) (call  (attribute  (attribute  (name  \"a\" 'load 1 6) \"e\" 'load 1 6) \"e\" 'load 1 6) nil nil nil nil 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-15 nil (equal (py-ast "a,b = a.e.e()") "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-assign-14 nil (equal (pyel "a,b = a.e.e()") (quote (let ((__value__ (call-method (getattr a e) e))) (pyel-set a (pyel-subscript-load-index __value__ 0)) (pyel-set b (pyel-subscript-load-index __value__ 1))))))
(ert-deftest pyel-el-ast-test-assign-13 nil (string= (pyel "a[1:4], b[2], a.c = c" nil nil t) "(assign  ((tuple  ((subscript (name  \"a\" 'load 1 0) (slice (num 1 1 2) (num 4 1 4) nil) 'store 1 0) (subscript (name  \"b\" 'load 1 8) (index (num 2 1 10) nil nil) 'store 1 8) (attribute  (name  \"a\" 'load 1 14) \"c\" 'store 1 14)) 'store 1 0)) (name  \"c\" 'load 1 20) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-12 nil (equal (py-ast "a[1:4], b[2], a.c = c") "Module(body=[Assign(targets=[Tuple(elts=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-11 nil (equal (pyel "a[1:4], b[2], a.c = c") (quote (let ((__value__ c)) (pyel-subscript-store-slice a 1 4 nil (pyel-subscript-load-index __value__ 0)) (pyel-subscript-store-index b 2 (pyel-subscript-load-index __value__ 1)) (setattr a c (pyel-subscript-load-index __value__ 2))))))
(ert-deftest pyel-el-ast-test-assign-10 nil (string= (pyel "a = b = c" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (name  \"c\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-9 nil (equal (py-ast "a = b = c") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-8 nil (equal (pyel "a = b = c") (quote (progn (pyel-set b c) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-assign-7 nil (string= (pyel "a = b = c.e" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (attribute  (name  \"c\" 'load 1 8) \"e\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-6 nil (equal (py-ast "a = b = c.e") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-5 nil (equal (pyel "a = b = c.e") (quote (progn (pyel-set b (getattr c e)) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-assign-4 nil (string= (pyel "a = b = c.e()" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (call  (attribute  (name  \"c\" 'load 1 8) \"e\" 'load 1 8) nil nil nil nil 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-3 nil (equal (py-ast "a = b = c.e()") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-assign-2 nil (equal (pyel "a = b = c.e()") (quote (progn (pyel-set b (call-method c e)) (pyel-set a b)))))

(provide 'pyel-tests-generated)
