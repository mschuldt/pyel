
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

;

(ert-deftest pyel-expand-type-switch ()
  ;;verify that both type expanders produce the same output
  (should (equal (pyel-expand-type-switch-2 '(l r)
                                            '((number number) ->  (* l r)
                                              (object _)      
                                              (_ object)  -> (--mul-- l r)
                                              (_ string)
                                              (string _)  -> (pyel-mul-num-str l r)))

                 (pyel-expand-type-switch-2 '(l r)
                                            '((number number) ->  (* l r)
                                              (object _)      
                                              (_ object)  -> (--mul-- l r)
                                              (_ string)
                                              (string _) -> (pyel-mul-num-str l r))))))

(ert-deftest pyel-do-splices ()
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

(pyel-create-tests assign
                   "a = 1"
                   "a.b = 1"
                   "a.b = c"
                   "a.b.c = 1"
                   "a.b = d.c"
                   "a,b = 1,2"
                   "a,b.c,x[2] = 1,a.c(),x[x()+y]"
                   "a = 1
b = 2
a,b= b,a
assert a == 2
assert b == 1"

                   "a,b = c"
                   "a,b,c = c.a"
                   "a,b = c.a()"
                   "a,b = c"
                   "a,b = a.e.e()"
                   "a[1:4], b[2], a.c = c"

                   "a = b = c"
                   "a = b = c.e"
                   "a = b = c.e()"
                   "a = b = c = 9.3"
                   "a = b = c = 9.3
assert a == b == c == 9.3"

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

(pyel-create-tests num "3" "4.23")

(pyel-create-tests name "testName")

(pyel-create-tests list
                   "[]"
                   "[a,1,2]"
                   "a = [1,2,a.b]"
                   "b = [1,[1,a,[a.b,[],3]]]"
                   "[[[[[[[a]]]]]]]")

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

;;

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

(ert-deftest pyel-arguments ()
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
 z.a = 4"
                   )

(pyel-create-tests binop
                   "assert 1//2 == 0"
                   "assert 1/2 == 0.5")

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

(pyel-create-tests class
                   "class test:
 def __init__(self,aa,bb):
  self.a = aa
  self.b = bb
 def geta(self):
  return self.a
 def getb(self):
  return self.b
x = test(5,6)
assert x.geta() == 5
assert x.getb() == 6
x.b = 2
assert x.getb() == 2")

(pyel-create-tests assert
                   "assert sldk()"
                   "assert adk,'messsage'")

(pyel-create-tests append
                   "a=[1,2,3]
a.append('str')
assert len(a) == 4
assert a[3] == 'str'"
                   )

;;

(pyel-create-tests len
                   "a = [1,2,3,'5']
assert len(a) == 4"
                   "a = []
assert len(a) == 0"
                   "a = 'str'
assert len(a) == 3"
                   "a = (1,2)
assert len(a) == 2"
                   "assert len('')==0"
                   )

;;

(ert-deftest pyel-py-list nil
    (should (equal (py-list "string")
                    '("s" "t" "r" "i" "n" "g")))
    (should (equal (py-list [2 3 4 4])
                   '(2 3 4 4)))
    (should (equal  (py-list '(2 3 4 4))
                    '(2 3 4 4)))
    (should (equal (py-list 23 4 2 "h")
                   '(23 4 2 "h")))
    (should (equal (py-list (let ((__h__ (make-hash-table :test (quote equal)))) (puthash 1 "1" __h__) (puthash "3" 3 __h__) (puthash 23 2 __h__) __h__))
                   '(23 "3" 1))))  
  ;;(pyel "{1:'1','3':3,23:2}")

;;

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
  "<function --ff- at 0x18b071>"))

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

;;

;;

;;

;;

;;

;;

;;

;;

;;

;;

(pyel-create-tests cond
                   "x = cond([1 > 2, 'first']
   [2 == 2, 'second']
   [5 == 7, 'third']
   [True, error('wtf')])
assert x == 'second'"
                   )

(pyel-create-tests lambda
                   "x = [2,3,4]
square = lambda([x]
 x*x)
y = mapcar(square,x)
assert y == [4,9,16]
"
                   "f = lambda([x,y]
if x > y:
 'x'
else:
 'y')
x=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])
assert x == ['y', 'y', 'x', 'y', 'x']")

;;

(pyel-create-tests for-loop
                   "b = [1,2,3,4]
c = 0
for a in b:
 c = c + a
assert c==10"

                   "for i in range(n):
 break"

                   "for i in range(n):
 continue"

                   "x = []
for i in range(5):
 if i == 2:
  continue
 x.append(i)
assert x == [0,1,3,4]"
)

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

(pyel-create-tests aug-assign
                   "a += b"
                   "a -= b"
                   "a /= b"
                   "a *= b"
                   "a **= b"
                   "a ^= b"
                   "a |= b"
                   "a = 3
b = 4
a += b + 1
assert a == 8"

                   "a.b += a[2]"
                   "a.b += 4"
                   "a.b += d.e"
                   )

;;

;;

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

;;

(pyel-create-tests list-comprehensions
                   "[x*x for x in range(10)]"
                   "[x*x for x in range(10) if x > 5]"
                   "[x*x for x in range(10) if x > 5 if x < 8]"

                   "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]"

                   "
matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
_x = [[row[i] for row in matrix] for i in range(4)]
assert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]"

                   "
transposed = []
for i in range(4):
 transposed.append([row[i] for row in matrix])
assert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
"

                   "{x: [y*y for y in range(x)] for x in range(20)}"

                   "x = {x: number_to_string(x) for x in range(10)}
assert hash_table_count(x) == 10
assert x[1] == '1'
assert x[9] == '9'
"

                   )

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

(provide 'pyel-tests)
;;pyel-tests.el ends here

;;
