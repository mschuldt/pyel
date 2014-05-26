
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

;

(ert-deftest pyel-test-expand-type-switch ()
  (should (equal (pyel-expand-type-switch-2 '(l r)
                                            '((number number) ->  (* l r)
                                              (object _)
                                              (_ object)  -> (--mul-- l r)
                                              (_ string)
                                              (string _)  -> (pyel-mul-num-str l r)))
                 '((and ((l number) (r number)) (* l r)) ((l object) (--mul-- l r)) ((r object) (--mul-- l r)) ((r string) (pyel-mul-num-str l r)) ((l string) (pyel-mul-num-str l r))))))

(ert-deftest pyel-test-do-splices ()
  (should (equal (pyel-do-splices '(a (@ b (c)))) '(a b (c))))
  (should (equal (pyel-do-splices '(a (@ b c)))  '(a b c)))
  (should (equal (pyel-do-splices '(a (@ b (c (@ 2 (n (x 1 (@ 2))) 3 (@ 3) (@ a b (2)))))))
                 '(a b (c 2 (n (x 1 2)) 3 3 a b (2)))))

  (should (equal (pyel-do-splices '(@ (a b (@ d (e 2 (@ a b c ))))))
                 '(a b d (e 2 a b c))))

  (should (equal (pyel-do-splices '(@ (a b (@ d (e 2 (@ a b c )))) last))
                 '(progn (a b d (e 2 a b c)) last)))

  (should (equal (pyel-do-splices '(@)) nil))
  )

(pyel-create-tests
 assign
 ("a = 1" ("a" 1))
 ("class a: pass
a.b = 1" ("a.b" 1))
 "a.b = c"
 "a.b.c = 1"
 "a.b = d.c"
 ("a,b = 1,2"
  ("a" 1)
  ("b" 2))
 ("x = [1,0,9]
f = lambda: 3
class C: pass
C.a = 3
a, C.v, x[2] = C.a,1.1, x[x[1]]"
  ("a" 3)
  ("C.v" 1.1)
  ("x[2]" 1))

 ("a = 1
b = 2
a,b= b,a"
  ("a" 2)
  ("b" 1))
 ("a = [1,2]
b = (3,4)
x,y = a
xx,yy = b"
  ("x" 1)
  ("y" 2)
  ("xx" 3)
  ("yy" 3))
 ("class C:
 a = [11,22,33]
x,y,z = C.a"
  ("x" 11)
  ("y" 22)
  ("z" 33))
 ("a = 1
b = 2
c = 3
d = a,b,c"
  ("d" [1 2 3]))

 "a,b = a.e.e()"

 "a[1:4], b[2], a.c = c"

 "a = b = c"
 "a = b = c.e"
 "a = b = c.e()"
 ("class x:
 a = 1
xx = x()
l = [1,2,3]
a = xx.a = l[1] = b = c = 9
z = l[2] = xx.a"
  ("a" 9)
  ("b" 9)
  ("c" 9)
  ("xx.a" 9)
  ("l[1]" 9)
  ("z" 9)
  ("l[2]" 9))
  )

(pyel-create-tests attribute
                   "a.b"
                   "a.b.c"
                   "a.b.c.e"
                   "a.b()"
                   "a.b.c()"
                   "a.b.c.d()"
                   "a.b.c.d(1,3)"
                   "a.b = 2"
                   "a.b.e = 2"
                   "a.b.c = d.e"
                   "a.b.c = d.e.f"
                   "a.b.c = d.e()"
                   "a.b.c = d.e.f()"
                   "a.b.c = d.e.f(1,3)"
                   "a.b, a.b.c = d.e.f(1,3), e.g.b"
                   "a.b(x.y,y)"
                   "a.b(x.y(g.g()),y.y)")

(pyel-create-tests
 num
 ("3" 3)
 ("4.23" 4.23)
 ("3e2" 300.0))

(ert-deftest pyel-test-name ()
 (should (eq (pyel "testName") 'testName)))

(pyel-create-tests
 list
 ("[]" nil)
 ("['a',1,2]" '("a" 1 2))
 ("a = [1,2,'b']
b = [1,[1,'3',a,[],3]]"
  ("a" '(1 2 "b"))
  ("b" '(1 (1 "3" (1 2 "b") nil 3))))
 ("[[[1]]]" '(((1)))))

(pyel-create-tests dict
                   "{'a':2, 'b':4}"
                   "a = {a:2, b:4}"
                   "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}")

(pyel-create-tests Tuple
                   "()"
                   "(a, b)"
                   "(a, (b, (c,d)))"
                   "((((((((a))))))))")

(pyel-create-tests string
                   "'a'"
                   "x = 'a'"
                   "['a','b']")

(pyel-create-tests compare
                   "a=='d'"
                   "a==b"
                   "a>=b"
                   "a<=b"
                   "a<b"
                   "a>b"
                   "a!=b"
                   "(a,b) == [c,d]"
                   "[a == 1]"
                   "((a == 1),)"
                   "a<b<c"
                   "a<=b<c<=d"
                   "a.b<=b.c()<c<=3")

(pyel-create-tests
 if
 ("if True:
 x = 1
else:
 x = 2"
  ("x" 1))
 ("if False:
 x = 3
else:
 x = 4"
  ("x" 4))
 ("if len([1,2,3]) == 3:
 y = 1
 x = 5
else:
 y = 1
 x = 6"
  ("x" 5))

 ("def a():
 if True:
  return 1
 else:
  return 2

def b():
 if True:
  return 1
  x()
 else:
  y()
  return 2

def c():
 if 1 == 2:
  return 1
  x()
 else:
  y()
  return 2

def d():
 if 1 == 2:
  return 4
 else:
  if True:
   return 1.1
   x()
  return 2

def e():
 if 1 == 1:
  if True:
   if [0][0] == 0:
    return 12
   x()
 else:
  y()
  return 2"
  ("a()" 1)
  ("b()" 1)
  ("c()" 2)
  ("c()" 1.1)
  ("e()" 12)))

(pyel-create-tests call
                   "aa()"
                   "aa(b,c(1,2))"
                   ;;"aa()()" does not work yet
                   "aa=b()"
                   ;;"aa.b()"
                   ;;"[aa.b()==4]"
                   "aa(3,b(c(),[2,(2,3)]))"
                   "aa.b()"
                   "aa.b(1,2)"
                   "aa.b(1,a.b(1,2,3))"

                   "a.b().c()"
                   "a.b().c().d()"
                   "a.b(x.y().e()).c()"

                   )

(pyel-create-tests 
 while
 ("x = 1
a = 0
while x < 10:
 a += x
 x += 1"
  ("a" 45))

 ;;return from tail context
 ("def f():
 x = 1;
 while x < 10:
  return x
  x+=1
 return x

def g():
 x = 1;
 while x < 10:
  x+=1
  return x
 return x"
  ("f()" 1)
  ("g()" 2))

 ;;break
 ("x = 1
while x < 10:
 if x == 3:
  break
 x+=1"
  ("x" 3))

 ;;continue
 ("x = 0
a=0
while x < 10:
 x+=1
 if x%2 == 0:
  continue
 a+=1"
  ("a" 5)))

(ert-deftest pyel-test-arguments ()
  (with-transform-table 'pyel
                        (and
                         (should (equal (transform '(arguments ((arg "b" nil)
                                                                (arg "c" nil)) nil nil nil nil nil nil nil))

                                        '(b c)))
                         ;;other tests here
                         )))

(pyel-create-tests
 def
 ("def a():
  return 0

def b(a):
 return a

def c(a,b,c):
 return a+b+c

def d(a):
 if True:
  return a
 return 5
 somethingelse()

def e(a=1.1):
 return a
def f(*a):
 return a
"
  ("a()" 0)
  ("b(1)" 1)
  ("c(1,2,3)" 6)
  ("d(2)" 2)
  ("e()" 1.1)
  ("e(22)" 22)
  ("f(1,3,5,6,8)" [1, 3, 5, 6, 8]))
 
 ;;test interactively
 ("def a():
 'docstring'
 interactive()
 x = 1
 return 'hi'

def b():
 return 2"
  ("commandp(quote(a))" t)
  ("commandp(quote(b))" nil)))

(pyel-create-tests
 function-arguments
 ("def func(__a,__b,c=1,d='two',*rest,**kwargs):
 return [__a,__b,c,d,rest,kwargs]"
  ("repr(func(1,2))"
   "[1, 2, 1, \"two\", [], {}]")
  ("repr(func(1,2,3))"
   "[1, 2, 3, \"two\", [], {}]")
  ("repr(func(1,2,3,4))"
   "[1, 2, 3, 4, [], {}]")
  ("repr(func(1,2,3,4,5))"
   "[1, 2, 3, 4, [5], {}]")
  ("repr(func(1,2,3,4,5,6))"
   "[1, 2, 3, 4, [5, 6], {}]")
  ("repr(func(1,2,3,4,5,6,x = 's'))"
   "[1, 2, 3, 4, [5, 6], {x: \"s\"}]")
  ("repr(func(1,2,3,4,5,6,x = 's',y = 23))"
   "[1, 2, 3, 4, [5, 6], {y: 23, x: \"s\"}]")
  ("repr(func(x = 's',__b = 324,__a = 'n',))"
   "[\"n\", 324, 1, \"two\", [], {x: \"s\"}]")
  ("repr(func(x = 's',__b = 324,__a = 'n',d = 2))"
   "[\"n\", 324, 1, 2, [], {x: \"s\"}]"))
 ;;tests with kwonlyargs
 ("def test(a, *b, c=1, d, **e):
 return [a, b, c, d, e]"
  ("repr(test('x',1,2,3,_d=1.1,_xx=2.2,_yy=3.3))"
   "[\"x\", [1, 2, 3], 1, nil, {-yy: 3.3, -xx: 2.2, -d: 1.1}]")

  ("repr(test('x',d=1.1))"
   "[\"x\", nil, 1, 1.1, {}]")

  ("repr(test('x'))"
   "[\"x\", nil, 1, nil, {}]")

  ("repr(test(d=1,c=2,a='x',e=4))"
   "[\"x\", (), 2, 1, {e: 4}]")

  ("repr(test(1,2,3,4,5,6))"
   "[1, (2, 3, 4, 5, 6), 1, nil, {}]"))

 ("def test(a,b):
     return [a,b]"
  ("test(1,2)" '(1 2))
  ("test(b=4,a='s')" '("s" 4)))

 ;;check that default values for optional args get set with or without kwargs
 ("def test(a,b,c,d=1,dd=2,ddd=4,*restst, x=1,xx=32,xxx=43,**kwargs_):
 return [a,b,c,d,dd,ddd,restst,x,xx,xxx,kwargs_]"
  ("repr(test(1,2,3,999,888,777,1,2,3,43,4,5,x=3))"
   "[1, 2, 3, 999, 888, 777, [1, 2, 3, 43, 4, 5], 3, 32, 43, {}]")
  ("repr(test(1,2,3,999,888,777,1,2,3,43,4,5))"
   "[1, 2, 3, 999, 888, 777, [1, 2, 3, 43, 4, 5], 1, 32, 43, {}]"))
 )

(ert-deftest pyel-test-sort-kwargs ()
  (equal (pyel-sort-kwargs '(a b = 1 5 12 x = 1 3))
         '((a 5 12 3) ((x . 1) (b . 1))))
  (equal (pyel-sort-kwargs '(b = 1 x = 1))
         '(nil ((x . 1) (b . 1))))
  (equal (pyel-sort-kwargs '(b = 1))
         '(nil ((b . 1))))
  (equal (pyel-sort-kwargs '(a b c d))
         '((a b c d) nil))
  (equal (pyel-sort-kwargs '(a b = (b 1 2) 5 12 x = 1 (+ 1 3 ) y = "s"))
         '((a 5 12 (+ 1 3)) ((y . "s") (x . 1) (b b 1 2)))))

(pyel-create-tests
 add-op
 ("1 + 2" 3)
 ("'a' + 'b'" "ab")
 ("n1 = 2
n2 = 5
s1 = 'asd'
s2 = 'df'
l1 = [1]
l2 = [3,'a']
v1 = (1,2)
v2 = (3,)"
  ("n1 + n2" 10)
  ("s1 + s2" "asddf")
  ("l1 + l2" '(1 3 "a"))
  ("v1 + v2" [1 2 3]))
 
 ("class test:
 def __init__(self, n):
  message('init')
  self.n = n*2
 def __add__(self, o):
  message('adding')
  return self.n + o.n
x = test(5)
y = test(2)"
  ("x + y" 14)))

(pyel-create-tests
 sub-op
 ("3 - 2" 1)
 ("n1 = 5
n2 = 3"
  ("n1 - n2" 2)))

(pyel-create-tests
 mult-op
 ("3 * 4" 12)
 ("'a' * 3" "aaa")
 ("4*'b'" "bbbb")
 ("n1 = 2
n2 = 4
s = 's'"
  ("n1 * n2" 8)
  ("s * n1" "ss")
  ("n1 * s" "ss"))
 )

(pyel-create-tests
 pow-op
 ("3 ** 4" 81)
 ("n1 = 2
n2 = 4"
  ("n1 ** n2" 16)))

(pyel-create-tests
 div-op
 ("9 / 4" 2.25)
 ("9 // 4" 2)
 ("a = 9
b = 4"
  ("a / b" 2.25)
  ("a // b" 2))
 )

(pyel-create-tests
 bin-ops
 ("3 & 5" 0)
 ("3 | 5" 7)
 ("3 ^ 5" 6)
 ("a = 3
b = 5"
  ("a & b" 0)
  ("a | b" 7)
  ("a ^ b" 6)))

(pyel-create-tests
 mod-op
 ("5 % 3" 2)
 ("a = 3
b = 5"
  ("b % a" 2)))

(pyel-create-tests
subscript
 ;;load index====
 ;;string
 "a = '1X23'
assert a[1] == 'X'"
 ;;list
 "a = [1,2,3,4]
assert a[1] == 2"
 ;;vector
 "a = (1,2,3,4)
assert a[1] == 2"
 ;;object
 "class a:
 def __getitem__ (self, value):
  return value + 4
x = a()
assert x[1] == 5"
 ;;=load slice====
 ;;vector
 "a = (1,2,3,4,5)
assert a[1:4] == (2,3,4)
assert a[:4] == (1,2,3,4)
assert a[2:] == (3,4,5)
assert a[:] == (1,2,3,4,5)"
 ;;list
 "a = [1,2,3,4,5]
assert a[1:4] == [2,3,4]
assert a[:4] == [1,2,3,4]
assert a[2:] == [3,4,5]
assert a[:] == [1,2,3,4,5]"
 ;;strings
 "a = '012345678'
assert a[1:4] == '123'
assert a[:4] == '0123'
assert a[2:] == '2345678'
assert a[:] == '012345678'"
 ;;object
 "class a:
 def __getitem__ (self, value):
  return value.start + value.end
x = a()
assert x[1:2] == 3
assert x[5:7] == 12"

 ;;store index
 ;; list
 "def __add(a,b):
 return a+b
a = [1,2,3,4]
a[0] = __add(a[1],a[2])
assert a[0] == 5
a[2] = 'str'
assert a[2] == 'str'"
 ;;vector
 "a = (1,2,3,4)
a[0] = a[1] + a[2]
assert aa[0] == 5
a[2] = 'str'
assert a[2] == 'str'"
 ;;object
 "class a:
 def __setitem__ (self, index, value):
  self.index = index
  self.value = value
x = a()
x[3] = 5
assert x.index == 3
assert x.value == 5"

 ;;store slice
 ;;list
 "a = [1,2,3,4,5,6]
a[1:4] = [5,4,'f']
assert a == [1,5,4,'f',5,6]
a[:3] = ['a',4,2.2]
assert a == ['a',4,2.2,'f',5,6]
a[3:] = [3,3]
assert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]"
 ;;vector
 "a = (1,2,3,4,5,6)
a[1:4] = (5,4,'f')
assert a == (1,5,4,'f',5,6)
a[:3] = ('a',4,2.2)
assert a == ('a',4,2.2,'f',5,6)
a[3:] = (3,3)
assert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)"
 ;;string
 "a = '123456'
a[1:4] = '54f'
assert a == '154f56'
a[:3] = 'a42'
assert a == 'a42f56'
a[3:] = '33'
assert a == 'a42336'#TODO: should == 'a4233'"
 ;;object
 "class a:
 def __setitem__ (self, index, value):
  self.start = index.start
  self.end = index.end
  self.step = index.step
  self.value = value
x = a()
x[2:3] = [1,2,3]
assert x.start == 2
assert x.end == 3
assert x.value == [1,2,3]"

"a[2] += 3"
"a[2] += b[3]"

"[2,3,3][2]"
"assert [1,2,(3,2,8)][2][2] == 8"
 )

(pyel-create-tests
 objects
 ("class tclass():
 '''a test class'''
 cvar = 12
 def __init__(self, x):
  self.a = x + 10
 def get(self):
  return self.a
 def set(self,n):
  self.a = n
x = tclass(4)"
  ("tclass.__name__" "tclass")
  ("tclass.get" (lambda (self) (getattr self a)))
  ("tclass.set" (lambda (self n) (setattr self a n)))
  ("tclass.cvar" 12)
  ("tclass.v = 'hi'" ("tclass.v" "hi"))
  ("tclass.set(tclass, 23)" ("tclass.a" 23))
  ("tclass.set(tclass, 19)" ("tclass.get(tclass)" 19))
  ("tclass.add5 = lambda self: self.cvar + 5" ("tclass.add5" (lambda (self) nil (pyel-+ (getattr self cvar) 5))))
  ("repr(x)" "<class 'object'>")
  ("x.__class__ == tclass" t)
  ("x.__class__.__name__" "tclass")
  ("x.a" 14)
  ("x.a = 2" ("x.a" 2))
  ("x.cvar = 4" (" x.cvar, tclass.cvar" [4 12]))
  ("x.set(10); y = x.get" ("y()" 10))
  ("tclass.sixmore = lambda self: self.a + 6
y = x.sixmore
x.a = 2"
   ("y()" 8)))

 ("class one:
 def __init__(self,x):
  self.n = x
 def m(self):
  return self.n + 1
class two:
 def __init__(self):
  self.other = one(5)
x = two()"
  ("x.other.n" 5)
  ("x.other.m()" 6)))

(pyel-create-tests
 special-method-lookup
 ( "class adder:
 def __init__(self, n):
  self.x = n
 def __call__ (self, n):
  return self.x + n
c = adder(10)
d = adder(10)
d.__call__ = lambda : 'hi'"
   ("c(6)" 16)
   ("repr(c.__call__)"
    "<bound method adder.__call__ of adder object at 0x18b071>")
   ("d.__call__" (lambda nil nil "hi"))))

(pyel-create-tests assert
                   "assert sldk()"
                   "assert adk,'messsage'")

(pyel-create-tests
 for-loop

 ("x = []
for a in range(5):
 x.append(a)"
  ("x" '(0 1 2 3 4)))

 ;;lists
 ("x = []
for a,b in [[1,2],'34',(5,6)]:
 x.append([a,b])"
  ("x" '((1 2) ("3" "4") (5 6))))

 ("x = []
for a,b,c,d in [[1,2,1,1],'34xa',(5,6,'a',1)]:
 x.append([a,b,c,d,a])"
  ("x" '((1 2 1 1 1) ("3" "4" "x" "a" "3") (5 6 "a" 1 5)))) 

 ("n = 0
for a in range(5):
 for b in range(5):
  n = n + a + b"
  ("n" 100))
 
 ("x = []
for a in range(100):
 if (a % 2 == 0):
  continue
 if a > 10:
  break
 x.append(a)"
  ("x" '(1 3 5 7 9)))

 ;;vectors
 ("x = []
for a in (1,2,3,4):
 x.append(2*a)"
  ("x" '(2 4 6 8)))

 ("x = []
for a,b in ([1,2],'34',(5,6)):
 x.append([a,b])"
  ("x" '((1 2) ("3" "4") (5 6))))
 ("tup = make_vector(20,0)
for i in range(10):
 tup[i] = i
x = []
tup = make_vector(20,0)
for i in range(20):
 tup[i] = i;
for a in tup:
 if (a % 2 == 0):
  continue
 if a > 10:
  break
 x.append(a)"
  ("x" '(1 3 5 7 9)))

 ("x = []
for a in 'string':
 x.append(a)"
  ("x" '("s" "t" "r" "i" "n" "g")))

 ;;strings
 ("x = []
c = 0
def getstr():
 global c
 c+=1
 return 'qwerty'
for a in getstr():
 x.append(a)"
  ("x" '("q" "w" "e" "r" "t" "y"))
  ("c" 1))

 ;;objects
 ("class a:
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
x = []
for n in obj:
 x.append(n)"
  ("x" '("5" "4" "3" "2" "1"))))

(pyel-create-tests global

                   "def a():
 global x
 x = 3
 y = 1"

                   "x = 1
y = 1
def func():
 global x
 x = 7
 y = 7
func()
assert x == 7
assert y == 1
"
                   )

;;

(pyel-create-tests
 lambda
 ("f = lambda x,y: x+y
f2 = lambda x,*rest: [x,rest]
f3 = lambda x, *rest, **k : [x, rest, k]"
  ("f(1,2.3)" 3.3)
  ("f2(1,2,3,4,'asd')" '(1 (2 3 4 "asd")))
  ("repr(f3(1,2,3,4,5,a__=1,b__=2))"
   "[1, [2, 3, 4, 5], {b--: 2, a--: 1}]"))
 ("reduce(lambda a,b:a+b, range(2, 9))" 35))

;;

(pyel-create-tests
 aug-assign
 ("x = 2"
  ("x += 3" ("x" 5))
  ("x *= 3" ("x" 6))
  ("x -= 1" ("x" 1))
  ("x /= 4" ("x" 0.5)))

 ("x = [2]"
  ("x[0] += 3" ("x[0]" 5))
  ("x[0] *= 3" ("x[0]" 6))
  ("x[0] -= 1" ("x[0]" 1))
  ("x[0] /= 4" ("x[0]" 0.5)))

 ("class a:
 x = 2"
  ("a.x += 3" ("a.x" 5))
  ("a.x *= 3" ("a.x" 6))
  ("a.x -= 1" ("a.x" 1))
  ("a.x /= 4" ("a.x" 0.5)))
 )

;;

(pyel-create-tests
 break
 ("x = 0
while x < 10:
 x = x + 1
 if x == 3:
  break"
  ("x" 3))

 ("x = [0]
c = 0
while c < 3:
 c = c + 1
 y = 0
 while y < 10:
  y = y + 1
  x.append(y)
  if y == 3:
   x.append('b')
   break"
  ("x" '(0 1 2 3 "b" 1 2 3 "b" 1 2 3 "b"))))

(pyel-create-tests 
 continue
 ("l = [0]
y = 8;
while y > 0:
 y = y -1
 if y % 2 == 0:
  continue
 l.append(y)"
  ("l"  '(0 7 5 3 1)))

 ("x = [0]
c = 0
while c < 3:
 c = c + 1
 y = 0
 while y < 5:
  y = y + 1
  if y % 2 == 0:
   x.append('c')
   continue
  x.append(y)"
  ("x" '(0 1 "c" 3 "c" 5 1 "c" 3 "c" 5 1 "c" 3 "c" 5))))

;;

(pyel-create-tests try
                   "x = ''
try:
 1 / 0
 x = 'yes'
except:
 x = 'no'
assert x == 'no'"

                   "try:
 _a()
except:
 try:
  _x()
 except:
  _b()"
                   )

;;

(pyel-create-tests
 list-comprehensions
 ("[x*x for x in range(10)]" '(0 1 4 9 16 25 36 49 64 81))
 ("[x*x for x in range(10) if x > 5]" '(36 49 64 81))
 ("[x*x for x in range(10) if x > 5 if x < 8]" '(36 49))

 ("[(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]" '([1 3] [1 4] [2 3] [2 1] [2 4] [3 1] [3 4]))

 ("matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])"
  
  ("[[row[i] for row in matrix] for i in range(4)]"
   '((1 5 9) (2 6 10) (3 7 11) (4 8 12)))
  ("transposed" '((1 5 9) (2 6 10) (3 7 11) (4 8 12)))))


(pyel-create-tests
 dict-comprehensions
 ("str({x:x*x for x in range(5)})" "{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}")
 ("x = {x: [y*y for y in range(x)] for x in range(20)}"
  ("hash_table_count(x)" 20)
  ("x[3],x[5],x[10]" [(0 1 4) (0 1 4 9 16) (0 1 4 9 16 25 36 49 64 81)])))

(pyel-create-tests boolop
                   "a or b"
                   "a or b or c"
                   "a.c or b.c() or a[2]"
                   "a and b"
                   "a and b or c"
                   "a[2] and b.f() or c.e"
                   "a.e and b[2] or c.e() and 2 ")

;;

;;

(pyel-create-tests conditional-expressions
                   "1 if True else 0"
                   "true() if tst() else false()"
                   "a[1] if a[2:2] else a[2]"
                   )

;;

;;

;;

(pyel-create-tests
 len-function
 ("a = [1,2,3,'5']
b = []
c = 'str'
d = (1,2,3,4)"
  ("len(a)" 4)
  ("len(b)" 0)
  ("len(c)" 3)
  ("len(d)" 4))
 ("len('')" 0)
 ("len([3,4])" 2)
 ("len({1:'one', 2:'two'})" 2)
 )

(pyel-create-tests
 range-function
 ("range(5)" '(0 1 2 3 4))
 ("range(2,7)" '(2 3 4 5 6))
 ("range(2,20,3)" '(2 5 8 11 14 17)))

(pyel-create-tests
 list-function
 ("list('string')" '("s" "t" "r" "i" "n" "g"))
 ("list([1,2,'3',(2,)])" '(1 2 "3" [2]))
 ("a = [1]
b = [a,1]
c = list(b)"
  ("c is b" nil)
  ("c == b" t)
  ("c[0] is a" t))

 ("a = [1]
b = (a, 1)
c = list(b)"
  ("c" '((1) 1))
  ("c[0] is a" t))

 ("list({1:'one', 2:'two', 3:'three'})" '(3 2 1))

 ("list((1,2,3))" [1, 2, 3])
 
 ("s = '123'
l = [1,2,3]
tu = (1,2,3,)
d = {1:'1',2:'2',3:'3'}"
  ("list(s)" ["1", "2", "3"])
  ("list(l)" [1, 2, 3])
  ("list(tu)" [1, 2, 3])
  ("list(d)" [3, 2, 1]))
 
 ("class a:
 x = 5
 def __iter__(self):
  return self
 def __next__(self):
  if self.x > 0:
   ret = str(self.x)
   self.x -= 1
   return ret
  raise StopIteration
obj = a()"
  ("list(obj)" '("5" "4" "3" "2" "1"))))

;;

;;

(pyel-create-tests
 str
 ("str('somestring')" "\"somestring\"")
 ("str(\"'dstring'\")" "\"'dstring'\"")
 ("str(342)" "342")
 ("x = [1,2,'hi']
str(x)"
  "[1, 2, \"hi\"]")
 ("x = (1,'two',3)
str(x)"
  "(1, \"two\", 3)")
 ("x = {1: 'one', 5: 'five', 12: 'telve'};
str(x)"
  "{1: \"one\", 5: \"five\", 12: \"telve\"}")
 ("f = lambda : False
str(f)"
  "<function <lambda> at 0x18b071>")
 ("def __ff_(): pass
str(__ff_)"
  "<function --ff- at 0x18b071>")

 ("class strtest:
 def __init__ (self, n):
  self.x = n
 def __str__(self):
  return 'str' + str(self.x)
obj = strtest(4)"
 ("str(obj)" "str4")))

(pyel-create-tests
 repr
 ("repr('somestring')" "\"\\\"somestring\\\"\"")
 ("repr(342)" "342")
 ("x = [1,2,'hi']
repr(x)"
  "[1, 2, \"hi\"]")
 ("x = (1,'two',3)
repr(x)"
  "(1, \"two\", 3)")
 ("x = {1: 'one', 5: 'five', 12: 'telve'}
repr(x)"
  "{1: \"one\", 5: \"five\", 12: \"telve\"}")
 ("f = lambda : False
repr(f)"
  "<function <lambda> at 0x18b071>")
 ("def __ff_(): pass
repr(__ff_)"
  "<function --ff- at 0x18b071>"))

(pyel-create-tests
 hex-function
 ("hex(23)" "0x17")
 ("hex(123232332)" "0x758604c"))

(pyel-create-tests
 bin-function
 ("bin(123)" "0b1111011")
 ("bin(3456312)" "0b1101001011110100111000"))

;;

(pyel-create-tests
 pow
 ("pow(2,5,5)" 2)
 ("pow(3,7,20)" 7)
 ("pow(3,7)" 2187)
 ("pow(2,2)" 4))

(pyel-create-tests 
 eval
 ("x = 23
a = 1
b = 4
s = 'a+b'"
  ("eval('x')" 23)
  ("eval(s)" 5)))

(pyel-create-tests
 type
 ("type(t)" "<class 'bool'>")
 ("type(3)" 'integer)
 ("type(3.3)" 'float)
 ("type('3')" 'string)
 ("type([3])" 'cons)
 ("type((3,))" 'vector)
 ("type({3:'3'})" 'hash-table)
 ("class testc: pass
x = testc()
y = type(x)"
  ("repr(type(x))" "<class 'testc'>")
  ("y is testc" t)))

(pyel-create-tests
 abs-function
 ("abs(3)" 3)
 ("abs(-3)" 3)
 ("class C:
 def __abs__(self):
  'doc'
  return 'hi'
obj = C()"
  ("abs(obj)" "hi")))

(pyel-create-tests
 chr-function
 ("chr(70)" "F")
 ("chr(50)" "2"))

(pyel-create-tests
 ord-function
 ("ord('F')" 70)
 ("ord('2')" 50))

(pyel-create-tests
 int-function
 ("int('34')" 34)
 ("int('3.3')" 3)
 ("int(2)" 2)
 ("int(23.2)" 23)
 ("x = '3'
y = ['4']
z = 2
a = 3.3"
  ("int(x)" 3)
  ("int(y[0])" 4)
  ("int(z)" 2)
  ("int(a)" 3))
 ("class test:
 def __int__(self):
  return 342
o = test()"
  ("int(o)" 342)))

(pyel-create-tests
 float-function
 ("float('34')" 34.0)
 ("float('3.3')" 3.3)
 ("float(2)" 2.0)
 ("float(23.2)" 23.2)
 ("x = '3.1'
y = ['4']
z = 2
a = 3.3"
  ("float(x)" 3.1)
  ("float(y[0])" 4.0)
  ("float(z)" 2.0)
  ("float(a)" 3.3))
 ("class test:
 def __float__(self):
  return 342.1
o = test()"
  ("float(o)" 342.1)))

(pyel-create-tests
 dict-function
 ("repr(dict())" "{}")
 ("repr(dict(__a = 1,__b = 2,__c = 4))" "{--a: 1, --b: 2, --c: 4}")
 ("repr(dict([('a',3),('b', 5),('c',8)]))" "{\"a\": 3, \"b\": 5, \"c\": 8}")
 ("repr(dict((('a',3),('b', 5),('c',8))))" "{\"a\": 3, \"b\": 5, \"c\": 8}")
 ("a = [('ab'),['b', 5],('c',8)]
x = dict(a)"
  ("repr(x)" "{\"a\": \"b\", \"b\": 5, \"c\": 8}"))
 ("class a:
 x = 5
 def __iter__(self):
  return self
 def __next__(self):
  if self.x > 0:
   ret = self.x
   self.x -= 1
   return ret, ret**2
  raise StopIteration
o = a()
x = dict(o)"
  ("repr((x))" "{5: 25, 4: 16, 3: 9, 2: 4, 1: 1}")))

(pyel-create-tests
 round-function
 ("round(342.234)" 342)
 ("round(342.834)" 343)
 ("round(342.834,1)" 342.8)
 ("round(342.834,2)" 342.83))

(pyel-create-tests
 enumerate-function
 ("enumerate(['a','b','c'])" '((0 "a") (1 "b") (2 "c")))
 ("enumerate(('a','b','c'))" '((0 "a") (1 "b") (2 "c")))
 ("enumerate('abc')" '((0 "a") (1 "b") (2 "c")))
 ("enumerate(['a','b','c'],10)" '((10 "a") (11 "b") (12 "c")))
 ("enumerate(('a','b','c'),10)" '((10 "a") (11 "b") (12 "c")))
 ("enumerate('abc',10)" '((10 "a") (11 "b") (12 "c")))
 ("class a:
 x = 5
 def __iter__(self):
  return self
 def __next__(self):
  if self.x > 0:
   ret = str(self.x)
   self.x -= 1
   return ret
  raise StopIteration
obj = a()"
  ("enumerate(obj)" '((0 "5") (1 "4") (2 "3") (3 "2") (4 "1")))))

;;

(pyel-create-tests
 append
 ("a = [1,2,3]
c = ['a','a']
b = a
a.append('hi')
e = []
e.append(3)"
  ("a" '(1 2 3 "hi"))
  ("a is b" t)
  ("a.append(c)" ("a is b" t))
  ("a.append(c)" ("a[3] is c" t))
  ("e" '(3))))

(pyel-create-tests
 insert
 ("x = [1,2,3]
y = x
x.insert(1,'hi')"
  ("x" '(1 "hi" 2 3))
  ("x is y" t)))

(pyel-create-tests
 find-method
 ("'aaaxaaa'.find('x',3)"  3)
 ("'aaaxaaa'.find('x',4)"  -1)
 ("'aaaxaaa'.find('x',2, 4)"  3)
 ("'aaaxaaa'.find('x',1, 3)"  -1)
 ("x = 'asdf'"
  ("x.find('sd')" 1)))

(pyel-create-tests
 index-method
 ;;lists
 ("x = [1,(1,2),'5']"
  ("x.index(1)" 0 )
  ("x.index((1,2))" 1)
  ("x.index('5')" 2))
 ;;strings
 ("x = 'importantstring'"
  ("x.index('t')" 5)
  ("x.index('or')" 3)
  ("x.index('g')" 14)
  ("x.index(x)" 0))
  ("x = 'str.ing'"
   ("x.index('.')" 3))
 ;;arrays
 ("x = (1,2,'tree',(3,))"
  ("x.index(1)" 0)
  ("x.index('tree')" 2)
  ("x.index((3,))" 3)))

(pyel-create-tests
 remove-method
 ("x = [1,'2','2',(1,)]
y = x
x.remove('2')"
  ("x is y" t))
 
 ("x = [1,'2','2',(1,)]
x.remove('2')"
  ("x" '(1 "2" [1])))
 
 ("x = [1,'2','2',(1,)]
x.remove(1)"
  ("x" '("2" "2" [1])))
 
 ("x = [1,'2','2',(1,)]
x.remove((1,))"
  ("x" '(1 "2" "2"))))

(pyel-create-tests
 count-method
 ;;strings
 ("'xxxxx'.count('x')" 5)
 ("'xxxx'.count('xx')" 2)
 ("'xxxx'.count('xxxx')" 1)
 ("'x.xx'.count('.')" 1)
 ;;lists
 ("x = [1,2,3,3,[2],'s']"
  ("x.count(3)" 2)
  ("x.count(2)" 1)
  ("x.count([3,4])" 1)
  ("x.count('s')" 1))
 ;;vector
 ("x = (1,2,3,3,[2],'s')"
  ("x.count(3)" 2)
  ("x.count(2)" 1)
  ("x.count([3,4])" 1)
  ("x.count('s')" 1))
 ("(1,1,1).count(1)" 3))

(pyel-create-tests
 join-method
 ("'X'.join(('f','g'))" "fXg")
 ("' '.join([str(x) for x in range(3)])" "0 1 2")
 ("''.join(['a','b']))" "ab"))

(pyel-create-tests
 extend-method
 ;;extend with list
 ("x = [1]
y = x
x.extend([1,'2',(3,)])"
  ("x is y" t)
  ("x" '(1 1 "2" [3])))
 ;;extend with vector
 ("x = [1]
y = x
x.extend((1,'2',(3,)))"
  ("x is y" t)
  ("x" '(1 1 "2" [3])))
 ;;extend with string
 ("x = [1]
y = x
x.extend('extended')"
  ("x is y" t)
  ("x" '(1 "e" "x" "t" "e" "n" "d" "e" "d")))
 ;;extend with object
 ("class a:
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
x.extend(obj)"
  ("y is x" t)
  ("x" '(1 "5" "4" "3" "2" "1"))))

(pyel-create-tests
 pop-method
 ("x = [[1],'s',(2,), 1, 4]
y = x
a = x.pop()
b = x.pop(0)
c = x.pop(2)
 "
  ("a" 4)
  ("b" '(1))
  ("c" 1)
  ("x is y" t))

 ("x = {1:'one',2:'two',3:'three'}
y = x.pop(2)"
  ("y" "two") 
  ("repr(x)" "{1: \"one\", 3: \"three\"}"))
 )

(pyel-create-tests
 reverse-method
 ("x = [1,2,3]
y = x
x.reverse()"
  ("x" '(3 2 1))
  ("x is y" t)))

(pyel-create-tests
 lower-method
 ("x = 'aB'
y = x
y = x.lower()"
  ("y" "ab")
  ("x" "aB")))

(pyel-create-tests
 upper-method
 ("x = 'aB'
y = x
y = x.upper()"
  ("y" "AB")
  ("x" "aB")))

(pyel-create-tests
 split-method
 ("x = 'a b c'
y = x.split()"
  ("y" '("a" "b" "c")))
 ("'a b c'.split()" '("a" "b" "c"))
 ("y = 'a x b x d x'.split()"
  ("y" '("a" "x" "b" "x" "d" "x"))
  ("len(y)" 6)))

(pyel-create-tests
 strip-method
 ("'\r\nhello \t'.strip('heo')" "hello")
 ("'hello'.strip('heo')" "ll")
 ("x = 'hello'"
  ("x.strip('hlo')" "e")))

(pyel-create-tests
 get-method
 ("x = {1:'one',2:'two',3:'three'}"
  ("x[1]" "one")
  ("x[1] == x.get(1)" t)
  ("x.get(3, 'd')" "three")
  ("x.get(4, 'd')" "d")))

(pyel-create-tests
 items-method
 ("x = {1:'one',2:'two',3:'three'}
y = {8 : 88}
z = {}"
  ("x.items()" '((3 "three") (2 "two") (1 "one")))
  ("y.items()" '((8 88)))
  ("z.items()" nil)))

(pyel-create-tests
 keys-method
 ("x = {1:'one',2:'two',3:'three'}
y = {8 : 88}
z = {}"
  ("x.keys()" '(3 2 1))
  ("y.keys()" '((8)))
  ("z.keys()" nil)))

(pyel-create-tests
 values-method
 ("x = {1:'one',2:'two',3:'three'}
y = {8 : 88}
z = {}"
  ("x.values()" '("three" "two" "one"))
  ("y.values()" '(88))
  ("z.values()" nil)))

(pyel-create-tests
 popitem-method
 ("x = {1:'one',2:'two',3:'three'}
y = x.popitem()"
  ("y" '(1 "one"))
  ("repr(x)" "{2: \"two\", 3: \"three\"}")))

(pyel-create-tests
 copy-method
 ("x = {1:['one'],2:'two',3:'three'}
y = x
z = x.copy()"
  ("x is z" nil)
  ("x[1] is z[1]" t)))

(pyel-create-tests
 islower-method
 ("a = 'A'
b = 'a'
c = 'Aa'"
  ("a.islower()" nil)
  ("b.islower()" t)
  ("c.islower()" nil))
 ("'A1'.islower()" nil)
 ("'a1'.islower()" t)
 ("'11'.islower()" nil))

(pyel-create-tests
 isupper-method
 ("a = 'A'
  b = 'a'
  c = 'Aa'"
  ("a.isupper()" t)
  ("b.isupper()" nil)
  ("c.isupper()" nil))
 ("'A1'.isupper()" t)
 ("'a1'.isupper()" nil)
 ("'11'.isupper()" nil))

(pyel-create-tests
 istitle-method
 ("a = 'sldk'
b = 'Dsldk'
c = 'aDsldk'"
  ("a.istitle()" nil)
  ("b.istitle()" t)
  ("c.istitle()" nil))
 ("'2Dsldk'.istitle()" t)
 ("'DDsldk'.istitle()" nil)
 ("'LDKJ'.istitle()" nil)
 ("''.istitle()" nil))

(pyel-create-tests
 isalpha-method
 ("'a'.isalpha()" t)
 ("'aBc'.isalpha()" t)
 ("'2'.isalpha()" nil)
 ("'a2B'.isalpha()" nil)
 ("''.isalpha()" nil)
 ("x = 'asd'"
  ("x.isalpha()" t)))

(pyel-create-tests
 isalnum-method
 ("'0'isalnum()" t)
 ("'0'isalnum()"  t)
 ("'0s'.isalnum()" nil)
 ("''.isalnum()" nil)
 ("'0.1'.isalnum()" nil)
 ("x = '23'"
  ("x.isalnum()" t)))

(pyel-create-tests
 zfill-method
 ("a = 'asdf'"
  ("a.zfill(10)" "000000asdf"))
 ("'34'.zfill(5)" "00034")
 ("'234789'.zfill(5)" "234789")
 ("''.zfill(5)" "00000"))

(pyel-create-tests
 title-method
 ("'sldk'.title()" "Sldk")
 ("'s'.title()" "S")
 ("''.title()" "")
 ("'2dd'.title()" "2Dd")
 ("'2ddlkDd'.title()" "2Ddlkdd")
 ("'23(23aaaaa'.title()" "23(23Aaaaa")
 ("'343'.title()" "343")
 ("x = '2dd'"
  ("x.title()" "2dd")))

(pyel-create-tests
 swapcase-method
 ("'ab'.swapcase()"  "AB")
 ("'aB'.swapcase()"  "Ab")
 ("'aB1'.swapcase()"  "Ab1")
 ("'11'.swapcase()" "11")
 ("''.swapcase()"  "")
 ("x = 'aaBB1'"
  ("x.swapcase()" "AAbb1")))

(pyel-create-tests
 startswith-method
 ("'abcde'.startswith('bcd', 1, 2)" nil)
 ("'abcde'.startswith('bcd', 1, 3)" nil)
 ("'abcde'.startswith('bcd', 1, 4)" t)
 ("'abcde'.startswith('bcd', 1)" t)
 ("'abcde'.startswith('x', 1)" nil)
 ("'abcde'.startswith('abc')" t)
 ("'$abcde'.startswith('$abc')" t)
 ("'abcde'.startswith('.')" nil)
 ("x = 'abcde'"
  ("x.startswith('.')" nil))
 ("'abcde'.startswith(('.', 'b'))" nil)
 ("'abcde'.startswith(('.', 'b','a'))" t))

(pyel-create-tests
 splitlines-method
 ("'''a
b
c

'''.splitlines()" '("a" "b" "c" ""))
 ("x =  '''a

b
c

'''.splitlines()" '("a" "" "" "b" "c" ""))
 ("''.splitlines()" nil)
 ("'asdf'.splitlines()" '("asdf")))

(pyel-create-tests
 rstrip-method
 ("'hello'.rstrip('heo')" "hell")
 ("'\thello\t  '.rstrip()" "    hello")
 ("x = 'hello'"
  ("x.rstrip('hlo')" "he")))

(pyel-create-tests
 lstrip-method
 ("'hello'.lstrip('heo')" "llo")
 ("'\thello\t  '.lstrip()" "hello         ")
 ("x = 'hello'"
  ("x.lstrip('hlo')" "ello")))

(pyel-create-tests
 rsplit-method
 ("x = 'a b c'
y = x.rsplit()"
  ("y" '("a" "b" "c")))
 ("'a b c'.rsplit()" '("a" "b" "c"))
 ("y = 'a x b x d x'.rsplit()"
  ("y" '("a" "x" "b" "x" "d" "x"))
  ("len(y)" 6)))

(pyel-create-tests
 partition-method
 ("'abcdefghi'.partition('c')" ["ab" "c" "defghi"])
 ("'abcdefghi'.partition('cde')" ["ab" "cde" "fghi"])
 ("'abcdefghi'.partition('x')" ["abcdefghi" "" ""])
 ("'x'.partition('x')" ["" "x" ""])
 ("x = 'abcdefghi'"
  ("x.partition('c')" ["ab" "c" "defghi"])))

(pyel-create-tests
 rpartition-method
 ("'abcdefghi'.rpartition('c')" ["ab" "c" "defghi"])
 ("'abcdefghi'.rpartition('cde')" ["ab" "cde" "fghi"])
 ("'abcdefghi'.rpartition('x')" ["abcdefghi" "" ""])
 ("'x'.rpartition('x')" ["" "x" ""])
 ("x = 'abcdefghi'"
  ("x.rpartition('c')" ["ab" "c" "defghi"])))

(pyel-create-tests
 rjust-method
 ("'hi'.rjust(10)"  "        hi")
 ("'hi'.rjust(7, '_')" "_____hi")
 ("'hi'.rjust(10)" "        hi")
 ("'hi'.rjust(3, '_')" "_hi")
 ("'hi'.rjust(7, '_')" "_____hi")
 ("'hisldkjf'.rjust(3, '_')" "hisldkjf")
 ("x = 'ab'"
  ("x.rjust(10)" "        ab")))

(pyel-create-tests
 ljust-method
 ("'hi'.ljust(10)"  "hi        ")
 ("'hi'.ljust(7, '_')" "hi_____")
 ("'hi'.ljust(10)" "hi        ")
 ("'hi'.ljust(3, '_')" "hi_")
 ("'hi'.ljust(7, '_')" "hi_____")
 ("'hisldkjf'.ljust(3, '_')" "hisldkjf")
 ("x = 'ab'"
  ("x.ljust(10)" "ab        ")))

(pyel-create-tests
 rfind-method
 ("'aaaxaaa'.rfind('x',3)"  3)
 ("'aaaxaaa'.rfind('x',4)"  -1)
 ("'aaaxaaa'.rfind('x',2, 4)"  3)
 ("'aaaxaaa'.rfind('x',1, 3)"  -1)
 ("'abcxebdxebdexed'.rfind('xe')" 12)
 ("x = 'asdf'
y = 'abxabxab'"
  ("x.rfind('sd')" 1)
  ("y.rfind('ab')" 6)))











;;

;;;;errors with these
;; (pyel-create-tests cond
;;                    "x = cond([1 > 2, 'first']
;;    [2 == 2, 'second']
;;    [5 == 7, 'third']
;;    [True, error('wtf')])
;; assert x == 'second'"
;;                    )

;;;;Errors with these
;; (pyel-create-tests lambda
;;                    "x = [2,3,4]
;; square = lambda([x]
;;  x*x)
;; y = mapcar(square,x)
;; assert y == [4,9,16]
;; "
;;                    "f = lambda([x,y]
;; if x > y:
;;  'x'
;; else:
;;  'y')
;; x=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])
;; assert x == ['y', 'y', 'x', 'y', 'x']")

;;

(provide 'pyel-tests)
;;pyel-tests.el ends here

;;
