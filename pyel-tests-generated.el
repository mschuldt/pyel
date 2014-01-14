(setq pyel-test-py-functions '("def pyel_test_append_348(n):
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
  return a[3] is c" "def pyel_test_type_347(n):
 class testc: pass
 x = testc()
 y = type(x)
 if n == 1:
  return repr(type(x))
 
 if n == 2:
  return y is testc" "def pyel_test_special_method_lookup_322(n):
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
  return d.__call__" "def pyel_test_objects_321(n):
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
  return y()" "def pyel_test_objects_320(n):
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
  return x.other.m()" "def pyel_test_function_arguments_256(n):
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
  return repr(func(x = 's',__b = 324,__a = 'n',d = 2))" "def pyel_test_assign_33():
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
  return c"))(ert-deftest pyel-type9 nil (equal (eval (pyel "def _pyel21312():
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
(ert-deftest pyel-test-function_arguments-1 nil (equal (eval (pyel "pyel_test_function_arguments_256(1)")) "[1, 2, 1, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-2 nil (equal (eval (pyel "pyel_test_function_arguments_256(2)")) "[1, 2, 3, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-3 nil (equal (eval (pyel "pyel_test_function_arguments_256(3)")) "[1, 2, 3, 4, [], {}]"))
(ert-deftest pyel-test-function_arguments-4 nil (equal (eval (pyel "pyel_test_function_arguments_256(4)")) "[1, 2, 3, 4, [5], {}]"))
(ert-deftest pyel-test-function_arguments-5 nil (equal (eval (pyel "pyel_test_function_arguments_256(5)")) "[1, 2, 3, 4, [5, 6], {}]"))
(ert-deftest pyel-test-function_arguments-6 nil (equal (eval (pyel "pyel_test_function_arguments_256(6)")) "[1, 2, 3, 4, [5, 6], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-7 nil (equal (eval (pyel "pyel_test_function_arguments_256(7)")) "[1, 2, 3, 4, [5, 6], {y: 23, x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-8 nil (equal (eval (pyel "pyel_test_function_arguments_256(8)")) "[\"n\", 324, 1, \"two\", [], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-9 nil (equal (eval (pyel "pyel_test_function_arguments_256(9)")) "[\"n\", 324, 1, 2, [], {x: \"s\"}]"))
(ert-deftest pyel-test-objects-1 nil (equal (eval (pyel "pyel_test_objects_320(1)")) 5))
(ert-deftest pyel-test-objects-2 nil (equal (eval (pyel "pyel_test_objects_320(2)")) 6))
(ert-deftest pyel-test-objects-3 nil (equal (eval (pyel "pyel_test_objects_321(1)")) "tclass"))
(ert-deftest pyel-test-objects-4 nil (equal (eval (pyel "pyel_test_objects_321(2)")) (lambda (self) (getattr self a))))
(ert-deftest pyel-test-objects-5 nil (equal (eval (pyel "pyel_test_objects_321(3)")) (lambda (self n) (setattr self a n))))
(ert-deftest pyel-test-objects-6 nil (equal (eval (pyel "pyel_test_objects_321(4)")) 12))
(ert-deftest pyel-test-objects-7 nil (equal (eval (pyel "pyel_test_objects_321(5)")) "hi"))
(ert-deftest pyel-test-objects-8 nil (equal (eval (pyel "pyel_test_objects_321(6)")) 23))
(ert-deftest pyel-test-objects-9 nil (equal (eval (pyel "pyel_test_objects_321(7)")) 19))
(ert-deftest pyel-test-objects-10 nil (equal (eval (pyel "pyel_test_objects_321(8)")) (lambda (self) nil (pyel-+ (getattr self cvar) 5))))
(ert-deftest pyel-test-objects-11 nil (equal (eval (pyel "pyel_test_objects_321(9)")) "<class 'object'>"))
(ert-deftest pyel-test-objects-12 nil (equal (eval (pyel "pyel_test_objects_321(10)")) t))
(ert-deftest pyel-test-objects-13 nil (equal (eval (pyel "pyel_test_objects_321(11)")) "tclass"))
(ert-deftest pyel-test-objects-14 nil (equal (eval (pyel "pyel_test_objects_321(12)")) 14))
(ert-deftest pyel-test-objects-15 nil (equal (eval (pyel "pyel_test_objects_321(13)")) 2))
(ert-deftest pyel-test-objects-16 nil (equal (eval (pyel "pyel_test_objects_321(14)")) [4 12]))
(ert-deftest pyel-test-objects-17 nil (equal (eval (pyel "pyel_test_objects_321(15)")) 10))
(ert-deftest pyel-test-objects-18 nil (equal (eval (pyel "pyel_test_objects_321(16)")) 8))
(ert-deftest pyel-test-special_method_lookup-1 nil (equal (eval (pyel "pyel_test_special_method_lookup_322(1)")) 16))
(ert-deftest pyel-test-special_method_lookup-2 nil (equal (eval (pyel "pyel_test_special_method_lookup_322(2)")) "<bound method adder.__call__ of adder object at 0x18b071>"))
(ert-deftest pyel-test-special_method_lookup-3 nil (equal (eval (pyel "pyel_test_special_method_lookup_322(3)")) (lambda nil nil "hi")))
(ert-deftest pyel-test-type-1 nil (equal (eval (pyel "pyel_test_type_347(1)")) "<class 'testc'>"))
(ert-deftest pyel-test-type-2 nil (equal (eval (pyel "pyel_test_type_347(2)")) t))
(ert-deftest pyel-test-append-1 nil (equal (eval (pyel "pyel_test_append_348(1)")) (quote (1 2 3 "hi"))))
(ert-deftest pyel-test-append-2 nil (equal (eval (pyel "pyel_test_append_348(2)")) t))
(ert-deftest pyel-test-append-3 nil (equal (eval (pyel "pyel_test_append_348(3)")) t))
(ert-deftest pyel-test-append-4 nil (equal (eval (pyel "pyel_test_append_348(4)")) t))
(ert-deftest pyel-el-ast-test-conditional-expressions-474 nil (string= (pyel "1 if True else 0" t) "(if-exp (name  \"True\" 'load) (num 1) (num 0))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-conditional-expressions-473 nil (equal (py-ast "1 if True else 0") "Module(body=[Expr(value=IfExp(test=Name(id='True', ctx=Load()), body=Num(n=1), orelse=Num(n=0)))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-conditional-expressions-472 nil (equal (pyel "1 if True else 0") (quote (if t 1 0))))
(ert-deftest pyel-el-ast-test-conditional-expressions-471 nil (string= (pyel "true() if tst() else false()" t) "(if-exp (call  (name  \"tst\" 'load) nil nil nil nil) (call  (name  \"true\" 'load) nil nil nil nil) (call  (name  \"false\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-conditional-expressions-470 nil (equal (py-ast "true() if tst() else false()") "Module(body=[Expr(value=IfExp(test=Call(func=Name(id='tst', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), body=Call(func=Name(id='true', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), orelse=Call(func=Name(id='false', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-conditional-expressions-469 nil (equal (pyel "true() if tst() else false()") (quote (if (pyel-fcall tst) (pyel-fcall true) (pyel-fcall false)))))
(ert-deftest pyel-el-ast-test-conditional-expressions-468 nil (string= (pyel "a[1] if a[2:2] else a[2]" t) "(if-exp (subscript (name  \"a\" 'load) (slice (num 2) (num 2) nil) 'load) (subscript (name  \"a\" 'load) (index (num 1)) 'load) (subscript (name  \"a\" 'load) (index (num 2)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-conditional-expressions-467 nil (equal (py-ast "a[1] if a[2:2] else a[2]") "Module(body=[Expr(value=IfExp(test=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=Num(n=2), step=None), ctx=Load()), body=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), orelse=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-conditional-expressions-466 nil (equal (pyel "a[1] if a[2:2] else a[2]") (quote (if (pyel-subscript-load-slice a 2 2 nil) (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2)))))
(ert-deftest pyel-el-ast-test-boolop-465 nil (string= (pyel "a or b" t) "(boolop or ((name  \"a\" 'load) (name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-464 nil (equal (py-ast "a or b") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-463 nil (equal (pyel "a or b") (quote (or a b))))
(ert-deftest pyel-el-ast-test-boolop-462 nil (string= (pyel "a or b or c" t) "(boolop or ((name  \"a\" 'load) (name  \"b\" 'load) (name  \"c\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-461 nil (equal (py-ast "a or b or c") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-460 nil (equal (pyel "a or b or c") (quote (or a b c))))
(ert-deftest pyel-el-ast-test-boolop-459 nil (string= (pyel "a.c or b.c() or a[2]" t) "(boolop or ((attribute  (name  \"a\" 'load) \"c\" 'load) (call  (attribute  (name  \"b\" 'load) \"c\" 'load) nil nil nil nil) (subscript (name  \"a\" 'load) (index (num 2)) 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-458 nil (equal (py-ast "a.c or b.c() or a[2]") "Module(body=[Expr(value=BoolOp(op=Or(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-457 nil (equal (pyel "a.c or b.c() or a[2]") (quote (or (getattr a c) (call-method b c) (pyel-subscript-load-index a 2)))))
(ert-deftest pyel-el-ast-test-boolop-456 nil (string= (pyel "a and b" t) "(boolop and ((name  \"a\" 'load) (name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-455 nil (equal (py-ast "a and b") "Module(body=[Expr(value=BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-454 nil (equal (pyel "a and b") (quote (and a b))))
(ert-deftest pyel-el-ast-test-boolop-453 nil (string= (pyel "a and b or c" t) "(boolop or ((boolop and ((name  \"a\" 'load) (name  \"b\" 'load))) (name  \"c\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-452 nil (equal (py-ast "a and b or c") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]), Name(id='c', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-451 nil (equal (pyel "a and b or c") (quote (or (and a b) c))))
(ert-deftest pyel-el-ast-test-boolop-450 nil (string= (pyel "a[2] and b.f() or c.e" t) "(boolop or ((boolop and ((subscript (name  \"a\" 'load) (index (num 2)) 'load) (call  (attribute  (name  \"b\" 'load) \"f\" 'load) nil nil nil nil))) (attribute  (name  \"c\" 'load) \"e\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-449 nil (equal (py-ast "a[2] and b.f() or c.e") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-448 nil (equal (pyel "a[2] and b.f() or c.e") (quote (or (and (pyel-subscript-load-index a 2) (call-method b f)) (getattr c e)))))
(ert-deftest pyel-el-ast-test-boolop-447 nil (string= (pyel "a.e and b[2] or c.e() and 2 " t) "(boolop or ((boolop and ((attribute  (name  \"a\" 'load) \"e\" 'load) (subscript (name  \"b\" 'load) (index (num 2)) 'load))) (boolop and ((call  (attribute  (name  \"c\" 'load) \"e\" 'load) nil nil nil nil) (num 2)))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-boolop-446 nil (equal (py-ast "a.e and b[2] or c.e() and 2 ") "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]), BoolOp(op=And(), values=[Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Num(n=2)])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-boolop-445 nil (equal (pyel "a.e and b[2] or c.e() and 2 ") (quote (or (and (getattr a e) (pyel-subscript-load-index b 2)) (and (call-method c e) 2)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-444 nil (string= (pyel "[x*x for x in range(10)]" t) "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ())))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-443 nil (equal (py-ast "[x*x for x in range(10)]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-442 nil (equal (pyel "[x*x for x in range(10)]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-441 nil (string= (pyel "[x*x for x in range(10) if x > 5]" t) "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ((compare  (name  \"x\" 'load) (\">\") ((num 5)))))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-440 nil (equal (py-ast "[x*x for x in range(10) if x > 5]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)])])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-439 nil (equal (pyel "[x*x for x in range(10) if x > 5]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) if (pyel-> x 5) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-438 nil (string= (pyel "[x*x for x in range(10) if x > 5 if x < 8]" t) "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ((compare  (name  \"x\" 'load) (\">\") ((num 5))) (compare  (name  \"x\" 'load) (\"<\") ((num 8)))))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-437 nil (equal (py-ast "[x*x for x in range(10) if x > 5 if x < 8]") "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)]), Compare(left=Name(id='x', ctx=Load()), ops=[Lt()], comparators=[Num(n=8)])])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-436 nil (equal (pyel "[x*x for x in range(10) if x > 5 if x < 8]") (quote (let ((__list__ nil)) (loop for x in (py-list (pyel-fcall py-range 10)) if (and (pyel-> x 5) (pyel-< x 8)) do (setq __list__ (cons (pyel-* x x) __list__))) (reverse __list__)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-435 nil (string= (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]" t) "(assert  (compare  (list-comp (tuple  ((name  \"x\" 'load) (name  \"y\" 'load)) 'load) ((comprehension (name  \"x\" 'store) (list ((num 1) (num 2) (num 3)) 'load) ()) (comprehension (name  \"y\" 'store) (list ((num 3) (num 1) (num 4)) 'load) ((compare  (name  \"x\" 'load) (\"!=\") ((name  \"y\" 'load))))))) (\"==\") ((list ((tuple  ((num 1) (num 3)) 'load) (tuple  ((num 1) (num 4)) 'load) (tuple  ((num 2) (num 3)) 'load) (tuple  ((num 2) (num 1)) 'load) (tuple  ((num 2) (num 4)) 'load) (tuple  ((num 3) (num 1)) 'load) (tuple  ((num 3) (num 4)) 'load)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-434 nil (equal (py-ast "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]") "Module(body=[Assert(test=Compare(left=ListComp(elt=Tuple(elts=[Name(id='x', ctx=Load()), Name(id='y', ctx=Load())], ctx=Load()), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load()), ifs=[]), comprehension(target=Name(id='y', ctx=Store()), iter=List(elts=[Num(n=3), Num(n=1), Num(n=4)], ctx=Load()), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[NotEq()], comparators=[Name(id='y', ctx=Load())])])]), ops=[Eq()], comparators=[List(elts=[Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=1), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=4)], ctx=Load())], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-433 nil (equal (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]") (quote (assert (pyel-== (let ((__list__ nil)) (loop for x in (py-list (list 1 2 3)) do (loop for y in (py-list (list 3 1 4)) if (pyel-!= x y) do (setq __list__ (cons (vector x y) __list__)))) (reverse __list__)) (list (vector 1 3) (vector 1 4) (vector 2 3) (vector 2 1) (vector 2 4) (vector 3 1) (vector 3 4))) t nil))))
(ert-deftest pyel-el-ast-test-list-comprehensions-432 nil (string= (pyel "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]" t) "(assign  ((name  \"matrix\" 'store)) (list ((list ((num 1) (num 2) (num 3) (num 4)) 'load) (list ((num 5) (num 6) (num 7) (num 8)) 'load) (list ((num 9) (num 10) (num 11) (num 12)) 'load)) 'load))
(assign  ((name  \"_x\" 'store)) (list-comp (list-comp (subscript (name  \"row\" 'load) (index (name  \"i\" 'load)) 'load) ((comprehension (name  \"row\" 'store) (name  \"matrix\" 'load) ()))) ((comprehension (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 4)) nil nil nil) ()))))
(assert  (compare  (name  \"_x\" 'load) (\"==\") ((list ((list ((num 1) (num 5) (num 9)) 'load) (list ((num 2) (num 6) (num 10)) 'load) (list ((num 3) (num 7) (num 11)) 'load) (list ((num 4) (num 8) (num 12)) 'load)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-431 nil (equal (py-ast "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]") "Module(body=[Assign(targets=[Name(id='matrix', ctx=Store())], value=List(elts=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load()), List(elts=[Num(n=5), Num(n=6), Num(n=7), Num(n=8)], ctx=Load()), List(elts=[Num(n=9), Num(n=10), Num(n=11), Num(n=12)], ctx=Load())], ctx=Load())), Assign(targets=[Name(id='_x', ctx=Store())], value=ListComp(elt=ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])]), generators=[comprehension(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Name(id='_x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-430 nil (equal (pyel "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]") (quote (progn (pyel-set matrix (list (list 1 2 3 4) (list 5 6 7 8) (list 9 10 11 12))) (pyel-set -x (let ((__list__ nil)) (loop for i in (py-list (pyel-fcall py-range 4)) do (setq __list__ (cons (let ((__list__ nil)) (loop for row in (py-list matrix) do (setq __list__ (cons (pyel-subscript-load-index row i) __list__))) (reverse __list__)) __list__))) (reverse __list__))) (assert (pyel-== -x (list (list 1 5 9) (list 2 6 10) (list 3 7 11) (list 4 8 12))) t nil)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-429 nil (string= (pyel "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
" t) "(assign  ((name  \"transposed\" 'store)) (list nil 'load))
(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 4)) nil nil nil) ((call  (attribute  (name  \"transposed\" 'load) \"append\" 'load) ((list-comp (subscript (name  \"row\" 'load) (index (name  \"i\" 'load)) 'load) ((comprehension (name  \"row\" 'store) (name  \"matrix\" 'load) ())))) nil nil nil)) nil)
(assert  (compare  (name  \"transposed\" 'load) (\"==\") ((list ((list ((num 1) (num 5) (num 9)) 'load) (list ((num 2) (num 6) (num 10)) 'load) (list ((num 3) (num 7) (num 11)) 'load) (list ((num 4) (num 8) (num 12)) 'load)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-428 nil (equal (py-ast "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
") "Module(body=[Assign(targets=[Name(id='transposed', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), body=[Expr(value=Call(func=Attribute(value=Name(id='transposed', ctx=Load()), attr='append', ctx=Load()), args=[ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])])], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='transposed', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-427 nil (equal (pyel "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
") (quote (progn (pyel-set transposed (list)) (py-for i in (pyel-fcall py-range 4) (pyel-append-method transposed (let ((__list__ nil)) (loop for row in (py-list matrix) do (setq __list__ (cons (pyel-subscript-load-index row i) __list__))) (reverse __list__)))) (assert (pyel-== transposed (list (list 1 5 9) (list 2 6 10) (list 3 7 11) (list 4 8 12))) t nil)))))
(ert-deftest pyel-el-ast-test-list-comprehensions-426 nil (string= (pyel "{x: [y*y for y in range(x)] for x in range(20)}" t) "(dict-comp (name  \"x\" 'load) (list-comp (bin-op  (name  \"y\" 'load) * (name  \"y\" 'load)) ((comprehension (name  \"y\" 'store) (call  (name  \"range\" 'load) ((name  \"x\" 'load)) nil nil nil) ()))) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 20)) nil nil nil) ())))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-425 nil (equal (py-ast "{x: [y*y for y in range(x)] for x in range(20)}") "Module(body=[Expr(value=DictComp(key=Name(id='x', ctx=Load()), value=ListComp(elt=BinOp(left=Name(id='y', ctx=Load()), op=Mult(), right=Name(id='y', ctx=Load())), generators=[comprehension(target=Name(id='y', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ifs=[])]), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=20)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-424 nil (equal (pyel "{x: [y*y for y in range(x)] for x in range(20)}") (quote (let ((__dict__ (make-hash-table :test (quote equal)))) (loop for x in (py-list (pyel-fcall py-range 20)) do (puthash x (let ((__list__ nil)) (loop for y in (py-list (pyel-fcall py-range x)) do (setq __list__ (cons (pyel-* y y) __list__))) (reverse __list__)) __dict__)) __dict__))))
(ert-deftest pyel-el-ast-test-list-comprehensions-423 nil (string= (pyel "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
" t) "(assign  ((name  \"x\" 'store)) (dict-comp (name  \"x\" 'load) (call  (name  \"number_to_string\" 'load) ((name  \"x\" 'load)) nil nil nil) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ()))))
(assert  (compare  (call  (name  \"hash_table_count\" 'load) ((name  \"x\" 'load)) nil nil nil) (\"==\") ((num 10))) nil)
(assert  (compare  (subscript (name  \"x\" 'load) (index (num 1)) 'load) (\"==\") ((str \"1\"))) nil)
(assert  (compare  (subscript (name  \"x\" 'load) (index (num 9)) 'load) (\"==\") ((str \"9\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-comprehensions-422 nil (equal (py-ast "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=DictComp(key=Name(id='x', ctx=Load()), value=Call(func=Name(id='number_to_string', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Call(func=Name(id='hash_table_count', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=10)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='1')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=9)), ctx=Load()), ops=[Eq()], comparators=[Str(s='9')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-comprehensions-421 nil (equal (pyel "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
") (quote (progn (pyel-set x (let ((__dict__ (make-hash-table :test (quote equal)))) (loop for x in (py-list (pyel-fcall py-range 10)) do (puthash x (pyel-fcall number-to-string x) __dict__)) __dict__)) (assert (pyel-== (pyel-fcall hash-table-count x) 10) t nil) (assert (pyel-== (pyel-subscript-load-index x 1) "1") t nil) (assert (pyel-== (pyel-subscript-load-index x 9) "9") t nil)))))
(ert-deftest pyel-el-ast-test-try-420 nil (string= (pyel "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'" t) "(assign  ((name  \"x\" 'store)) (str \"\"))
(try ((bin-op  (num 1) / (num 0)) (assign  ((name  \"x\" 'store)) (str \"yes\"))) ((except-handler nil nil ((assign  ((name  \"x\" 'store)) (str \"no\"))))) ())
(assert  (compare  (name  \"x\" 'load) (\"==\") ((str \"no\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-try-419 nil (equal (py-ast "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='')), TryExcept(body=[Expr(value=BinOp(left=Num(n=1), op=Div(), right=Num(n=0))), Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='yes'))], handlers=[ExceptHandler(type=None, name=None, body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='no'))])], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Str(s='no')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-try-418 nil (equal (pyel "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'") (quote (progn (pyel-set x "") (condition-case nil (pyel-/ 1 0) (pyel-set x "yes") (error (pyel-set x "no"))) (assert (pyel-== x "no") t nil)))))
(ert-deftest pyel-el-ast-test-try-417 nil (string= (pyel "try:
 _a()
except:
 try:
  _x()
 except:
  _b()" t) "(try ((call  (name  \"_a\" 'load) nil nil nil nil)) ((except-handler nil nil ((try ((call  (name  \"_x\" 'load) nil nil nil nil)) ((except-handler nil nil ((call  (name  \"_b\" 'load) nil nil nil nil)))) ())))) ())
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-try-416 nil (equal (py-ast "try:
 _a()
except:
 try:
  _x()
 except:
  _b()") "Module(body=[TryExcept(body=[Expr(value=Call(func=Name(id='_a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[TryExcept(body=[Expr(value=Call(func=Name(id='_x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[Expr(value=Call(func=Name(id='_b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-try-415 nil (equal (pyel "try:
 _a()
except:
 try:
  _x()
 except:
  _b()") (quote (condition-case nil (pyel-fcall -a) (error (condition-case nil (pyel-fcall -x) (error (pyel-fcall -b))))))))
(ert-deftest pyel-el-ast-test-aug-assign-414 nil (string= (pyel "a += b" t) "(aug-assign (name  \"a\" 'store) + (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-413 nil (equal (py-ast "a += b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Add(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-412 nil (equal (pyel "a += b") (quote (pyel-set a (pyel-+ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-411 nil (string= (pyel "a -= b" t) "(aug-assign (name  \"a\" 'store) - (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-410 nil (equal (py-ast "a -= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Sub(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-409 nil (equal (pyel "a -= b") (quote (pyel-set a (pyel-- a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-408 nil (string= (pyel "a /= b" t) "(aug-assign (name  \"a\" 'store) / (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-407 nil (equal (py-ast "a /= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Div(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-406 nil (equal (pyel "a /= b") (quote (pyel-set a (pyel-/ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-405 nil (string= (pyel "a *= b" t) "(aug-assign (name  \"a\" 'store) * (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-404 nil (equal (py-ast "a *= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Mult(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-403 nil (equal (pyel "a *= b") (quote (pyel-set a (pyel-* a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-402 nil (string= (pyel "a **= b" t) "(aug-assign (name  \"a\" 'store) ** (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-401 nil (equal (py-ast "a **= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Pow(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-400 nil (equal (pyel "a **= b") (quote (pyel-set a (pyel-** a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-399 nil (string= (pyel "a ^= b" t) "(aug-assign (name  \"a\" 'store) ^ (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-398 nil (equal (py-ast "a ^= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitXor(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-397 nil (equal (pyel "a ^= b") (quote (pyel-set a (pyel-^ a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-396 nil (string= (pyel "a |= b" t) "(aug-assign (name  \"a\" 'store) | (name  \"b\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-395 nil (equal (py-ast "a |= b") "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitOr(), value=Name(id='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-394 nil (equal (pyel "a |= b") (quote (pyel-set a (pyel-| a b)))))
(ert-deftest pyel-el-ast-test-aug-assign-393 nil (string= (pyel "a = 3
b = 4
a += b + 1
assert a == 8" t) "(assign  ((name  \"a\" 'store)) (num 3))
(assign  ((name  \"b\" 'store)) (num 4))
(aug-assign (name  \"a\" 'store) + (bin-op  (name  \"b\" 'load) + (num 1)))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((num 8))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-392 nil (equal (py-ast "a = 3
b = 4
a += b + 1
assert a == 8") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=3)), Assign(targets=[Name(id='b', ctx=Store())], value=Num(n=4)), AugAssign(target=Name(id='a', ctx=Store()), op=Add(), value=BinOp(left=Name(id='b', ctx=Load()), op=Add(), right=Num(n=1))), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=8)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-391 nil (equal (pyel "a = 3
b = 4
a += b + 1
assert a == 8") (quote (progn (pyel-set a 3) (pyel-set b 4) (pyel-set a (pyel-+ a (pyel-+ b 1))) (assert (pyel-== a 8) t nil)))))
(ert-deftest pyel-el-ast-test-aug-assign-390 nil (string= (pyel "a.b += a[2]" t) "(aug-assign (attribute  (name  \"a\" 'load) \"b\" 'store) + (subscript (name  \"a\" 'load) (index (num 2)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-389 nil (equal (py-ast "a.b += a[2]") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-388 nil (equal (pyel "a.b += a[2]") (quote (setattr a b (pyel-+ (getattr a b) (pyel-subscript-load-index a 2))))))
(ert-deftest pyel-el-ast-test-aug-assign-387 nil (string= (pyel "a.b += 4" t) "(aug-assign (attribute  (name  \"a\" 'load) \"b\" 'store) + (num 4))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-386 nil (equal (py-ast "a.b += 4") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Num(n=4))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-385 nil (equal (pyel "a.b += 4") (quote (setattr a b (pyel-+ (getattr a b) 4)))))
(ert-deftest pyel-el-ast-test-aug-assign-384 nil (string= (pyel "a.b += d.e" t) "(aug-assign (attribute  (name  \"a\" 'load) \"b\" 'store) + (attribute  (name  \"d\" 'load) \"e\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-aug-assign-383 nil (equal (py-ast "a.b += d.e") "Module(body=[AugAssign(target=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), op=Add(), value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-aug-assign-382 nil (equal (pyel "a.b += d.e") (quote (setattr a b (pyel-+ (getattr a b) (getattr d e))))))
(ert-deftest pyel-el-ast-test-lambda-381 nil (string= (pyel "lambda x,y,z=4,*g: print(z);x()" t) "(lambda ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)))
(call  (name  \"x\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-lambda-380 nil (equal (py-ast "lambda x,y,z=4,*g: print(z);x()") "Module(body=[Expr(value=Lambda(args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))), Expr(value=Call(func=Name(id='x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-lambda-379 nil (equal (pyel "lambda x,y,z=4,*g: print(z);x()") (quote (progn (lambda (x y &optional z &rest g) nil (setq z (or z 4)) (py-print nil nil nil z)) (pyel-fcall x)))))
(ert-deftest pyel-el-ast-test-lambda-378 nil (string= (pyel "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35" t) "(assign  ((name  \"x\" 'store)) (call  (name  \"range\" 'load) ((num 2) (num 9)) nil nil nil))
(assign  ((name  \"x2\" 'store)) (call  (name  \"reduce\" 'load) ((lambda ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) (name  \"x\" 'load)) nil nil nil))
(assert  (compare  (name  \"x2\" 'load) (\"==\") ((num 35))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-lambda-377 nil (equal (py-ast "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='range', ctx=Load()), args=[Num(n=2), Num(n=9)], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='x2', ctx=Store())], value=Call(func=Name(id='reduce', ctx=Load()), args=[Lambda(args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load()))), Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x2', ctx=Load()), ops=[Eq()], comparators=[Num(n=35)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-lambda-376 nil (equal (pyel "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35") (quote (progn (pyel-set x (pyel-fcall py-range 2 9)) (pyel-set x2 (pyel-fcall reduce (lambda (a b) nil (pyel-+ a b)) x)) (assert (pyel-== x2 35) t nil)))))
(ert-deftest pyel-el-ast-test-global-375 nil (string= (pyel "def a():
 global x
 x = 3
 y = 1" t) "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x)) (assign  ((name  \"x\" 'store)) (num 3)) (assign  ((name  \"y\" 'store)) (num 1))) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-global-374 nil (equal (py-ast "def a():
 global x
 x = 3
 y = 1") "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=3)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-global-373 nil (equal (pyel "def a():
 global x
 x = 3
 y = 1") (quote (def a nil nil (let (y) (pyel-set x 3) (pyel-set y 1))))))
(ert-deftest pyel-el-ast-test-global-372 nil (string= (pyel "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
" t) "(assign  ((name  \"x\" 'store)) (num 1))
(assign  ((name  \"y\" 'store)) (num 1))
(def \" func \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x)) (assign  ((name  \"x\" 'store)) (num 7)) (assign  ((name  \"y\" 'store)) (num 7))) nil nil )
(call  (name  \"func\" 'load) nil nil nil nil)
(assert  (compare  (name  \"x\" 'load) (\"==\") ((num 7))) nil)
(assert  (compare  (name  \"y\" 'load) (\"==\") ((num 1))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-global-371 nil (equal (py-ast "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=1)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1)), FunctionDef(name='func', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=7)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=7))], decorator_list=[], returns=None), Expr(value=Call(func=Name(id='func', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Num(n=7)]), msg=None), Assert(test=Compare(left=Name(id='y', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-global-370 nil (equal (pyel "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
") (quote (progn (pyel-set x 1) (pyel-set y 1) (def func nil nil (let (y) (pyel-set x 7) (pyel-set y 7))) (pyel-fcall func) (assert (pyel-== x 7) t nil) (assert (pyel-== y 1) t nil)))))
(ert-deftest pyel-el-ast-test-for-loop-369 nil (string= (pyel "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10" t) "(assign  ((name  \"b\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))
(assign  ((name  \"c\" 'store)) (num 0))
(for  (name  \"a\" 'store) (name  \"b\" 'load) ((assign  ((name  \"c\" 'store)) (bin-op  (name  \"c\" 'load) + (name  \"a\" 'load)))) nil)
(assert  (compare  (name  \"c\" 'load) (\"==\") ((num 10))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-for-loop-368 nil (equal (py-ast "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10") "Module(body=[Assign(targets=[Name(id='b', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Name(id='c', ctx=Store())], value=Num(n=0)), For(target=Name(id='a', ctx=Store()), iter=Name(id='b', ctx=Load()), body=[Assign(targets=[Name(id='c', ctx=Store())], value=BinOp(left=Name(id='c', ctx=Load()), op=Add(), right=Name(id='a', ctx=Load())))], orelse=[]), Assert(test=Compare(left=Name(id='c', ctx=Load()), ops=[Eq()], comparators=[Num(n=10)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-for-loop-367 nil (equal (pyel "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10") (quote (progn (pyel-set b (list 1 2 3 4)) (pyel-set c 0) (py-for a in b (pyel-set c (pyel-+ c a))) (assert (pyel-== c 10) t nil)))))
(ert-deftest pyel-el-ast-test-for-loop-366 nil (string= (pyel "for i in range(n):
 break" t) "(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((name  \"n\" 'load)) nil nil nil) ((break)) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-for-loop-365 nil (equal (py-ast "for i in range(n):
 break") "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Break()], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-for-loop-364 nil (equal (pyel "for i in range(n):
 break") (quote (py-for i in (pyel-fcall py-range n) (break)))))
(ert-deftest pyel-el-ast-test-for-loop-363 nil (string= (pyel "for i in range(n):
 continue" t) "(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((name  \"n\" 'load)) nil nil nil) ((continue)) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-for-loop-362 nil (equal (py-ast "for i in range(n):
 continue") "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Continue()], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-for-loop-361 nil (equal (pyel "for i in range(n):
 continue") (quote (py-for i in (pyel-fcall py-range n) (continue)))))
(ert-deftest pyel-el-ast-test-for-loop-360 nil (string= (pyel "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]" t) "(assign  ((name  \"x\" 'store)) (list nil 'load))
(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 5)) nil nil nil) ((if  (compare  (name  \"i\" 'load) (\"==\") ((num 2))) ((continue)) nil) (call  (attribute  (name  \"x\" 'load) \"append\" 'load) ((name  \"i\" 'load)) nil nil nil)) nil)
(assert  (compare  (name  \"x\" 'load) (\"==\") ((list ((num 0) (num 1) (num 3) (num 4)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-for-loop-359 nil (equal (py-ast "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=5)], keywords=[], starargs=None, kwargs=None), body=[If(test=Compare(left=Name(id='i', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), body=[Continue()], orelse=[]), Expr(value=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='append', ctx=Load()), args=[Name(id='i', ctx=Load())], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=0), Num(n=1), Num(n=3), Num(n=4)], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-for-loop-358 nil (equal (pyel "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]") (quote (progn (pyel-set x (list)) (py-for i in (pyel-fcall py-range 5) (if (pyel-== i 2) (continue)) (pyel-append-method x i)) (assert (pyel-== x (list 0 1 3 4)) t nil)))))
(ert-deftest pyel-el-ast-test-lambda-357 nil (string= (pyel "x = [2,3,4]
square = lambda([x]
 x*x)
y = mapcar(square,x)
assert y == [4,9,16]
" t) "(assign  ((name  \"x\" 'store)) (list ((num 2) (num 3) (num 4)) 'load))
(assign  ((name  \"square\" 'store)) (name  \"test_marker\" 'load))
(assign  ((name  \"y\" 'store)) (call  (name  \"mapcar\" 'load) ((name  \"square\" 'load) (name  \"x\" 'load)) nil nil nil))
(assert  (compare  (name  \"y\" 'load) (\"==\") ((list ((num 4) (num 9) (num 16)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-lambda-356 nil (equal (py-ast "x = [2,3,4]
square = lambda([x]
 x*x)
y = mapcar(square,x)
assert y == [4,9,16]
") "Traceback (most recent call last):
  File \"/tmp/pyel-ast.py\", line 7, in <module>
    \"\"\")))
  File \"/usr/lib/python3.2/ast.py\", line 36, in parse
    return compile(source, filename, mode, PyCF_ONLY_AST)
  File \"<unknown>\", line 2
    square = lambda([x]
                   ^
SyntaxError: invalid syntax
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-lambda-355 nil (equal (pyel "x = [2,3,4]
square = lambda([x]
 x*x)
y = mapcar(square,x)
assert y == [4,9,16]
") (quote (progn (pyel-set x (list 2 3 4)) (pyel-set square (lambda (x) (pyel-* x x))) (pyel-set y (pyel-fcall mapcar square x)) (assert (pyel-== y (list 4 9 16)) t nil)))))
(ert-deftest pyel-el-ast-test-lambda-354 nil (string= (pyel "f = lambda([x,y]
if x > y:
 'x'
else:
 'y')
x=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])
assert x == ['y', 'y', 'x', 'y', 'x']" t) "(assign  ((name  \"f\" 'store)) (name  \"test_marker\" 'load))
(assign  ((name  \"x\" 'store)) (call  (name  \"cl_mapcar\" 'load) ((name  \"f\" 'load) (list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load) (list ((num 4) (num 2) (num 1) (num 6) (num 3)) 'load)) nil nil nil))
(assert  (compare  (name  \"x\" 'load) (\"==\") ((list ((str \"y\") (str \"y\") (str \"x\") (str \"y\") (str \"x\")) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-lambda-353 nil (equal (py-ast "f = lambda([x,y]
if x > y:
 'x'
else:
 'y')
x=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])
assert x == ['y', 'y', 'x', 'y', 'x']") "Traceback (most recent call last):
  File \"/tmp/pyel-ast.py\", line 8, in <module>
    assert x == ['y', 'y', 'x', 'y', 'x']\"\"\")))
  File \"/usr/lib/python3.2/ast.py\", line 36, in parse
    return compile(source, filename, mode, PyCF_ONLY_AST)
  File \"<unknown>\", line 1
    f = lambda([x,y]
              ^
SyntaxError: invalid syntax
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-lambda-352 nil (equal (pyel "f = lambda([x,y]
if x > y:
 'x'
else:
 'y')
x=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])
assert x == ['y', 'y', 'x', 'y', 'x']") (quote (progn (pyel-set f (lambda (x y) (if (pyel-> x y) "x"))) (pyel-set x (pyel-fcall cl-mapcar f (list 1 2 3 4 5) (list 4 2 1 6 3))) (assert (pyel-== x (list "y" "y" "x" "y" "x")) t nil)))))
(ert-deftest pyel-el-ast-test-cond-351 nil (string= (pyel "x = cond([1 > 2, 'first']
   [2 == 2, 'second']
   [5 == 7, 'third']
   [True, error('wtf')])
assert x == 'second'" t) "(assign  ((name  \"x\" 'store)) (name  \"test_marker\" 'load))
(assert  (compare  (name  \"x\" 'load) (\"==\") ((str \"second\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-cond-350 nil (equal (py-ast "x = cond([1 > 2, 'first']
   [2 == 2, 'second']
   [5 == 7, 'third']
   [True, error('wtf')])
assert x == 'second'") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='cond', ctx=Load()), args=[Subscript(value=Subscript(value=Subscript(value=List(elts=[Compare(left=Num(n=1), ops=[Gt()], comparators=[Num(n=2)]), Str(s='first')], ctx=Load()), slice=Index(value=Tuple(elts=[Compare(left=Num(n=2), ops=[Eq()], comparators=[Num(n=2)]), Str(s='second')], ctx=Load())), ctx=Load()), slice=Index(value=Tuple(elts=[Compare(left=Num(n=5), ops=[Eq()], comparators=[Num(n=7)]), Str(s='third')], ctx=Load())), ctx=Load()), slice=Index(value=Tuple(elts=[Name(id='True', ctx=Load()), Call(func=Name(id='error', ctx=Load()), args=[Str(s='wtf')], keywords=[], starargs=None, kwargs=None)], ctx=Load())), ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Str(s='second')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-cond-349 nil (equal (pyel "x = cond([1 > 2, 'first']
   [2 == 2, 'second']
   [5 == 7, 'third']
   [True, error('wtf')])
assert x == 'second'") (quote (progn (pyel-set x (cond ((pyel-> 1 2) "first") ((pyel-== 2 2) "second") ((pyel-== 5 7) "third") (t (pyel-fcall error "wtf")))) (assert (pyel-== x "second") t nil)))))
(ert-deftest pyel-el-ast-test-len-346 nil (string= (pyel "a = [1,2,3,'5']
assert len(a) == 4" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (str \"5\")) 'load))
(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 4))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-len-345 nil (equal (py-ast "a = [1,2,3,'5']
assert len(a) == 4") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Str(s='5')], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=4)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-len-344 nil (equal (pyel "a = [1,2,3,'5']
assert len(a) == 4") (quote (progn (pyel-set a (list 1 2 3 "5")) (assert (pyel-== (pyel-len-function a) 4) t nil)))))
(ert-deftest pyel-el-ast-test-len-343 nil (string= (pyel "a = []
assert len(a) == 0" t) "(assign  ((name  \"a\" 'store)) (list nil 'load))
(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 0))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-len-342 nil (equal (py-ast "a = []
assert len(a) == 0") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-len-341 nil (equal (pyel "a = []
assert len(a) == 0") (quote (progn (pyel-set a (list)) (assert (pyel-== (pyel-len-function a) 0) t nil)))))
(ert-deftest pyel-el-ast-test-len-340 nil (string= (pyel "a = 'str'
assert len(a) == 3" t) "(assign  ((name  \"a\" 'store)) (str \"str\"))
(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 3))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-len-339 nil (equal (py-ast "a = 'str'
assert len(a) == 3") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=3)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-len-338 nil (equal (pyel "a = 'str'
assert len(a) == 3") (quote (progn (pyel-set a "str") (assert (pyel-== (pyel-len-function a) 3) t nil)))))
(ert-deftest pyel-el-ast-test-len-337 nil (string= (pyel "a = (1,2)
assert len(a) == 2" t) "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2)) 'load))
(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 2))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-len-336 nil (equal (py-ast "a = (1,2)
assert len(a) == 2") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2)], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-len-335 nil (equal (pyel "a = (1,2)
assert len(a) == 2") (quote (progn (pyel-set a (vector 1 2)) (assert (pyel-== (pyel-len-function a) 2) t nil)))))
(ert-deftest pyel-el-ast-test-len-334 nil (string= (pyel "assert len('')==0" t) "(assert  (compare  (call  (name  \"len\" 'load) ((str \"\")) nil nil nil) (\"==\") ((num 0))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-len-333 nil (equal (py-ast "assert len('')==0") "Module(body=[Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Str(s='')], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-len-332 nil (equal (pyel "assert len('')==0") (quote (assert (pyel-== (pyel-len-function "") 0) t nil))))
(ert-deftest pyel-el-ast-test-append-331 nil (string= (pyel "a=[1,2,3]
a.append('str')
assert len(a) == 4
assert a[3] == 'str'" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3)) 'load))
(call  (attribute  (name  \"a\" 'load) \"append\" 'load) ((str \"str\")) nil nil nil)
(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 4))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 3)) 'load) (\"==\") ((str \"str\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-append-330 nil (equal (py-ast "a=[1,2,3]
a.append('str')
assert len(a) == 4
assert a[3] == 'str'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())), Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='append', ctx=Load()), args=[Str(s='str')], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=4)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-append-329 nil (equal (pyel "a=[1,2,3]
a.append('str')
assert len(a) == 4
assert a[3] == 'str'") (quote (progn (pyel-set a (list 1 2 3)) (pyel-append-method a "str") (assert (pyel-== (pyel-len-function a) 4) t nil) (assert (pyel-== (pyel-subscript-load-index a 3) "str") t nil)))))
(ert-deftest pyel-el-ast-test-assert-328 nil (string= (pyel "assert sldk()" t) "(assert  (call  (name  \"sldk\" 'load) nil nil nil nil) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assert-327 nil (equal (py-ast "assert sldk()") "Module(body=[Assert(test=Call(func=Name(id='sldk', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assert-326 nil (equal (pyel "assert sldk()") (quote (assert (pyel-fcall sldk) t nil))))
(ert-deftest pyel-el-ast-test-assert-325 nil (string= (pyel "assert adk,'messsage'" t) "(assert  (name  \"adk\" 'load) (str \"messsage\"))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assert-324 nil (equal (py-ast "assert adk,'messsage'") "Module(body=[Assert(test=Name(id='adk', ctx=Load()), msg=Str(s='messsage'))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assert-323 nil (equal (pyel "assert adk,'messsage'") (quote (assert adk t "messsage"))))
(ert-deftest pyel-el-ast-test-subscript-319 nil (string= (pyel "a = '1X23'
assert a[1] == 'X'" t) "(assign  ((name  \"a\" 'store)) (str \"1X23\"))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((str \"X\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-318 nil (equal (py-ast "a = '1X23'
assert a[1] == 'X'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='1X23')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='X')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-317 nil (equal (pyel "a = '1X23'
assert a[1] == 'X'") (quote (progn (pyel-set a "1X23") (assert (pyel-== (pyel-subscript-load-index a 1) "X") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-316 nil (string= (pyel "a = [1,2,3,4]
assert a[1] == 2" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((num 2))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-315 nil (equal (py-ast "a = [1,2,3,4]
assert a[1] == 2") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-314 nil (equal (pyel "a = [1,2,3,4]
assert a[1] == 2") (quote (progn (pyel-set a (list 1 2 3 4)) (assert (pyel-== (pyel-subscript-load-index a 1) 2) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-313 nil (string= (pyel "a = (1,2,3,4)
assert a[1] == 2" t) "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((num 2))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-312 nil (equal (py-ast "a = (1,2,3,4)
assert a[1] == 2") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-311 nil (equal (pyel "a = (1,2,3,4)
assert a[1] == 2") (quote (progn (pyel-set a (vector 1 2 3 4)) (assert (pyel-== (pyel-subscript-load-index a 1) 2) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-310 nil (string= (pyel "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5" t) "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"value\" 'load) + (num 4)))) nil nil )) nil)
(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))
(assert  (compare  (subscript (name  \"x\" 'load) (index (num 1)) 'load) (\"==\") ((num 5))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-309 nil (equal (py-ast "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='value', ctx=Load()), op=Add(), right=Num(n=4)))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-308 nil (equal (pyel "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5") (quote (progn (define-class a nil (def --getitem-- (self value) nil (pyel-+ value 4))) (pyel-set x (pyel-fcall a)) (assert (pyel-== (pyel-subscript-load-index x 1) 5) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-307 nil (string= (pyel "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)" t) "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((tuple  ((num 2) (num 3) (num 4)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((tuple  ((num 3) (num 4) (num 5)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((tuple  ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-306 nil (equal (py-ast "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-305 nil (equal (pyel "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)") (quote (progn (pyel-set a (vector 1 2 3 4 5)) (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) (vector 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) (vector 1 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) (vector 3 4 5)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) (vector 1 2 3 4 5)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-304 nil (string= (pyel "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((list ((num 2) (num 3) (num 4)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((list ((num 1) (num 2) (num 3) (num 4)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((list ((num 3) (num 4) (num 5)) 'load))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-303 nil (equal (py-ast "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-302 nil (equal (pyel "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]") (quote (progn (pyel-set a (list 1 2 3 4 5)) (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) (list 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) (list 1 2 3 4)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) (list 3 4 5)) t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) (list 1 2 3 4 5)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-301 nil (string= (pyel "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'" t) "(assign  ((name  \"a\" 'store)) (str \"012345678\"))
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((str \"123\"))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((str \"0123\"))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((str \"2345678\"))) nil)
(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((str \"012345678\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-300 nil (equal (py-ast "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='012345678')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='0123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='2345678')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='012345678')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-299 nil (equal (pyel "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'") (quote (progn (pyel-set a "012345678") (assert (pyel-== (pyel-subscript-load-slice a 1 4 nil) "123") t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 4 nil) "0123") t nil) (assert (pyel-== (pyel-subscript-load-slice a 2 nil nil) "2345678") t nil) (assert (pyel-== (pyel-subscript-load-slice a 0 nil nil) "012345678") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-298 nil (string= (pyel "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12" t) "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (attribute  (name  \"value\" 'load) \"start\" 'load) + (attribute  (name  \"value\" 'load) \"end\" 'load)))) nil nil )) nil)
(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))
(assert  (compare  (subscript (name  \"x\" 'load) (slice (num 1) (num 2) nil) 'load) (\"==\") ((num 3))) nil)
(assert  (compare  (subscript (name  \"x\" 'load) (slice (num 5) (num 7) nil) 'load) (\"==\") ((num 12))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-297 nil (equal (py-ast "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Attribute(value=Name(id='value', ctx=Load()), attr='start', ctx=Load()), op=Add(), right=Attribute(value=Name(id='value', ctx=Load()), attr='end', ctx=Load())))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=2), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=5), upper=Num(n=7), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=12)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-296 nil (equal (pyel "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12") (quote (progn (define-class a nil (def --getitem-- (self value) nil (pyel-+ (getattr value start) (getattr value end)))) (pyel-set x (pyel-fcall a)) (assert (pyel-== (pyel-subscript-load-slice x 1 2 nil) 3) t nil) (assert (pyel-== (pyel-subscript-load-slice x 5 7 nil) 12) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-295 nil (string= (pyel "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'" t) "(def \" __add \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) nil nil )
(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))
(assign  ((subscript (name  \"a\" 'load) (index (num 0)) 'store)) (call  (name  \"__add\" 'load) ((subscript (name  \"a\" 'load) (index (num 1)) 'load) (subscript (name  \"a\" 'load) (index (num 2)) 'load)) nil nil nil))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 0)) 'load) (\"==\") ((num 5))) nil)
(assign  ((subscript (name  \"a\" 'load) (index (num 2)) 'store)) (str \"str\"))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 2)) 'load) (\"==\") ((str \"str\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-294 nil (equal (py-ast "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'") "Module(body=[FunctionDef(name='__add', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], decorator_list=[], returns=None), Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=Call(func=Name(id='__add', ctx=Load()), args=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-293 nil (equal (pyel "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'") (quote (progn (def --add (a b) nil (pyel-+ a b)) (pyel-set a (list 1 2 3 4)) (pyel-subscript-store-index a 0 (pyel-fcall --add (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2))) (assert (pyel-== (pyel-subscript-load-index a 0) 5) t nil) (pyel-subscript-store-index a 2 "str") (assert (pyel-== (pyel-subscript-load-index a 2) "str") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-292 nil (string= (pyel "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'" t) "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))
(assign  ((subscript (name  \"a\" 'load) (index (num 0)) 'store)) (bin-op  (subscript (name  \"a\" 'load) (index (num 1)) 'load) + (subscript (name  \"a\" 'load) (index (num 2)) 'load)))
(assert  (compare  (subscript (name  \"aa\" 'load) (index (num 0)) 'load) (\"==\") ((num 5))) nil)
(assign  ((subscript (name  \"a\" 'load) (index (num 2)) 'store)) (str \"str\"))
(assert  (compare  (subscript (name  \"a\" 'load) (index (num 2)) 'load) (\"==\") ((str \"str\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-291 nil (equal (py-ast "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=BinOp(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), op=Add(), right=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))), Assert(test=Compare(left=Subscript(value=Name(id='aa', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-290 nil (equal (pyel "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'") (quote (progn (pyel-set a (vector 1 2 3 4)) (pyel-subscript-store-index a 0 (pyel-+ (pyel-subscript-load-index a 1) (pyel-subscript-load-index a 2))) (assert (pyel-== (pyel-subscript-load-index aa 0) 5) t nil) (pyel-subscript-store-index a 2 "str") (assert (pyel-== (pyel-subscript-load-index a 2) "str") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-289 nil (string= (pyel "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5" t) "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load) \"index\" 'store)) (name  \"index\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"value\" 'store)) (name  \"value\" 'load))) nil nil )) nil)
(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))
(assign  ((subscript (name  \"x\" 'load) (index (num 3)) 'store)) (num 5))
(assert  (compare  (attribute  (name  \"x\" 'load) \"index\" 'load) (\"==\") ((num 3))) nil)
(assert  (compare  (attribute  (name  \"x\" 'load) \"value\" 'load) (\"==\") ((num 5))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-288 nil (equal (py-ast "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5") "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__setitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='index', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='index', ctx=Store())], value=Name(id='index', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='value', ctx=Store())], value=Name(id='value', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Store())], value=Num(n=5)), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='index', ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='value', ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-287 nil (equal (pyel "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5") (quote (progn (define-class a nil (def --setitem-- (self index value) nil (setattr self index index) (setattr self value value))) (pyel-set x (pyel-fcall a)) (pyel-subscript-store-index x 3 5) (assert (pyel-== (getattr x index) 3) t nil) (assert (pyel-== (getattr x value) 5) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-286 nil (string= (pyel "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4) (num 5) (num 6)) 'load))
(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (list ((num 5) (num 4) (str \"f\")) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((num 1) (num 5) (num 4) (str \"f\") (num 5) (num 6)) 'load))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (list ((str \"a\") (num 4) (num 2.2)) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((str \"a\") (num 4) (num 2.2) (str \"f\") (num 5) (num 6)) 'load))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (list ((num 3) (num 3)) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((str \"a\") (num 4) (num 2.2) (num 3) (num 3) (num 6)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-285 nil (equal (py-ast "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=List(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=List(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=List(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-284 nil (equal (pyel "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]") (quote (progn (pyel-set a (list 1 2 3 4 5 6)) (pyel-subscript-store-slice a 1 4 nil (list 5 4 "f")) (assert (pyel-== a (list 1 5 4 "f" 5 6)) t nil) (pyel-subscript-store-slice a 0 3 nil (list "a" 4 2.2)) (assert (pyel-== a (list "a" 4 2.2 "f" 5 6)) t nil) (pyel-subscript-store-slice a 3 nil nil (list 3 3)) (assert (pyel-== a (list "a" 4 2.2 3 3 6)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-283 nil (string= (pyel "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)" t) "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4) (num 5) (num 6)) 'load))
(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (tuple  ((num 5) (num 4) (str \"f\")) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((num 1) (num 5) (num 4) (str \"f\") (num 5) (num 6)) 'load))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (tuple  ((str \"a\") (num 4) (num 2.2)) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((str \"a\") (num 4) (num 2.2) (str \"f\") (num 5) (num 6)) 'load))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (tuple  ((num 3) (num 3)) 'load))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((str \"a\") (num 4) (num 2.2) (num 3) (num 3) (num 6)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-282 nil (equal (py-ast "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Tuple(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Tuple(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-281 nil (equal (pyel "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)") (quote (progn (pyel-set a (vector 1 2 3 4 5 6)) (pyel-subscript-store-slice a 1 4 nil (vector 5 4 "f")) (assert (pyel-== a (vector 1 5 4 "f" 5 6)) t nil) (pyel-subscript-store-slice a 0 3 nil (vector "a" 4 2.2)) (assert (pyel-== a (vector "a" 4 2.2 "f" 5 6)) t nil) (pyel-subscript-store-slice a 3 nil nil (vector 3 3)) (assert (pyel-== a (vector "a" 4 2.2 3 3 6)) t nil)))))
(ert-deftest pyel-el-ast-test-subscript-280 nil (string= (pyel "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'" t) "(assign  ((name  \"a\" 'store)) (str \"123456\"))
(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (str \"54f\"))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"154f56\"))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (str \"a42\"))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"a42f56\"))) nil)
(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (str \"33\"))
(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"a42336\"))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-279 nil (equal (py-ast "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='123456')), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Str(s='54f')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='154f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Str(s='a42')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Str(s='33')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42336')]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-278 nil (equal (pyel "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'") (quote (progn (pyel-set a "123456") (pyel-subscript-store-slice a 1 4 nil "54f") (assert (pyel-== a "154f56") t nil) (pyel-subscript-store-slice a 0 3 nil "a42") (assert (pyel-== a "a42f56") t nil) (pyel-subscript-store-slice a 3 nil nil "33") (assert (pyel-== a "a42336") t nil)))))
(ert-deftest pyel-el-ast-test-subscript-277 nil (string= (pyel "class a:
 def __setitem__ (self, index, value):
  self.start = index.start
  self.end = index.end
  self.step = index.step
  self.value = value
x = a()
x[2:3] = [1,2,3]
assert x.start == 2
assert x.end == 3
assert x.value == [1,2,3]" t) "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load) \"start\" 'store)) (attribute  (name  \"index\" 'load) \"start\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"end\" 'store)) (attribute  (name  \"index\" 'load) \"end\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"step\" 'store)) (attribute  (name  \"index\" 'load) \"step\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"value\" 'store)) (name  \"value\" 'load))) nil nil )) nil)
(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))
(assign  ((subscript (name  \"x\" 'load) (slice (num 2) (num 3) nil) 'store)) (list ((num 1) (num 2) (num 3)) 'load))
(assert  (compare  (attribute  (name  \"x\" 'load) \"start\" 'load) (\"==\") ((num 2))) nil)
(assert  (compare  (attribute  (name  \"x\" 'load) \"end\" 'load) (\"==\") ((num 3))) nil)
(assert  (compare  (attribute  (name  \"x\" 'load) \"value\" 'load) (\"==\") ((list ((num 1) (num 2) (num 3)) 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-276 nil (equal (py-ast "class a:
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
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-275 nil (equal (pyel "class a:
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
(ert-deftest pyel-el-ast-test-subscript-274 nil (string= (pyel "a[2] += 3" t) "(aug-assign (subscript (name  \"a\" 'load) (index (num 2)) 'store) + (num 3))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-273 nil (equal (py-ast "a[2] += 3") "Module(body=[AugAssign(target=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), op=Add(), value=Num(n=3))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-272 nil (equal (pyel "a[2] += 3") (quote (pyel-subscript-store-index a 2 (pyel-+ (pyel-subscript-load-index a 2) 3)))))
(ert-deftest pyel-el-ast-test-subscript-271 nil (string= (pyel "a[2] += b[3]" t) "(aug-assign (subscript (name  \"a\" 'load) (index (num 2)) 'store) + (subscript (name  \"b\" 'load) (index (num 3)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-270 nil (equal (py-ast "a[2] += b[3]") "Module(body=[AugAssign(target=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), op=Add(), value=Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-269 nil (equal (pyel "a[2] += b[3]") (quote (pyel-subscript-store-index a 2 (pyel-+ (pyel-subscript-load-index a 2) (pyel-subscript-load-index b 3))))))
(ert-deftest pyel-el-ast-test-subscript-268 nil (string= (pyel "[2,3,3][2]" t) "(subscript (list ((num 2) (num 3) (num 3)) 'load) (index (num 2)) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-267 nil (equal (py-ast "[2,3,3][2]") "Module(body=[Expr(value=Subscript(value=List(elts=[Num(n=2), Num(n=3), Num(n=3)], ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-266 nil (equal (pyel "[2,3,3][2]") (quote (pyel-subscript-load-index (list 2 3 3) 2))))
(ert-deftest pyel-el-ast-test-subscript-265 nil (string= (pyel "assert [1,2,(3,2,8)][2][2] == 8" t) "(assert  (compare  (subscript (subscript (list ((num 1) (num 2) (tuple  ((num 3) (num 2) (num 8)) 'load)) 'load) (index (num 2)) 'load) (index (num 2)) 'load) (\"==\") ((num 8))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-subscript-264 nil (equal (py-ast "assert [1,2,(3,2,8)][2][2] == 8") "Module(body=[Assert(test=Compare(left=Subscript(value=Subscript(value=List(elts=[Num(n=1), Num(n=2), Tuple(elts=[Num(n=3), Num(n=2), Num(n=8)], ctx=Load())], ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Num(n=8)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-subscript-263 nil (equal (pyel "assert [1,2,(3,2,8)][2][2] == 8") (quote (assert (pyel-== (pyel-subscript-load-index (pyel-subscript-load-index (list 1 2 (vector 3 2 8)) 2) 2) 8) t nil))))
(ert-deftest pyel-el-ast-test-binop-262 nil (string= (pyel "assert 1//2 == 0" t) "(assert  (compare  (bin-op  (num 1) // (num 2)) (\"==\") ((num 0))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-binop-261 nil (equal (py-ast "assert 1//2 == 0") "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=FloorDiv(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-binop-260 nil (equal (pyel "assert 1//2 == 0") (quote (assert (pyel-== (pyel-// 1 2) 0) t nil))))
(ert-deftest pyel-el-ast-test-binop-259 nil (string= (pyel "assert 1/2 == 0.5" t) "(assert  (compare  (bin-op  (num 1) / (num 2)) (\"==\") ((num 0.5))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-binop-258 nil (equal (py-ast "assert 1/2 == 0.5") "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=Div(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0.5)]), msg=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-binop-257 nil (equal (pyel "assert 1/2 == 0.5") (quote (assert (pyel-== (pyel-/ 1 2) 0.5) t nil))))
(ert-deftest pyel-el-ast-test-def-255 nil (string= (pyel "def a(b,c):
  print('ok')
  a=b" t) "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((call  (name  \"print\" 'load) ((str \"ok\")) nil nil nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-254 nil (equal (py-ast "def a(b,c):
  print('ok')
  a=b") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='ok')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-253 nil (equal (pyel "def a(b,c):
  print('ok')
  a=b") (quote (def a (b c) nil (let (a) (py-print nil nil nil "ok") (pyel-set a b))))))
(ert-deftest pyel-el-ast-test-def-252 nil (string= (pyel "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]" t) "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((if  (compare  (name  \"a\" 'load) (\"==\") ((call  (name  \"b\" 'load) nil nil nil nil))) ((call  (name  \"c\" 'load) nil nil nil nil) (while  (compare  (name  \"a\" 'load) (\"<\") ((attribute  (name  \"d\" 'load) \"b\" 'load))) ((assign  ((tuple  ((name  \"b\" 'store) (name  \"c\" 'store)) 'store)) (tuple  ((num 1) (num 3)) 'load))) nil)) nil) (assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (list ((name  \"a\" 'load) (tuple  ((num 2) (num 2)) 'load)) 'load))) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-251 nil (equal (py-ast "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), body=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Attribute(value=Name(id='d', ctx=Load()), attr='b', ctx=Load())]), body=[Assign(targets=[Tuple(elts=[Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()))], orelse=[])], orelse=[]), Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Num(n=2), Num(n=2)], ctx=Load())], ctx=Load()))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-250 nil (equal (pyel "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]") (quote (def a (b c) nil (if (pyel-== a (pyel-fcall b)) (progn (pyel-fcall c) (while (pyel-< a (getattr d b)) (let ((__1__ 1) (__2__ 3)) (pyel-set b __1__) (pyel-set c __2__))))) (setattr (getattr a b) c (list a (vector 2 2)))))))
(ert-deftest pyel-el-ast-test-def-249 nil (string= (pyel "def a():
  return time()" t) "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((return (call  (name  \"time\" 'load) nil nil nil nil))) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-248 nil (equal (py-ast "def a():
  return time()") "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=Call(func=Name(id='time', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-247 nil (equal (pyel "def a():
  return time()") (quote (def a nil nil (pyel-fcall time)))))
(ert-deftest pyel-el-ast-test-def-246 nil (string= (pyel "def a(x,y=2,z=4):
 print(z)" t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 2) (num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-245 nil (equal (py-ast "def a(x,y=2,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-244 nil (equal (pyel "def a(x,y=2,z=4):
 print(z)") (quote (def a (x &optional y z) nil (setq z (or z 4)) (setq y (or y 2)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-243 nil (string= (pyel "def a(x=1,y=2,z=4):
 print(z)" t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 1) (num 2) (num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-242 nil (equal (py-ast "def a(x=1,y=2,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1), Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-241 nil (equal (pyel "def a(x=1,y=2,z=4):
 print(z)") (quote (def a (&optional x y z) nil (setq z (or z 4)) (setq y (or y 2)) (setq x (or x 1)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-240 nil (string= (pyel "def a(x,y,z=4):
 print(z)" t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-239 nil (equal (py-ast "def a(x,y,z=4):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-238 nil (equal (pyel "def a(x,y,z=4):
 print(z)") (quote (def a (x y &optional z) nil (setq z (or z 4)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-237 nil (string= (pyel "def a(x,y,z=4,*g):
 print(z)" t) "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-236 nil (equal (py-ast "def a(x,y,z=4,*g):
 print(z)") "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-235 nil (equal (pyel "def a(x,y,z=4,*g):
 print(z)") (quote (def a (x y &optional z &rest g) nil (setq z (or z 4)) (py-print nil nil nil z)))))
(ert-deftest pyel-el-ast-test-def-234 nil (string= (pyel "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4" t) "(def \" pyel_test \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) c nil nil nil nil ((num 1)) nil )) ((if  (name  \"ab\" 'load) ((assign  ((name  \"x\" 'store)) (bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) nil) (assign  ((name  \"y\" 'store)) (num 3)) (call  (name  \"_a_\" 'load) nil nil nil nil) (assign  ((attribute  (name  \"z\" 'load) \"a\" 'store)) (num 4))) nil nil )
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-def-233 nil (equal (py-ast "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4") "Module(body=[FunctionDef(name='pyel_test', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg='c', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1)], kw_defaults=[]), body=[If(test=Name(id='ab', ctx=Load()), body=[Assign(targets=[Name(id='x', ctx=Store())], value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], orelse=[]), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=3)), Expr(value=Call(func=Name(id='_a_', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Attribute(value=Name(id='z', ctx=Load()), attr='a', ctx=Store())], value=Num(n=4))], decorator_list=[], returns=None)])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-def-232 nil (equal (pyel "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4") (quote (def pyel-test (a &optional b &rest c) nil (setq b (or b 1)) (let (x y) (if ab (pyel-set x (pyel-+ a b))) (pyel-set y 3) (pyel-fcall -a-) (setattr z a 4))))))
(ert-deftest pyel-el-ast-test-while-231 nil (string= (pyel "while (a==b):
  print('hi')" t) "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((call  (name  \"print\" 'load) ((str \"hi\")) nil nil nil)) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-while-230 nil (equal (py-ast "while (a==b):
  print('hi')") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None))], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-while-229 nil (equal (pyel "while (a==b):
  print('hi')") (quote (while (pyel-== a b) (py-print nil nil nil "hi")))))
(ert-deftest pyel-el-ast-test-while-228 nil (string= (pyel "while (a==b):
  print('hi')
  a=b" t) "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((call  (name  \"print\" 'load) ((str \"hi\")) nil nil nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-while-227 nil (equal (py-ast "while (a==b):
  print('hi')
  a=b") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-while-226 nil (equal (pyel "while (a==b):
  print('hi')
  a=b") (quote (while (pyel-== a b) (py-print nil nil nil "hi") (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-while-225 nil (string= (pyel "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b" t) "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((while  (compare  (name  \"a\" 'load) (\">\") ((num 2))) ((call  (name  \"b\" 'load) ((num 3) (list ((name  \"a\" 'load) (num 2)) 'load)) nil nil nil) (assign  ((name  \"b\" 'store)) (attribute  (name  \"c\" 'load) \"e\" 'load))) nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-while-224 nil (equal (py-ast "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b") "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Num(n=2)]), body=[Expr(value=Call(func=Name(id='b', ctx=Load()), args=[Num(n=3), List(elts=[Name(id='a', ctx=Load()), Num(n=2)], ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))], orelse=[]), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-while-223 nil (equal (pyel "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b") (quote (while (pyel-== a b) (while (pyel-> a 2) (pyel-fcall b 3 (list a 2)) (pyel-set b (getattr c e))) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-while-222 nil (string= (pyel "while a:
 if b:
  break
 else:
  c()" t) "(while  (name  \"a\" 'load) ((if  (name  \"b\" 'load) ((break)) ((call  (name  \"c\" 'load) nil nil nil nil)))) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-while-221 nil (equal (py-ast "while a:
 if b:
  break
 else:
  c()") "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Break()], orelse=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-while-220 nil (equal (pyel "while a:
 if b:
  break
 else:
  c()") (quote (while a (if b nil)))))
(ert-deftest pyel-el-ast-test-while-219 nil (string= (pyel "while a:
 if b:
  continue
 c()" t) "(while  (name  \"a\" 'load) ((if  (name  \"b\" 'load) ((continue)) nil) (call  (name  \"c\" 'load) nil nil nil nil)) nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-while-218 nil (equal (py-ast "while a:
 if b:
  continue
 c()") "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Continue()], orelse=[]), Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], orelse=[])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-while-217 nil (equal (pyel "while a:
 if b:
  continue
 c()") (quote (while a (if b nil) (pyel-fcall c)))))
(ert-deftest pyel-el-ast-test-call-216 nil (string= (pyel "aa()" t) "(call  (name  \"aa\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-215 nil (equal (py-ast "aa()") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-214 nil (equal (pyel "aa()") (quote (pyel-fcall aa))))
(ert-deftest pyel-el-ast-test-call-213 nil (string= (pyel "aa(b,c(1,2))" t) "(call  (name  \"aa\" 'load) ((name  \"b\" 'load) (call  (name  \"c\" 'load) ((num 1) (num 2)) nil nil nil)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-212 nil (equal (py-ast "aa(b,c(1,2))") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Name(id='b', ctx=Load()), Call(func=Name(id='c', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-211 nil (equal (pyel "aa(b,c(1,2))") (quote (pyel-fcall aa b (pyel-fcall c 1 2)))))
(ert-deftest pyel-el-ast-test-call-210 nil (string= (pyel "aa=b()" t) "(assign  ((name  \"aa\" 'store)) (call  (name  \"b\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-209 nil (equal (py-ast "aa=b()") "Module(body=[Assign(targets=[Name(id='aa', ctx=Store())], value=Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-208 nil (equal (pyel "aa=b()") (quote (pyel-set aa (pyel-fcall b)))))
(ert-deftest pyel-el-ast-test-call-207 nil (string= (pyel "aa(3,b(c(),[2,(2,3)]))" t) "(call  (name  \"aa\" 'load) ((num 3) (call  (name  \"b\" 'load) ((call  (name  \"c\" 'load) nil nil nil nil) (list ((num 2) (tuple  ((num 2) (num 3)) 'load)) 'load)) nil nil nil)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-206 nil (equal (py-ast "aa(3,b(c(),[2,(2,3)]))") "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Num(n=3), Call(func=Name(id='b', ctx=Load()), args=[Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), List(elts=[Num(n=2), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load())], ctx=Load())], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-205 nil (equal (pyel "aa(3,b(c(),[2,(2,3)]))") (quote (pyel-fcall aa 3 (pyel-fcall b (pyel-fcall c) (list 2 (vector 2 3)))))))
(ert-deftest pyel-el-ast-test-call-204 nil (string= (pyel "aa.b()" t) "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-203 nil (equal (py-ast "aa.b()") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-202 nil (equal (pyel "aa.b()") (quote (call-method aa b))))
(ert-deftest pyel-el-ast-test-call-201 nil (string= (pyel "aa.b(1,2)" t) "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) ((num 1) (num 2)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-200 nil (equal (py-ast "aa.b(1,2)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-199 nil (equal (pyel "aa.b(1,2)") (quote (call-method aa b 1 2))))
(ert-deftest pyel-el-ast-test-call-198 nil (string= (pyel "aa.b(1,a.b(1,2,3))" t) "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) ((num 1) (call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((num 1) (num 2) (num 3)) nil nil nil)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-197 nil (equal (py-ast "aa.b(1,a.b(1,2,3))") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2), Num(n=3)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-196 nil (equal (pyel "aa.b(1,a.b(1,2,3))") (quote (call-method aa b 1 (call-method a b 1 2 3)))))
(ert-deftest pyel-el-ast-test-call-195 nil (string= (pyel "a.b().c()" t) "(call  (attribute  (call  (attribute  (name  \"a\" 'load) \"b\" 'load) nil nil nil nil) \"c\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-194 nil (equal (py-ast "a.b().c()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-193 nil (equal (pyel "a.b().c()") (quote (call-method (call-method a b) c))))
(ert-deftest pyel-el-ast-test-call-192 nil (string= (pyel "a.b().c().d()" t) "(call  (attribute  (call  (attribute  (call  (attribute  (name  \"a\" 'load) \"b\" 'load) nil nil nil nil) \"c\" 'load) nil nil nil nil) \"d\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-191 nil (equal (py-ast "a.b().c().d()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='d', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-190 nil (equal (pyel "a.b().c().d()") (quote (call-method (call-method (call-method a b) c) d))))
(ert-deftest pyel-el-ast-test-call-189 nil (string= (pyel "a.b(x.y().e()).c()" t) "(call  (attribute  (call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((call  (attribute  (call  (attribute  (name  \"x\" 'load) \"y\" 'load) nil nil nil nil) \"e\" 'load) nil nil nil nil)) nil nil nil) \"c\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-call-188 nil (equal (py-ast "a.b(x.y().e()).c()") "Module(body=[Expr(value=Call(func=Attribute(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Call(func=Attribute(value=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-call-187 nil (equal (pyel "a.b(x.y().e()).c()") (quote (call-method (call-method a b (call-method (call-method x y) e)) c))))
(ert-deftest pyel-el-ast-test-if-186 nil (string= (pyel "if (a==b):
  b=c
else:
  a = d" t) "(if  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((assign  ((name  \"b\" 'store)) (name  \"c\" 'load))) ((assign  ((name  \"a\" 'store)) (name  \"d\" 'load))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-if-185 nil (equal (py-ast "if (a==b):
  b=c
else:
  a = d") "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='d', ctx=Load()))])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-if-184 nil (equal (pyel "if (a==b):
  b=c
else:
  a = d") (quote (if (pyel-== a b) (pyel-set b c)))))
(ert-deftest pyel-el-ast-test-if-183 nil (string= (pyel "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b" t) "(if  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((assign  ((name  \"b\" 'store)) (name  \"c\" 'load)) (assign  ((name  \"z\" 'store)) (num 1))) ((assign  ((name  \"a\" 'store)) (num 4)) (assign  ((name  \"b\" 'store)) (attribute  (name  \"a\" 'load) \"b\" 'load))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-if-182 nil (equal (py-ast "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b") "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load())), Assign(targets=[Name(id='z', ctx=Store())], value=Num(n=1))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=4)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-if-181 nil (equal (pyel "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b") (quote (if (pyel-== a b) (progn (pyel-set b c) (pyel-set z 1)) (pyel-set a 4) (pyel-set b (getattr a b))))))
(ert-deftest pyel-el-ast-test-if-180 nil (string= (pyel "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]" t) "(if  (compare  (attribute  (name  \"a\" 'load) \"b\" 'load) (\"<=\") ((attribute  (name  \"a\" 'load) \"e\" 'load))) ((assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (tuple  ((num 2.1) (num 2)) 'load))) ((assign  ((attribute  (attribute  (name  \"b\" 'load) \"a\" 'load) \"c\" 'store)) (list ((name  \"a\" 'load) (dict ((str \"a\") (str \"b\")) ((num 23.3) (tuple  ((num 3.2) (num 3.1)) 'load)))) 'load))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-if-179 nil (equal (py-ast "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]") "Module(body=[If(test=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE()], comparators=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load())]), body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Tuple(elts=[Num(n=2.1), Num(n=2)], ctx=Load()))], orelse=[Assign(targets=[Attribute(value=Attribute(value=Name(id='b', ctx=Load()), attr='a', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=23.3), Tuple(elts=[Num(n=3.2), Num(n=3.1)], ctx=Load())])], ctx=Load()))])])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-if-178 nil (equal (pyel "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]") (quote (if (pyel-<= (getattr a b) (getattr a e)) (setattr a b (vector 2.1 2))))))
(ert-deftest pyel-el-ast-test-compare-177 nil (string= (pyel "a=='d'" t) "(compare  (name  \"a\" 'load) (\"==\") ((str \"d\")))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-176 nil (equal (py-ast "a=='d'") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='d')]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-175 nil (equal (pyel "a=='d'") (quote (pyel-== a "d"))))
(ert-deftest pyel-el-ast-test-compare-174 nil (string= (pyel "a==b" t) "(compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-173 nil (equal (py-ast "a==b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-172 nil (equal (pyel "a==b") (quote (pyel-== a b))))
(ert-deftest pyel-el-ast-test-compare-171 nil (string= (pyel "a>=b" t) "(compare  (name  \"a\" 'load) (\">=\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-170 nil (equal (py-ast "a>=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[GtE()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-169 nil (equal (pyel "a>=b") (quote (pyel->= a b))))
(ert-deftest pyel-el-ast-test-compare-168 nil (string= (pyel "a<=b" t) "(compare  (name  \"a\" 'load) (\"<=\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-167 nil (equal (py-ast "a<=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-166 nil (equal (pyel "a<=b") (quote (pyel-<= a b))))
(ert-deftest pyel-el-ast-test-compare-165 nil (string= (pyel "a<b" t) "(compare  (name  \"a\" 'load) (\"<\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-164 nil (equal (py-ast "a<b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-163 nil (equal (pyel "a<b") (quote (pyel-< a b))))
(ert-deftest pyel-el-ast-test-compare-162 nil (string= (pyel "a>b" t) "(compare  (name  \"a\" 'load) (\">\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-161 nil (equal (py-ast "a>b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-160 nil (equal (pyel "a>b") (quote (pyel-> a b))))
(ert-deftest pyel-el-ast-test-compare-159 nil (string= (pyel "a!=b" t) "(compare  (name  \"a\" 'load) (\"!=\") ((name  \"b\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-158 nil (equal (py-ast "a!=b") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[NotEq()], comparators=[Name(id='b', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-157 nil (equal (pyel "a!=b") (quote (pyel-!= a b))))
(ert-deftest pyel-el-ast-test-compare-156 nil (string= (pyel "(a,b) == [c,d]" t) "(compare  (tuple  ((name  \"a\" 'load) (name  \"b\" 'load)) 'load) (\"==\") ((list ((name  \"c\" 'load) (name  \"d\" 'load)) 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-155 nil (equal (py-ast "(a,b) == [c,d]") "Module(body=[Expr(value=Compare(left=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()), ops=[Eq()], comparators=[List(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-154 nil (equal (pyel "(a,b) == [c,d]") (quote (pyel-== (vector a b) (list c d)))))
(ert-deftest pyel-el-ast-test-compare-153 nil (string= (pyel "[a == 1]" t) "(list ((compare  (name  \"a\" 'load) (\"==\") ((num 1)))) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-152 nil (equal (py-ast "[a == 1]") "Module(body=[Expr(value=List(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-151 nil (equal (pyel "[a == 1]") (quote (list (pyel-== a 1)))))
(ert-deftest pyel-el-ast-test-compare-150 nil (string= (pyel "((a == 1),)" t) "(tuple  ((compare  (name  \"a\" 'load) (\"==\") ((num 1)))) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-149 nil (equal (py-ast "((a == 1),)") "Module(body=[Expr(value=Tuple(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-148 nil (equal (pyel "((a == 1),)") (quote (vector (pyel-== a 1)))))
(ert-deftest pyel-el-ast-test-compare-147 nil (string= (pyel "a<b<c" t) "(compare  (name  \"a\" 'load) (\"<\" \"<\") ((name  \"b\" 'load) (name  \"c\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-146 nil (equal (py-ast "a<b<c") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt(), Lt()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-145 nil (equal (pyel "a<b<c") (quote (and (pyel-< a b) (pyel-< b c)))))
(ert-deftest pyel-el-ast-test-compare-144 nil (string= (pyel "a<=b<c<=d" t) "(compare  (name  \"a\" 'load) (\"<=\" \"<\" \"<=\") ((name  \"b\" 'load) (name  \"c\" 'load) (name  \"d\" 'load)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-143 nil (equal (py-ast "a<=b<c<=d") "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load()), Name(id='d', ctx=Load())]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-142 nil (equal (pyel "a<=b<c<=d") (quote (and (pyel-<= a b) (pyel-< b c) (pyel-<= c d)))))
(ert-deftest pyel-el-ast-test-compare-141 nil (string= (pyel "a.b<=b.c()<c<=3" t) "(compare  (attribute  (name  \"a\" 'load) \"b\" 'load) (\"<=\" \"<\" \"<=\") ((call  (attribute  (name  \"b\" 'load) \"c\" 'load) nil nil nil nil) (name  \"c\" 'load) (num 3)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-compare-140 nil (equal (py-ast "a.b<=b.c()<c<=3") "Module(body=[Expr(value=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Name(id='c', ctx=Load()), Num(n=3)]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-compare-139 nil (equal (pyel "a.b<=b.c()<c<=3") (quote (and (pyel-<= (getattr a b) (call-method b c)) (pyel-< (call-method b c) c) (pyel-<= c 3)))))
(ert-deftest pyel-el-ast-test-string-138 nil (string= (pyel "'a'" t) "(str \"a\")
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-string-137 nil (equal (py-ast "'a'") "Module(body=[Expr(value=Str(s='a'))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-string-136 nil (equal (pyel "'a'") (quote "a")))
(ert-deftest pyel-el-ast-test-string-135 nil (string= (pyel "x = 'a'" t) "(assign  ((name  \"x\" 'store)) (str \"a\"))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-string-134 nil (equal (py-ast "x = 'a'") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='a'))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-string-133 nil (equal (pyel "x = 'a'") (quote (pyel-set x "a"))))
(ert-deftest pyel-el-ast-test-string-132 nil (string= (pyel "['a','b']" t) "(list ((str \"a\") (str \"b\")) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-string-131 nil (equal (py-ast "['a','b']") "Module(body=[Expr(value=List(elts=[Str(s='a'), Str(s='b')], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-string-130 nil (equal (pyel "['a','b']") (quote (list "a" "b"))))
(ert-deftest pyel-el-ast-test-Tuple-129 nil (string= (pyel "()" t) "(tuple  nil 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-Tuple-128 nil (equal (py-ast "()") "Module(body=[Expr(value=Tuple(elts=[], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-Tuple-127 nil (equal (pyel "()") (quote (vector))))
(ert-deftest pyel-el-ast-test-Tuple-126 nil (string= (pyel "(a, b)" t) "(tuple  ((name  \"a\" 'load) (name  \"b\" 'load)) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-Tuple-125 nil (equal (py-ast "(a, b)") "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-Tuple-124 nil (equal (pyel "(a, b)") (quote (vector a b))))
(ert-deftest pyel-el-ast-test-Tuple-123 nil (string= (pyel "(a, (b, (c,d)))" t) "(tuple  ((name  \"a\" 'load) (tuple  ((name  \"b\" 'load) (tuple  ((name  \"c\" 'load) (name  \"d\" 'load)) 'load)) 'load)) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-Tuple-122 nil (equal (py-ast "(a, (b, (c,d)))") "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Name(id='b', ctx=Load()), Tuple(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-Tuple-121 nil (equal (pyel "(a, (b, (c,d)))") (quote (vector a (vector b (vector c d))))))
(ert-deftest pyel-el-ast-test-Tuple-120 nil (string= (pyel "((((((((a))))))))" t) "(name  \"a\" 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-Tuple-119 nil (equal (py-ast "((((((((a))))))))") "Module(body=[Expr(value=Name(id='a', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-Tuple-118 nil (equal (pyel "((((((((a))))))))") (quote a)))
(ert-deftest pyel-el-ast-test-dict-117 nil (string= (pyel "{'a':2, 'b':4}" t) "(dict ((str \"a\") (str \"b\")) ((num 2) (num 4)))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-dict-116 nil (equal (py-ast "{'a':2, 'b':4}") "Module(body=[Expr(value=Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=2), Num(n=4)]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-dict-115 nil (equal (pyel "{'a':2, 'b':4}") (quote (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "a" 2 __h__) (puthash "b" 4 __h__) __h__))))
(ert-deftest pyel-el-ast-test-dict-114 nil (string= (pyel "a = {a:2, b:4}" t) "(assign  ((name  \"a\" 'store)) (dict ((name  \"a\" 'load) (name  \"b\" 'load)) ((num 2) (num 4))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-dict-113 nil (equal (py-ast "a = {a:2, b:4}") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Dict(keys=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], values=[Num(n=2), Num(n=4)]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-dict-112 nil (equal (pyel "a = {a:2, b:4}") (quote (pyel-set a (let ((__h__ (make-hash-table :test (quote equal)))) (puthash a 2 __h__) (puthash b 4 __h__) __h__)))))
(ert-deftest pyel-el-ast-test-dict-111 nil (string= (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}" t) "(assign  ((name  \"x\" 'store)) (dict ((str \"a\") (str \"b\") (str \"c\")) ((num 2) (num 4) (dict ((str \"d\") (str \"e\") (name  \"f\" 'load)) ((num 1) (num 2) (dict ((name  \"g\" 'load)) ((num 3))))))))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-dict-110 nil (equal (py-ast "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}") "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Dict(keys=[Str(s='a'), Str(s='b'), Str(s='c')], values=[Num(n=2), Num(n=4), Dict(keys=[Str(s='d'), Str(s='e'), Name(id='f', ctx=Load())], values=[Num(n=1), Num(n=2), Dict(keys=[Name(id='g', ctx=Load())], values=[Num(n=3)])])]))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-dict-109 nil (equal (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}") (quote (pyel-set x (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "a" 2 __h__) (puthash "b" 4 __h__) (puthash "c" (let ((__h__ (make-hash-table :test (quote equal)))) (puthash "d" 1 __h__) (puthash "e" 2 __h__) (puthash f (let ((__h__ (make-hash-table :test (quote equal)))) (puthash g 3 __h__) __h__) __h__) __h__) __h__) __h__)))))
(ert-deftest pyel-el-ast-test-list-108 nil (string= (pyel "[]" t) "(list nil 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-107 nil (equal (py-ast "[]") "Module(body=[Expr(value=List(elts=[], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-106 nil (equal (pyel "[]") (quote (list))))
(ert-deftest pyel-el-ast-test-list-105 nil (string= (pyel "[a,1,2]" t) "(list ((name  \"a\" 'load) (num 1) (num 2)) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-104 nil (equal (py-ast "[a,1,2]") "Module(body=[Expr(value=List(elts=[Name(id='a', ctx=Load()), Num(n=1), Num(n=2)], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-103 nil (equal (pyel "[a,1,2]") (quote (list a 1 2))))
(ert-deftest pyel-el-ast-test-list-102 nil (string= (pyel "a = [1,2,a.b]" t) "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (attribute  (name  \"a\" 'load) \"b\" 'load)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-101 nil (equal (py-ast "a = [1,2,a.b]") "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-100 nil (equal (pyel "a = [1,2,a.b]") (quote (pyel-set a (list 1 2 (getattr a b))))))
(ert-deftest pyel-el-ast-test-list-99 nil (string= (pyel "b = [1,[1,a,[a.b,[],3]]]" t) "(assign  ((name  \"b\" 'store)) (list ((num 1) (list ((num 1) (name  \"a\" 'load) (list ((attribute  (name  \"a\" 'load) \"b\" 'load) (list nil 'load) (num 3)) 'load)) 'load)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-98 nil (equal (py-ast "b = [1,[1,a,[a.b,[],3]]]") "Module(body=[Assign(targets=[Name(id='b', ctx=Store())], value=List(elts=[Num(n=1), List(elts=[Num(n=1), Name(id='a', ctx=Load()), List(elts=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), List(elts=[], ctx=Load()), Num(n=3)], ctx=Load())], ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-97 nil (equal (pyel "b = [1,[1,a,[a.b,[],3]]]") (quote (pyel-set b (list 1 (list 1 a (list (getattr a b) (list) 3)))))))
(ert-deftest pyel-el-ast-test-list-96 nil (string= (pyel "[[[[[[[a]]]]]]]" t) "(list ((list ((list ((list ((list ((list ((list ((name  \"a\" 'load)) 'load)) 'load)) 'load)) 'load)) 'load)) 'load)) 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-list-95 nil (equal (py-ast "[[[[[[[a]]]]]]]") "Module(body=[Expr(value=List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[Name(id='a', ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-list-94 nil (equal (pyel "[[[[[[[a]]]]]]]") (quote (list (list (list (list (list (list (list a))))))))))
(ert-deftest pyel-el-ast-test-name-93 nil (string= (pyel "testName" t) "(name  \"testName\" 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-name-92 nil (equal (py-ast "testName") "Module(body=[Expr(value=Name(id='testName', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-name-91 nil (equal (pyel "testName") (quote testName)))
(ert-deftest pyel-el-ast-test-num-90 nil (string= (pyel "3" t) "(num 3)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-num-89 nil (equal (py-ast "3") "Module(body=[Expr(value=Num(n=3))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-num-88 nil (equal (pyel "3") (quote 3)))
(ert-deftest pyel-el-ast-test-num-87 nil (string= (pyel "4.23" t) "(num 4.23)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-num-86 nil (equal (py-ast "4.23") "Module(body=[Expr(value=Num(n=4.23))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-num-85 nil (equal (pyel "4.23") (quote 4.23)))
(ert-deftest pyel-el-ast-test-attribute-84 nil (string= (pyel "a.b" t) "(attribute  (name  \"a\" 'load) \"b\" 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-83 nil (equal (py-ast "a.b") "Module(body=[Expr(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-82 nil (equal (pyel "a.b") (quote (getattr a b))))
(ert-deftest pyel-el-ast-test-attribute-81 nil (string= (pyel "a.b.c" t) "(attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-80 nil (equal (py-ast "a.b.c") "Module(body=[Expr(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-79 nil (equal (pyel "a.b.c") (quote (getattr (getattr a b) c))))
(ert-deftest pyel-el-ast-test-attribute-78 nil (string= (pyel "a.b.c.e" t) "(attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"e\" 'load)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-77 nil (equal (py-ast "a.b.c.e") "Module(body=[Expr(value=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='e', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-76 nil (equal (pyel "a.b.c.e") (quote (getattr (getattr (getattr a b) c) e))))
(ert-deftest pyel-el-ast-test-attribute-75 nil (string= (pyel "a.b()" t) "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-74 nil (equal (py-ast "a.b()") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-73 nil (equal (pyel "a.b()") (quote (call-method a b))))
(ert-deftest pyel-el-ast-test-attribute-72 nil (string= (pyel "a.b.c()" t) "(call  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-71 nil (equal (py-ast "a.b.c()") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-70 nil (equal (pyel "a.b.c()") (quote (call-method (getattr a b) c))))
(ert-deftest pyel-el-ast-test-attribute-69 nil (string= (pyel "a.b.c.d()" t) "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"d\" 'load) nil nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-68 nil (equal (py-ast "a.b.c.d()") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-67 nil (equal (pyel "a.b.c.d()") (quote (call-method (getattr (getattr a b) c) d))))
(ert-deftest pyel-el-ast-test-attribute-66 nil (string= (pyel "a.b.c.d(1,3)" t) "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"d\" 'load) ((num 1) (num 3)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-65 nil (equal (py-ast "a.b.c.d(1,3)") "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-64 nil (equal (pyel "a.b.c.d(1,3)") (quote (call-method (getattr (getattr a b) c) d 1 3))))
(ert-deftest pyel-el-ast-test-attribute-63 nil (string= (pyel "a.b = 2" t) "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (num 2))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-62 nil (equal (py-ast "a.b = 2") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Num(n=2))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-61 nil (equal (pyel "a.b = 2") (quote (setattr a b 2))))
(ert-deftest pyel-el-ast-test-attribute-60 nil (string= (pyel "a.b.e = 2" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"e\" 'store)) (num 2))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-59 nil (equal (py-ast "a.b.e = 2") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='e', ctx=Store())], value=Num(n=2))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-58 nil (equal (pyel "a.b.e = 2") (quote (setattr (getattr a b) e 2))))
(ert-deftest pyel-el-ast-test-attribute-57 nil (string= (pyel "a.b.c = d.e" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (attribute  (name  \"d\" 'load) \"e\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-56 nil (equal (py-ast "a.b.c = d.e") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-55 nil (equal (pyel "a.b.c = d.e") (quote (setattr (getattr a b) c (getattr d e)))))
(ert-deftest pyel-el-ast-test-attribute-54 nil (string= (pyel "a.b.c = d.e.f" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-53 nil (equal (py-ast "a.b.c = d.e.f") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-52 nil (equal (pyel "a.b.c = d.e.f") (quote (setattr (getattr a b) c (getattr (getattr d e) f)))))
(ert-deftest pyel-el-ast-test-attribute-51 nil (string= (pyel "a.b.c = d.e()" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (name  \"d\" 'load) \"e\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-50 nil (equal (py-ast "a.b.c = d.e()") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-49 nil (equal (pyel "a.b.c = d.e()") (quote (setattr (getattr a b) c (call-method d e)))))
(ert-deftest pyel-el-ast-test-attribute-48 nil (string= (pyel "a.b.c = d.e.f()" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-47 nil (equal (py-ast "a.b.c = d.e.f()") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-46 nil (equal (pyel "a.b.c = d.e.f()") (quote (setattr (getattr a b) c (call-method (getattr d e) f)))))
(ert-deftest pyel-el-ast-test-attribute-45 nil (string= (pyel "a.b.c = d.e.f(1,3)" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) ((num 1) (num 3)) nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-44 nil (equal (py-ast "a.b.c = d.e.f(1,3)") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-43 nil (equal (pyel "a.b.c = d.e.f(1,3)") (quote (setattr (getattr a b) c (call-method (getattr d e) f 1 3)))))
(ert-deftest pyel-el-ast-test-attribute-42 nil (string= (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b" t) "(assign  ((tuple  ((attribute  (name  \"a\" 'load) \"b\" 'store) (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) 'store)) (tuple  ((call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) ((num 1) (num 3)) nil nil nil) (attribute  (attribute  (name  \"e\" 'load) \"g\" 'load) \"b\" 'load)) 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-41 nil (equal (py-ast "a.b, a.b.c = d.e.f(1,3), e.g.b") "Module(body=[Assign(targets=[Tuple(elts=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None), Attribute(value=Attribute(value=Name(id='e', ctx=Load()), attr='g', ctx=Load()), attr='b', ctx=Load())], ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-40 nil (equal (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b") (quote (let ((__1__ (call-method (getattr d e) f 1 3)) (__2__ (getattr (getattr e g) b))) (setattr a b __1__) (setattr (getattr a b) c __2__)))))
(ert-deftest pyel-el-ast-test-attribute-39 nil (string= (pyel "a.b(x.y,y)" t) "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((attribute  (name  \"x\" 'load) \"y\" 'load) (name  \"y\" 'load)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-38 nil (equal (py-ast "a.b(x.y,y)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), Name(id='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-37 nil (equal (pyel "a.b(x.y,y)") (quote (call-method a b (getattr x y) y))))
(ert-deftest pyel-el-ast-test-attribute-36 nil (string= (pyel "a.b(x.y(g.g()),y.y)" t) "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((call  (attribute  (name  \"x\" 'load) \"y\" 'load) ((call  (attribute  (name  \"g\" 'load) \"g\" 'load) nil nil nil nil)) nil nil nil) (attribute  (name  \"y\" 'load) \"y\" 'load)) nil nil nil)
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-attribute-35 nil (equal (py-ast "a.b(x.y(g.g()),y.y)") "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), args=[Call(func=Attribute(value=Name(id='g', ctx=Load()), attr='g', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None), Attribute(value=Name(id='y', ctx=Load()), attr='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-attribute-34 nil (equal (pyel "a.b(x.y(g.g()),y.y)") (quote (call-method a b (call-method x y (call-method g g)) (getattr y y)))))
(ert-deftest pyel-el-ast-test-assign-31 nil (string= (pyel "a.b = c" t) "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (name  \"c\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-30 nil (equal (py-ast "a.b = c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-29 nil (equal (pyel "a.b = c") (quote (setattr a b c))))
(ert-deftest pyel-el-ast-test-assign-28 nil (string= (pyel "a.b.c = 1" t) "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (num 1))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-27 nil (equal (py-ast "a.b.c = 1") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Num(n=1))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-26 nil (equal (pyel "a.b.c = 1") (quote (setattr (getattr a b) c 1))))
(ert-deftest pyel-el-ast-test-assign-25 nil (string= (pyel "a.b = d.c" t) "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (attribute  (name  \"d\" 'load) \"c\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-24 nil (equal (py-ast "a.b = d.c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='c', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-23 nil (equal (pyel "a.b = d.c") (quote (setattr a b (getattr d c)))))
(ert-deftest pyel-el-ast-test-assign-16 nil (string= (pyel "a,b = a.e.e()" t) "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (call  (attribute  (attribute  (name  \"a\" 'load) \"e\" 'load) \"e\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-15 nil (equal (py-ast "a,b = a.e.e()") "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-14 nil (equal (pyel "a,b = a.e.e()") (quote (let ((__value__ (call-method (getattr a e) e))) (pyel-set a (pyel-subscript-load-index __value__ 0)) (pyel-set b (pyel-subscript-load-index __value__ 1))))))
(ert-deftest pyel-el-ast-test-assign-13 nil (string= (pyel "a[1:4], b[2], a.c = c" t) "(assign  ((tuple  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store) (subscript (name  \"b\" 'load) (index (num 2)) 'store) (attribute  (name  \"a\" 'load) \"c\" 'store)) 'store)) (name  \"c\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-12 nil (equal (py-ast "a[1:4], b[2], a.c = c") "Module(body=[Assign(targets=[Tuple(elts=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-11 nil (equal (pyel "a[1:4], b[2], a.c = c") (quote (let ((__value__ c)) (pyel-subscript-store-slice a 1 4 nil (pyel-subscript-load-index __value__ 0)) (pyel-subscript-store-index b 2 (pyel-subscript-load-index __value__ 1)) (setattr a c (pyel-subscript-load-index __value__ 2))))))
(ert-deftest pyel-el-ast-test-assign-10 nil (string= (pyel "a = b = c" t) "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (name  \"c\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-9 nil (equal (py-ast "a = b = c") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-8 nil (equal (pyel "a = b = c") (quote (progn (pyel-set b c) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-assign-7 nil (string= (pyel "a = b = c.e" t) "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (attribute  (name  \"c\" 'load) \"e\" 'load))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-6 nil (equal (py-ast "a = b = c.e") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-5 nil (equal (pyel "a = b = c.e") (quote (progn (pyel-set b (getattr c e)) (pyel-set a b)))))
(ert-deftest pyel-el-ast-test-assign-4 nil (string= (pyel "a = b = c.e()" t) "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (call  (attribute  (name  \"c\" 'load) \"e\" 'load) nil nil nil nil))
") pyel-el-ast-tests)
(ert-deftest pyel-py-ast-test-assign-3 nil (equal (py-ast "a = b = c.e()") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
") pyel-py-ast-tests)
(ert-deftest pyel-transform-test-assign-2 nil (equal (pyel "a = b = c.e()") (quote (progn (pyel-set b (call-method c e)) (pyel-set a b)))))

(provide 'pyel-tests-generated)
