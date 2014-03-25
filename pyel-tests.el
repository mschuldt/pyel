
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
 ("a = b = c = 9"
  ("a" 9)
  ("b" 9)
  ("c" 9))
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

(pyel-create-tests if
                   "if (a==b):
  b=c
else:
  a = d"

                   "if (a==b):
   b=c
   z=1
else:
  a = 4
  b = a.b"

                   "if (a.b <= a.e):
 a.b=(2.1,2)
else:
 b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]"
                   )

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

(pyel-create-tests while
                   "while (a==b):
  print('hi')"

                   "while (a==b):
  print('hi')
  a=b"

                   "while (a==b):
  while (a>2):
    b(3,[a,2])
    b=c.e
  a=b"

                   "while a:
 if b:
  break
 else:
  c()"

                   "while a:
 if b:
  continue
 c()"

                   )

(ert-deftest pyel-test-arguments ()
  (with-transform-table 'pyel
                        (and
                         (should (equal (transform '(arguments ((arg "b" nil)
                                                                (arg "c" nil)) nil nil nil nil nil nil nil))

                                        '(b c)))
                         ;;other tests here
                         )))

(pyel-create-tests def
                   "def a(b,c):
  print('ok')
  a=b"

                   "def a(b,c):
  if (a==b()):
    c()
    while (a < d.b):
      b,c = 1,3
  a.b.c = [a,(2,2)]"

                   "def a():
  return time()"

                   "def a(x,y=2,z=4):
 print(z)"
                   "def a(x=1,y=2,z=4):
 print(z)"
                   "def a(x,y,z=4):
 print(z)"
                   "def a(x,y,z=4,*g):
 print(z)"

                   ;;optional and variable args
                   "def pyel_test(a,b=1,*c):
 if ab:
  x = a+b
 y = 3
 _a_()
 z.a = 4")

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
   "[\"n\", 324, 1, 2, [], {x: \"s\"}]")))

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
 ("x = [0]
for a in range(1,10):
 x.append(a)"
  ("x" '(0 1 2 3 4 5 6 7 8 9)))

 ("x = [0]
for a in range(10):
 if a % 2 == 0: continue
 x.append(a)"
  ("x" '(0 1 3 5 7 9)))

 ("x = [0]
for a in range(1,10):
 if a == 5: break
 x.append(a)"
  ("x" '(0 1 2 3 4)))

 ("b = [1,2,3,4]
c = 0
for a in b:
 c = c + a"
  ("c" 10)))

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

(pyel-create-tests lambda
                   "lambda x,y,z=4,*g: print(z);x()"
                   "x = range(2, 9)
x2 = reduce(lambda a,b:a+b, x)
assert x2 == 35"
                   )

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

(pyel-create-tests eval
                   ("x = 23
eval('x')" 23))

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
 chr-function
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
