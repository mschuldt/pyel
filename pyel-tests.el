
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

;; This is a tangled file  -- DO NOT HAND-EDIT -- 
(defalias 'pyel-verify 'pyel-run-tests)
(defun pyel-run-tests ()
  (interactive)
  (progv
      (mapcar 'car test-variable-values)
      (mapcar 'cadr test-variable-values)
    (ert-run-tests-interactively "pyel")))

(ert-deftest pyel-assign-full-transform nil
  (should
   (equal
    (pyel "a = 1")
    '(setq a 1)))
  (should
   (equal
    (pyel "a.b = 1")
    '(oset a b 1)))
  (should
   (equal
    (pyel "a.b = c")
    '(oset a b c)))
  (should
   (equal
    (pyel "a.b.c = 1")
    '(oset
      (oref a b)
      c 1)))
  (should
   (equal
    (pyel "a.b = d.c")
    '(oset a b
           (oref d c))))
  (should
   (equal
    (pyel "a,b = 1,2")
    '(let
         ((__1__ 1)
          (__2__ 2))
       (setq a __1__)
       (setq b __2__))))
  (should
   (equal
    (pyel "a,b.c,x[2] = 1,a.c(),x[x()+y]")
    '(let
         ((__1__ 1)
          (__2__
           (c a))
          (__3__
           (pyel-subscript-load-index x
                                      (pyel-+
                                       (x)
                                       y))))
       (setq a __1__)
       (oset b c __2__)
       (pyel-subscript-store-index x 2 __3__))))
  (should
   (equal
    (pyel "a = 1\nb = 2\na,b= b,a\nassert a == 2\nassert b == 1")
    '(progn
       (setq a 1)
       (setq b 2)
       (let
           ((__1__ b)
            (__2__ a))
         (setq a __1__)
         (setq b __2__))
       (assert
        (pyel-== a 2)
        t nil)
       (assert
        (pyel-== b 1)
        t nil))))
  (should
   (equal
    (pyel "a,b = c")
    '(let
         ((__value__ c))
       (setq a
             (pyel-subscript-load-index __value__ 0))
       (setq b
             (pyel-subscript-load-index __value__ 1)))))
  (should
   (equal
    (pyel "a,b,c = c.a")
    '(let
         ((__value__
           (oref c a)))
       (setq a
             (pyel-subscript-load-index __value__ 0))
       (setq b
             (pyel-subscript-load-index __value__ 1))
       (setq c
             (pyel-subscript-load-index __value__ 2)))))
  (should
   (equal
    (pyel "a,b = c.a()")
    '(let
         ((__value__
           (a c)))
       (setq a
             (pyel-subscript-load-index __value__ 0))
       (setq b
             (pyel-subscript-load-index __value__ 1)))))
  (should
   (equal
    (pyel "a,b = c")
    '(let
         ((__value__ c))
       (setq a
             (pyel-subscript-load-index __value__ 0))
       (setq b
             (pyel-subscript-load-index __value__ 1)))))
  (should
   (equal
    (pyel "a,b = a.e.e()")
    '(let
         ((__value__
           (e
            (oref a e))))
       (setq a
             (pyel-subscript-load-index __value__ 0))
       (setq b
             (pyel-subscript-load-index __value__ 1)))))
  (should
   (equal
    (pyel "a[1:4], b[2], a.c = c")
    '(let
         ((__value__ c))
       (pyel-subscript-store-slice a 1 4 nil
                                   (pyel-subscript-load-index __value__ 0))
       (pyel-subscript-store-index b 2
                                   (pyel-subscript-load-index __value__ 1))
       (oset a c
             (pyel-subscript-load-index __value__ 2)))))
  (should
   (equal
    (pyel "a = b = c")
    '(progn
       (setq b c)
       (setq a b))))
  (should
   (equal
    (pyel "a = b = c.e")
    '(progn
       (setq b
             (oref c e))
       (setq a b))))
  (should
   (equal
    (pyel "a = b = c.e()")
    '(progn
       (setq b
             (e c))
       (setq a b))))
  (should
   (equal
    (pyel "a = b = c = 9.3")
    '(progn
       (setq c 9.3)
       (setq b c)
       (setq a b))))
  (should
   (equal
    (pyel "a = b = c = 9.3\nassert a == b == c == 9.3")
    '(progn
       (setq c 9.3)
       (setq b c)
       (setq a b)
       (assert
        (and
         (pyel-== a b)
         (pyel-== b c)
         (pyel-== c 9.3))
        t nil)))))
(ert-deftest pyel-assign-py-ast nil
  (should
   (equal
    (py-ast "a = 1")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=1))])\n"))
  (should
   (equal
    (py-ast "a.b = 1")
    "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Num(n=1))])\n"))
  (should
   (equal
    (py-ast "a.b = c")
    "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Name(id='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b.c = 1")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Num(n=1))])\n"))
  (should
   (equal
    (py-ast "a.b = d.c")
    "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a,b = 1,2")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2)], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a,b.c,x[2] = 1,a.c(),x[x()+y]")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Store()), Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], ctx=Store())], value=Tuple(elts=[Num(n=1), Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=BinOp(left=Call(func=Name(id='x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), op=Add(), right=Name(id='y', ctx=Load()))), ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = 1\nb = 2\na,b= b,a\nassert a == 2\nassert b == 1")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=1)), Assign(targets=[Name(id='b', ctx=Store())], value=Num(n=2)), Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Tuple(elts=[Name(id='b', ctx=Load()), Name(id='a', ctx=Load())], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None), Assert(test=Compare(left=Name(id='b', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a,b = c")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a,b,c = c.a")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='a', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a,b = c.a()")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a,b = c")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a,b = a.e.e()")
    "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a[1:4], b[2], a.c = c")
    "Module(body=[Assign(targets=[Tuple(elts=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = b = c")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = b = c.e")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = b = c.e()")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a = b = c = 9.3")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], value=Num(n=9.3))])\n"))
  (should
   (equal
    (py-ast "a = b = c = 9.3\nassert a == b == c == 9.3")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], value=Num(n=9.3)), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq(), Eq(), Eq()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load()), Num(n=9.3)]), msg=None)])\n")))
(ert-deftest pyel-assign-el-ast nil
  (should
   (string=
    (pyel "a = 1" t)
    "(assign  ((name  \"a\" 'store)) (num 1))\n"))
  (should
   (string=
    (pyel "a.b = 1" t)
    "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (num 1))\n"))
  (should
   (string=
    (pyel "a.b = c" t)
    "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (name  \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a.b.c = 1" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (num 1))\n"))
  (should
   (string=
    (pyel "a.b = d.c" t)
    "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (attribute  (name  \"d\" 'load) \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a,b = 1,2" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (tuple  ((num 1) (num 2)) 'load))\n"))
  (should
   (string=
    (pyel "a,b.c,x[2] = 1,a.c(),x[x()+y]" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (attribute  (name  \"b\" 'load) \"c\" 'store) (subscript (name  \"x\" 'load) (index (num 2)) 'store)) 'store)) (tuple  ((num 1) (call  (attribute  (name  \"a\" 'load) \"c\" 'load) nil nil nil nil) (subscript (name  \"x\" 'load) (index (bin-op  (call  (name  \"x\" 'load) nil nil nil nil) + (name  \"y\" 'load))) 'load)) 'load))\n"))
  (should
   (string=
    (pyel "a = 1\nb = 2\na,b= b,a\nassert a == 2\nassert b == 1" t)
    "(assign  ((name  \"a\" 'store)) (num 1))\n(assign  ((name  \"b\" 'store)) (num 2))\n(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (tuple  ((name  \"b\" 'load) (name  \"a\" 'load)) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((num 2))) nil)\n(assert  (compare  (name  \"b\" 'load) (\"==\") ((num 1))) nil)\n"))
  (should
   (string=
    (pyel "a,b = c" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (name  \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a,b,c = c.a" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store) (name  \"c\" 'store)) 'store)) (attribute  (name  \"c\" 'load) \"a\" 'load))\n"))
  (should
   (string=
    (pyel "a,b = c.a()" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (call  (attribute  (name  \"c\" 'load) \"a\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "a,b = c" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (name  \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a,b = a.e.e()" t)
    "(assign  ((tuple  ((name  \"a\" 'store) (name  \"b\" 'store)) 'store)) (call  (attribute  (attribute  (name  \"a\" 'load) \"e\" 'load) \"e\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "a[1:4], b[2], a.c = c" t)
    "(assign  ((tuple  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store) (subscript (name  \"b\" 'load) (index (num 2)) 'store) (attribute  (name  \"a\" 'load) \"c\" 'store)) 'store)) (name  \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a = b = c" t)
    "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (name  \"c\" 'load))\n"))
  (should
   (string=
    (pyel "a = b = c.e" t)
    "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (attribute  (name  \"c\" 'load) \"e\" 'load))\n"))
  (should
   (string=
    (pyel "a = b = c.e()" t)
    "(assign  ((name  \"a\" 'store) (name  \"b\" 'store)) (call  (attribute  (name  \"c\" 'load) \"e\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "a = b = c = 9.3" t)
    "(assign  ((name  \"a\" 'store) (name  \"b\" 'store) (name  \"c\" 'store)) (num 9.3))\n"))
  (should
   (string=
    (pyel "a = b = c = 9.3\nassert a == b == c == 9.3" t)
    "(assign  ((name  \"a\" 'store) (name  \"b\" 'store) (name  \"c\" 'store)) (num 9.3))\n(assert  (compare  (name  \"a\" 'load) (\"==\" \"==\" \"==\") ((name  \"b\" 'load) (name  \"c\" 'load) (num 9.3))) nil)\n")))

(ert-deftest pyel-attribute-full-transform nil
  (should
   (equal
    (pyel "a.b")
    '(oref a b)))
  (should
   (equal
    (pyel "a.b.c")
    '(oref
      (oref a b)
      c)))
  (should
   (equal
    (pyel "a.b.c.e")
    '(oref
      (oref
       (oref a b)
       c)
      e)))
  (should
   (equal
    (pyel "a.b()")
    '(b a)))
  (should
   (equal
    (pyel "a.b.c()")
    '(c
      (oref a b))))
  (should
   (equal
    (pyel "a.b.c.d()")
    '(d
      (oref
       (oref a b)
       c))))
  (should
   (equal
    (pyel "a.b.c.d(1,3)")
    '(d
      (oref
       (oref a b)
       c)
      1 3)))
  (should
   (equal
    (pyel "a.b = 2")
    '(oset a b 2)))
  (should
   (equal
    (pyel "a.b.e = 2")
    '(oset
      (oref a b)
      e 2)))
  (should
   (equal
    (pyel "a.b.c = d.e")
    '(oset
      (oref a b)
      c
      (oref d e))))
  (should
   (equal
    (pyel "a.b.c = d.e.f")
    '(oset
      (oref a b)
      c
      (oref
       (oref d e)
       f))))
  (should
   (equal
    (pyel "a.b.c = d.e()")
    '(oset
      (oref a b)
      c
      (e d))))
  (should
   (equal
    (pyel "a.b.c = d.e.f()")
    '(oset
      (oref a b)
      c
      (f
       (oref d e)))))
  (should
   (equal
    (pyel "a.b.c = d.e.f(1,3)")
    '(oset
      (oref a b)
      c
      (f
       (oref d e)
       1 3))))
  (should
   (equal
    (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b")
    '(let
         ((__1__
           (f
            (oref d e)
            1 3))
          (__2__
           (oref
            (oref e g)
            b)))
       (oset a b __1__)
       (oset
        (oref a b)
        c __2__))))
  (should
   (equal
    (pyel "a.b(x.y,y)")
    '(b a
        (oref x y)
        y)))
  (should
   (equal
    (pyel "a.b(x.y(g.g()),y.y)")
    '(b a
        (y x
           (g g))
        (oref y y)))))
(ert-deftest pyel-attribute-py-ast nil
  (should
   (equal
    (py-ast "a.b")
    "Module(body=[Expr(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b.c")
    "Module(body=[Expr(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b.c.e")
    "Module(body=[Expr(value=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='e', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b()")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b.c()")
    "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b.c.d()")
    "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b.c.d(1,3)")
    "Module(body=[Expr(value=Call(func=Attribute(value=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Load()), attr='d', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b = 2")
    "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Num(n=2))])\n"))
  (should
   (equal
    (py-ast "a.b.e = 2")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='e', ctx=Store())], value=Num(n=2))])\n"))
  (should
   (equal
    (py-ast "a.b.c = d.e")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b.c = d.e.f")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b.c = d.e()")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b.c = d.e.f()")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b.c = d.e.f(1,3)")
    "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b, a.b.c = d.e.f(1,3), e.g.b")
    "Module(body=[Assign(targets=[Tuple(elts=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store()), Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Call(func=Attribute(value=Attribute(value=Name(id='d', ctx=Load()), attr='e', ctx=Load()), attr='f', ctx=Load()), args=[Num(n=1), Num(n=3)], keywords=[], starargs=None, kwargs=None), Attribute(value=Attribute(value=Name(id='e', ctx=Load()), attr='g', ctx=Load()), attr='b', ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a.b(x.y,y)")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), Name(id='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "a.b(x.y(g.g()),y.y)")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='y', ctx=Load()), args=[Call(func=Attribute(value=Name(id='g', ctx=Load()), attr='g', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None), Attribute(value=Name(id='y', ctx=Load()), attr='y', ctx=Load())], keywords=[], starargs=None, kwargs=None))])\n")))
(ert-deftest pyel-attribute-el-ast nil
  (should
   (string=
    (pyel "a.b" t)
    "(attribute  (name  \"a\" 'load) \"b\" 'load)\n"))
  (should
   (string=
    (pyel "a.b.c" t)
    "(attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load)\n"))
  (should
   (string=
    (pyel "a.b.c.e" t)
    "(attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"e\" 'load)\n"))
  (should
   (string=
    (pyel "a.b()" t)
    "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "a.b.c()" t)
    "(call  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "a.b.c.d()" t)
    "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"d\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "a.b.c.d(1,3)" t)
    "(call  (attribute  (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'load) \"d\" 'load) ((num 1) (num 3)) nil nil nil)\n"))
  (should
   (string=
    (pyel "a.b = 2" t)
    "(assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (num 2))\n"))
  (should
   (string=
    (pyel "a.b.e = 2" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"e\" 'store)) (num 2))\n"))
  (should
   (string=
    (pyel "a.b.c = d.e" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (attribute  (name  \"d\" 'load) \"e\" 'load))\n"))
  (should
   (string=
    (pyel "a.b.c = d.e.f" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load))\n"))
  (should
   (string=
    (pyel "a.b.c = d.e()" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (name  \"d\" 'load) \"e\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "a.b.c = d.e.f()" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "a.b.c = d.e.f(1,3)" t)
    "(assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) ((num 1) (num 3)) nil nil nil))\n"))
  (should
   (string=
    (pyel "a.b, a.b.c = d.e.f(1,3), e.g.b" t)
    "(assign  ((tuple  ((attribute  (name  \"a\" 'load) \"b\" 'store) (attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) 'store)) (tuple  ((call  (attribute  (attribute  (name  \"d\" 'load) \"e\" 'load) \"f\" 'load) ((num 1) (num 3)) nil nil nil) (attribute  (attribute  (name  \"e\" 'load) \"g\" 'load) \"b\" 'load)) 'load))\n"))
  (should
   (string=
    (pyel "a.b(x.y,y)" t)
    "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((attribute  (name  \"x\" 'load) \"y\" 'load) (name  \"y\" 'load)) nil nil nil)\n"))
  (should
   (string=
    (pyel "a.b(x.y(g.g()),y.y)" t)
    "(call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((call  (attribute  (name  \"x\" 'load) \"y\" 'load) ((call  (attribute  (name  \"g\" 'load) \"g\" 'load) nil nil nil nil)) nil nil nil) (attribute  (name  \"y\" 'load) \"y\" 'load)) nil nil nil)\n")))

(ert-deftest pyel-num-full-transform nil
  (should
   (equal
    (pyel "3")
    '3))
  (should
   (equal
    (pyel "4.23")
    '4.23)))
(ert-deftest pyel-num-py-ast nil
  (should
   (equal
    (py-ast "3")
    "Module(body=[Expr(value=Num(n=3))])\n"))
  (should
   (equal
    (py-ast "4.23")
    "Module(body=[Expr(value=Num(n=4.23))])\n")))
(ert-deftest pyel-num-el-ast nil
  (should
   (string=
    (pyel "3" t)
    "(num 3)\n"))
  (should
   (string=
    (pyel "4.23" t)
    "(num 4.23)\n")))

(ert-deftest pyel-name-full-transform nil
  (should
   (equal
    (pyel "testName")
    'testName)))
(ert-deftest pyel-name-py-ast nil
  (should
   (equal
    (py-ast "testName")
    "Module(body=[Expr(value=Name(id='testName', ctx=Load()))])\n")))
(ert-deftest pyel-name-el-ast nil
  (should
   (string=
    (pyel "testName" t)
    "(name  \"testName\" 'load)\n")))

(ert-deftest pyel-list-full-transform nil
  (should
   (equal
    (pyel "[]")
    '(list)))
  (should
   (equal
    (pyel "[a,1,2]")
    '(list a 1 2)))
  (should
   (equal
    (pyel "a = [1,2,a.b]")
    '(setq a
           (list 1 2
                 (oref a b)))))
  (should
   (equal
    (pyel "b = [1,[1,a,[a.b,[],3]]]")
    '(setq b
           (list 1
                 (list 1 a
                       (list
                        (oref a b)
                        (list)
                        3))))))
  (should
   (equal
    (pyel "[[[[[[[a]]]]]]]")
    '(list
      (list
       (list
        (list
         (list
          (list
           (list a))))))))))
(ert-deftest pyel-list-py-ast nil
  (should
   (equal
    (py-ast "[]")
    "Module(body=[Expr(value=List(elts=[], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "[a,1,2]")
    "Module(body=[Expr(value=List(elts=[Name(id='a', ctx=Load()), Num(n=1), Num(n=2)], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = [1,2,a.b]")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "b = [1,[1,a,[a.b,[],3]]]")
    "Module(body=[Assign(targets=[Name(id='b', ctx=Store())], value=List(elts=[Num(n=1), List(elts=[Num(n=1), Name(id='a', ctx=Load()), List(elts=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), List(elts=[], ctx=Load()), Num(n=3)], ctx=Load())], ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "[[[[[[[a]]]]]]]")
    "Module(body=[Expr(value=List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[List(elts=[Name(id='a', ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load()))])\n")))
(ert-deftest pyel-list-el-ast nil
  (should
   (string=
    (pyel "[]" t)
    "(list nil 'load)\n"))
  (should
   (string=
    (pyel "[a,1,2]" t)
    "(list ((name  \"a\" 'load) (num 1) (num 2)) 'load)\n"))
  (should
   (string=
    (pyel "a = [1,2,a.b]" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (attribute  (name  \"a\" 'load) \"b\" 'load)) 'load))\n"))
  (should
   (string=
    (pyel "b = [1,[1,a,[a.b,[],3]]]" t)
    "(assign  ((name  \"b\" 'store)) (list ((num 1) (list ((num 1) (name  \"a\" 'load) (list ((attribute  (name  \"a\" 'load) \"b\" 'load) (list nil 'load) (num 3)) 'load)) 'load)) 'load))\n"))
  (should
   (string=
    (pyel "[[[[[[[a]]]]]]]" t)
    "(list ((list ((list ((list ((list ((list ((list ((name  \"a\" 'load)) 'load)) 'load)) 'load)) 'load)) 'load)) 'load)) 'load)\n")))

(ert-deftest pyel-dict-full-transform nil
  (should
   (equal
    (pyel "{'a':2, 'b':4}")
    '(let
         ((__h__
           (make-hash-table :test 'equal)))
       (puthash "a" 2 __h__)
       (puthash "b" 4 __h__)
       __h__)))
  (should
   (equal
    (pyel "a = {a:2, b:4}")
    '(setq a
           (let
               ((__h__
                 (make-hash-table :test 'equal)))
             (puthash a 2 __h__)
             (puthash b 4 __h__)
             __h__))))
  (should
   (equal
    (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}")
    '(setq x
           (let
               ((__h__
                 (make-hash-table :test 'equal)))
             (puthash "a" 2 __h__)
             (puthash "b" 4 __h__)
             (puthash "c"
                      (let
                          ((__h__
                            (make-hash-table :test 'equal)))
                        (puthash "d" 1 __h__)
                        (puthash "e" 2 __h__)
                        (puthash f
                                 (let
                                     ((__h__
                                       (make-hash-table :test 'equal)))
                                   (puthash g 3 __h__)
                                   __h__)
                                 __h__)
                        __h__)
                      __h__)
             __h__)))))
(ert-deftest pyel-dict-py-ast nil
  (should
   (equal
    (py-ast "{'a':2, 'b':4}")
    "Module(body=[Expr(value=Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=2), Num(n=4)]))])\n"))
  (should
   (equal
    (py-ast "a = {a:2, b:4}")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Dict(keys=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], values=[Num(n=2), Num(n=4)]))])\n"))
  (should
   (equal
    (py-ast "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Dict(keys=[Str(s='a'), Str(s='b'), Str(s='c')], values=[Num(n=2), Num(n=4), Dict(keys=[Str(s='d'), Str(s='e'), Name(id='f', ctx=Load())], values=[Num(n=1), Num(n=2), Dict(keys=[Name(id='g', ctx=Load())], values=[Num(n=3)])])]))])\n")))
(ert-deftest pyel-dict-el-ast nil
  (should
   (string=
    (pyel "{'a':2, 'b':4}" t)
    "(dict ((str \"a\") (str \"b\")) ((num 2) (num 4)))\n"))
  (should
   (string=
    (pyel "a = {a:2, b:4}" t)
    "(assign  ((name  \"a\" 'store)) (dict ((name  \"a\" 'load) (name  \"b\" 'load)) ((num 2) (num 4))))\n"))
  (should
   (string=
    (pyel "x = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,f:{g:3}}}" t)
    "(assign  ((name  \"x\" 'store)) (dict ((str \"a\") (str \"b\") (str \"c\")) ((num 2) (num 4) (dict ((str \"d\") (str \"e\") (name  \"f\" 'load)) ((num 1) (num 2) (dict ((name  \"g\" 'load)) ((num 3))))))))\n")))

(ert-deftest pyel-Tuple-full-transform nil
  (should
   (equal
    (pyel "()")
    '(vector)))
  (should
   (equal
    (pyel "(a, b)")
    '(vector a b)))
  (should
   (equal
    (pyel "(a, (b, (c,d)))")
    '(vector a
             (vector b
                     (vector c d)))))
  (should
   (equal
    (pyel "((((((((a))))))))")
    'a)))
(ert-deftest pyel-Tuple-py-ast nil
  (should
   (equal
    (py-ast "()")
    "Module(body=[Expr(value=Tuple(elts=[], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "(a, b)")
    "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "(a, (b, (c,d)))")
    "Module(body=[Expr(value=Tuple(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Name(id='b', ctx=Load()), Tuple(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())], ctx=Load())], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "((((((((a))))))))")
    "Module(body=[Expr(value=Name(id='a', ctx=Load()))])\n")))
(ert-deftest pyel-Tuple-el-ast nil
  (should
   (string=
    (pyel "()" t)
    "(tuple  nil 'load)\n"))
  (should
   (string=
    (pyel "(a, b)" t)
    "(tuple  ((name  \"a\" 'load) (name  \"b\" 'load)) 'load)\n"))
  (should
   (string=
    (pyel "(a, (b, (c,d)))" t)
    "(tuple  ((name  \"a\" 'load) (tuple  ((name  \"b\" 'load) (tuple  ((name  \"c\" 'load) (name  \"d\" 'load)) 'load)) 'load)) 'load)\n"))
  (should
   (string=
    (pyel "((((((((a))))))))" t)
    "(name  \"a\" 'load)\n")))

(ert-deftest pyel-str-full-transform nil
  (should
   (equal
    (pyel "'a'")
    '"a"))
  (should
   (equal
    (pyel "x = 'a'")
    '(setq x "a")))
  (should
   (equal
    (pyel "['a','b']")
    '(list "a" "b"))))
(ert-deftest pyel-str-py-ast nil
  (should
   (equal
    (py-ast "'a'")
    "Module(body=[Expr(value=Str(s='a'))])\n"))
  (should
   (equal
    (py-ast "x = 'a'")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='a'))])\n"))
  (should
   (equal
    (py-ast "['a','b']")
    "Module(body=[Expr(value=List(elts=[Str(s='a'), Str(s='b')], ctx=Load()))])\n")))
(ert-deftest pyel-str-el-ast nil
  (should
   (string=
    (pyel "'a'" t)
    "(str \"a\")\n"))
  (should
   (string=
    (pyel "x = 'a'" t)
    "(assign  ((name  \"x\" 'store)) (str \"a\"))\n"))
  (should
   (string=
    (pyel "['a','b']" t)
    "(list ((str \"a\") (str \"b\")) 'load)\n")))

;;

(ert-deftest pyel-compare-full-transform nil
  (should
   (equal
    (pyel "a=='d'")
    '(pyel-== a "d")))
  (should
   (equal
    (pyel "a==b")
    '(pyel-== a b)))
  (should
   (equal
    (pyel "a>=b")
    '(pyel->= a b)))
  (should
   (equal
    (pyel "a<=b")
    '(pyel-<= a b)))
  (should
   (equal
    (pyel "a<b")
    '(pyel-< a b)))
  (should
   (equal
    (pyel "a>b")
    '(pyel-> a b)))
  (should
   (equal
    (pyel "a!=b")
    '(pyel-!= a b)))
  (should
   (equal
    (pyel "(a,b) == [c,d]")
    '(pyel-==
      (vector a b)
      (list c d))))
  (should
   (equal
    (pyel "[a == 1]")
    '(list
      (pyel-== a 1))))
  (should
   (equal
    (pyel "((a == 1),)")
    '(vector
      (pyel-== a 1))))
  (should
   (equal
    (pyel "a<b<c")
    '(and
      (pyel-< a b)
      (pyel-< b c))))
  (should
   (equal
    (pyel "a<=b<c<=d")
    '(and
      (pyel-<= a b)
      (pyel-< b c)
      (pyel-<= c d))))
  (should
   (equal
    (pyel "a.b<=b.c()<c<=3")
    '(and
      (pyel-<=
       (oref a b)
       (c b))
      (pyel-<
       (c b)
       c)
      (pyel-<= c 3)))))
(ert-deftest pyel-compare-py-ast nil
  (should
   (equal
    (py-ast "a=='d'")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='d')]))])\n"))
  (should
   (equal
    (py-ast "a==b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a>=b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[GtE()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a<=b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a<b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a>b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a!=b")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[NotEq()], comparators=[Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "(a,b) == [c,d]")
    "Module(body=[Expr(value=Compare(left=Tuple(elts=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())], ctx=Load()), ops=[Eq()], comparators=[List(elts=[Name(id='c', ctx=Load()), Name(id='d', ctx=Load())], ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "[a == 1]")
    "Module(body=[Expr(value=List(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "((a == 1),)")
    "Module(body=[Expr(value=Tuple(elts=[Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)])], ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a<b<c")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[Lt(), Lt()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a<=b<c<=d")
    "Module(body=[Expr(value=Compare(left=Name(id='a', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Name(id='b', ctx=Load()), Name(id='c', ctx=Load()), Name(id='d', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a.b<=b.c()<c<=3")
    "Module(body=[Expr(value=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE(), Lt(), LtE()], comparators=[Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Name(id='c', ctx=Load()), Num(n=3)]))])\n")))
(ert-deftest pyel-compare-el-ast nil
  (should
   (string=
    (pyel "a=='d'" t)
    "(compare  (name  \"a\" 'load) (\"==\") ((str \"d\")))\n"))
  (should
   (string=
    (pyel "a==b" t)
    "(compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a>=b" t)
    "(compare  (name  \"a\" 'load) (\">=\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a<=b" t)
    "(compare  (name  \"a\" 'load) (\"<=\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a<b" t)
    "(compare  (name  \"a\" 'load) (\"<\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a>b" t)
    "(compare  (name  \"a\" 'load) (\">\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a!=b" t)
    "(compare  (name  \"a\" 'load) (\"!=\") ((name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "(a,b) == [c,d]" t)
    "(compare  (tuple  ((name  \"a\" 'load) (name  \"b\" 'load)) 'load) (\"==\") ((list ((name  \"c\" 'load) (name  \"d\" 'load)) 'load)))\n"))
  (should
   (string=
    (pyel "[a == 1]" t)
    "(list ((compare  (name  \"a\" 'load) (\"==\") ((num 1)))) 'load)\n"))
  (should
   (string=
    (pyel "((a == 1),)" t)
    "(tuple  ((compare  (name  \"a\" 'load) (\"==\") ((num 1)))) 'load)\n"))
  (should
   (string=
    (pyel "a<b<c" t)
    "(compare  (name  \"a\" 'load) (\"<\" \"<\") ((name  \"b\" 'load) (name  \"c\" 'load)))\n"))
  (should
   (string=
    (pyel "a<=b<c<=d" t)
    "(compare  (name  \"a\" 'load) (\"<=\" \"<\" \"<=\") ((name  \"b\" 'load) (name  \"c\" 'load) (name  \"d\" 'load)))\n"))
  (should
   (string=
    (pyel "a.b<=b.c()<c<=3" t)
    "(compare  (attribute  (name  \"a\" 'load) \"b\" 'load) (\"<=\" \"<\" \"<=\") ((call  (attribute  (name  \"b\" 'load) \"c\" 'load) nil nil nil nil) (name  \"c\" 'load) (num 3)))\n")))

(ert-deftest pyel-if-full-transform nil
  (should
   (equal
    (pyel "if (a==b):\n  b=c\nelse:\n  a = d")
    '(if
         (pyel-== a b)
         (progn
           (setq b c))
       (setq a d))))
  (should
   (equal
    (pyel "if (a==b):\n   b=c\n   z=1\nelse:\n  a = 4\n  b = a.b")
    '(if
         (pyel-== a b)
         (progn
           (setq b c)
           (setq z 1))
       (setq a 4)
       (setq b
             (oref a b)))))
  (should
   (equal
    (pyel "if (a.b <= a.e):\n a.b=(2.1,2)\nelse:\n b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]")
    '(if
         (pyel-<=
          (oref a b)
          (oref a e))
         (progn
           (oset a b
                 (vector 2.1 2)))
       (oset
        (oref b a)
        c
        (list a
              (let
                  ((__h__
                    (make-hash-table :test 'equal)))
                (puthash "a" 23.3 __h__)
                (puthash "b"
                         (vector 3.2 3.1)
                         __h__)
                __h__)))))))
(ert-deftest pyel-if-py-ast nil
  (should
   (equal
    (py-ast "if (a==b):\n  b=c\nelse:\n  a = d")
    "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='d', ctx=Load()))])])\n"))
  (should
   (equal
    (py-ast "if (a==b):\n   b=c\n   z=1\nelse:\n  a = 4\n  b = a.b")
    "Module(body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Assign(targets=[Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load())), Assign(targets=[Name(id='z', ctx=Store())], value=Num(n=1))], orelse=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=4)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()))])])\n"))
  (should
   (equal
    (py-ast "if (a.b <= a.e):\n a.b=(2.1,2)\nelse:\n b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]")
    "Module(body=[If(test=Compare(left=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), ops=[LtE()], comparators=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load())]), body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Tuple(elts=[Num(n=2.1), Num(n=2)], ctx=Load()))], orelse=[Assign(targets=[Attribute(value=Attribute(value=Name(id='b', ctx=Load()), attr='a', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Dict(keys=[Str(s='a'), Str(s='b')], values=[Num(n=23.3), Tuple(elts=[Num(n=3.2), Num(n=3.1)], ctx=Load())])], ctx=Load()))])])\n")))
(ert-deftest pyel-if-el-ast nil
  (should
   (string=
    (pyel "if (a==b):\n  b=c\nelse:\n  a = d" t)
    "(if  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((assign  ((name  \"b\" 'store)) (name  \"c\" 'load))) ((assign  ((name  \"a\" 'store)) (name  \"d\" 'load))))\n"))
  (should
   (string=
    (pyel "if (a==b):\n   b=c\n   z=1\nelse:\n  a = 4\n  b = a.b" t)
    "(if  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((assign  ((name  \"b\" 'store)) (name  \"c\" 'load)) (assign  ((name  \"z\" 'store)) (num 1))) ((assign  ((name  \"a\" 'store)) (num 4)) (assign  ((name  \"b\" 'store)) (attribute  (name  \"a\" 'load) \"b\" 'load))))\n"))
  (should
   (string=
    (pyel "if (a.b <= a.e):\n a.b=(2.1,2)\nelse:\n b.a.c=[a,{'a':23.3,'b':(3.2,3.1)}]" t)
    "(if  (compare  (attribute  (name  \"a\" 'load) \"b\" 'load) (\"<=\") ((attribute  (name  \"a\" 'load) \"e\" 'load))) ((assign  ((attribute  (name  \"a\" 'load) \"b\" 'store)) (tuple  ((num 2.1) (num 2)) 'load))) ((assign  ((attribute  (attribute  (name  \"b\" 'load) \"a\" 'load) \"c\" 'store)) (list ((name  \"a\" 'load) (dict ((str \"a\") (str \"b\")) ((num 23.3) (tuple  ((num 3.2) (num 3.1)) 'load)))) 'load))))\n")))

(ert-deftest pyel-call-full-transform nil
  (should
   (equal
    (pyel "aa()")
    '(aa)))
  (should
   (equal
    (pyel "aa(b,c(1,2))")
    '(aa b
         (c 1 2))))
  (should
   (equal
    (pyel "aa=b()")
    '(setq aa
           (b))))
  (should
   (equal
    (pyel "aa(3,b(c(),[2,(2,3)]))")
    '(aa 3
         (b
          (c)
          (list 2
                (vector 2 3))))))
  (should
   (equal
    (pyel "aa.b()")
    '(b aa)))
  (should
   (equal
    (pyel "aa.b(1,2)")
    '(b aa 1 2)))
  (should
   (equal
    (pyel "aa.b(1,a.b(1,2,3))")
    '(b aa 1
        (b a 1 2 3)))))
(ert-deftest pyel-call-py-ast nil
  (should
   (equal
    (py-ast "aa()")
    "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa(b,c(1,2))")
    "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Name(id='b', ctx=Load()), Call(func=Name(id='c', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa=b()")
    "Module(body=[Assign(targets=[Name(id='aa', ctx=Store())], value=Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa(3,b(c(),[2,(2,3)]))")
    "Module(body=[Expr(value=Call(func=Name(id='aa', ctx=Load()), args=[Num(n=3), Call(func=Name(id='b', ctx=Load()), args=[Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), List(elts=[Num(n=2), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load())], ctx=Load())], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa.b()")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa.b(1,2)")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2)], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "aa.b(1,a.b(1,2,3))")
    "Module(body=[Expr(value=Call(func=Attribute(value=Name(id='aa', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), args=[Num(n=1), Num(n=2), Num(n=3)], keywords=[], starargs=None, kwargs=None)], keywords=[], starargs=None, kwargs=None))])\n")))
(ert-deftest pyel-call-el-ast nil
  (should
   (string=
    (pyel "aa()" t)
    "(call  (name  \"aa\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "aa(b,c(1,2))" t)
    "(call  (name  \"aa\" 'load) ((name  \"b\" 'load) (call  (name  \"c\" 'load) ((num 1) (num 2)) nil nil nil)) nil nil nil)\n"))
  (should
   (string=
    (pyel "aa=b()" t)
    "(assign  ((name  \"aa\" 'store)) (call  (name  \"b\" 'load) nil nil nil nil))\n"))
  (should
   (string=
    (pyel "aa(3,b(c(),[2,(2,3)]))" t)
    "(call  (name  \"aa\" 'load) ((num 3) (call  (name  \"b\" 'load) ((call  (name  \"c\" 'load) nil nil nil nil) (list ((num 2) (tuple  ((num 2) (num 3)) 'load)) 'load)) nil nil nil)) nil nil nil)\n"))
  (should
   (string=
    (pyel "aa.b()" t)
    "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "aa.b(1,2)" t)
    "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) ((num 1) (num 2)) nil nil nil)\n"))
  (should
   (string=
    (pyel "aa.b(1,a.b(1,2,3))" t)
    "(call  (attribute  (name  \"aa\" 'load) \"b\" 'load) ((num 1) (call  (attribute  (name  \"a\" 'load) \"b\" 'load) ((num 1) (num 2) (num 3)) nil nil nil)) nil nil nil)\n")))

(ert-deftest pyel-while-full-transform nil
  (should
   (equal
    (pyel "while (a==b):\n  print('hi')")
    '(while
         (pyel-== a b)
       (print "hi"))))
  (should
   (equal
    (pyel "while (a==b):\n  print('hi')\n  a=b")
    '(while
         (pyel-== a b)
       (print "hi")
       (setq a b))))
  (should
   (equal
    (pyel "while (a==b):\n  while (a>2):\n    b(3,[a,2])\n    b=c.e\n  a=b")
    '(while
         (pyel-== a b)
       (while
           (pyel-> a 2)
         (b 3
            (list a 2))
         (setq b
               (oref c e)))
       (setq a b))))
  (should
   (equal
    (pyel "while a:\n if b:\n  break\n else:\n  c()")
    '(catch '__break__
       (while a
         (if b
             (progn
               (throw '__break__ nil))
           (c))))))
  (should
   (equal
    (pyel "while a:\n if b:\n  continue\n c()")
    '(while a
       (catch '__continue__
         (if b
             (progn
               (throw '__continue__ nil)))
         (c))))))
(ert-deftest pyel-while-py-ast nil
  (should
   (equal
    (py-ast "while (a==b):\n  print('hi')")
    "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None))], orelse=[])])\n"))
  (should
   (equal
    (py-ast "while (a==b):\n  print('hi')\n  a=b")
    "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='hi')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])\n"))
  (should
   (equal
    (py-ast "while (a==b):\n  while (a>2):\n    b(3,[a,2])\n    b=c.e\n  a=b")
    "Module(body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Name(id='b', ctx=Load())]), body=[While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Gt()], comparators=[Num(n=2)]), body=[Expr(value=Call(func=Name(id='b', ctx=Load()), args=[Num(n=3), List(elts=[Name(id='a', ctx=Load()), Num(n=2)], ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))], orelse=[]), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], orelse=[])])\n"))
  (should
   (equal
    (py-ast "while a:\n if b:\n  break\n else:\n  c()")
    "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Break()], orelse=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])\n"))
  (should
   (equal
    (py-ast "while a:\n if b:\n  continue\n c()")
    "Module(body=[While(test=Name(id='a', ctx=Load()), body=[If(test=Name(id='b', ctx=Load()), body=[Continue()], orelse=[]), Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], orelse=[])])\n")))
(ert-deftest pyel-while-el-ast nil
  (should
   (string=
    (pyel "while (a==b):\n  print('hi')" t)
    "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((call  (name  \"print\" 'load) ((str \"hi\")) nil nil nil)) nil)\n"))
  (should
   (string=
    (pyel "while (a==b):\n  print('hi')\n  a=b" t)
    "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((call  (name  \"print\" 'load) ((str \"hi\")) nil nil nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil)\n"))
  (should
   (string=
    (pyel "while (a==b):\n  while (a>2):\n    b(3,[a,2])\n    b=c.e\n  a=b" t)
    "(while  (compare  (name  \"a\" 'load) (\"==\") ((name  \"b\" 'load))) ((while  (compare  (name  \"a\" 'load) (\">\") ((num 2))) ((call  (name  \"b\" 'load) ((num 3) (list ((name  \"a\" 'load) (num 2)) 'load)) nil nil nil) (assign  ((name  \"b\" 'store)) (attribute  (name  \"c\" 'load) \"e\" 'load))) nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil)\n"))
  (should
   (string=
    (pyel "while a:\n if b:\n  break\n else:\n  c()" t)
    "(while  (name  \"a\" 'load) ((if  (name  \"b\" 'load) ((break)) ((call  (name  \"c\" 'load) nil nil nil nil)))) nil)\n"))
  (should
   (string=
    (pyel "while a:\n if b:\n  continue\n c()" t)
    "(while  (name  \"a\" 'load) ((if  (name  \"b\" 'load) ((continue)) nil) (call  (name  \"c\" 'load) nil nil nil nil)) nil)\n")))

(ert-deftest pyel-arguments ()
  (with-transform-table 'pyel
                        (and 
                         (should (equal (transform '(arguments ((arg "b" nil)
                                                                (arg "c" nil)) nil nil nil nil nil nil nil))
                                        
                                        '(b c)))
                         ;;other tests here
                         )))

(ert-deftest pyel-def-full-transform nil
  (should
   (equal
    (pyel "def a(b,c):\n  print('ok')\n  a=b")
    '(defun a
       (b c)
       (let
           (a)
         (print "ok")
         (setq a b)))))
  (should
   (equal
    (pyel "def a(b,c):\n  if (a==b()):\n    c()\n    while (a < d.b):\n      b,c = 1,3\n  a.b.c = [a,(2,2)]")
    '(defun a
       (b c)
       (let
           (b c)
         (if
             (pyel-== a
                      (b))
             (progn
               (c)
               (while
                   (pyel-< a
                           (oref d b))
                 (let
                     ((__1__ 1)
                      (__2__ 3))
                   (setq b __1__)
                   (setq c __2__)))))
         (oset
          (oref a b)
          c
          (list a
                (vector 2 2)))))))
  (should
   (equal
    (pyel "def a():\n  return time()")
    '(defun a nil
       (time))))
  (should
   (equal
    (pyel "def a(x,y=2,z=4):\n print(z)")
    '(defun a
       (x &optional y z)
       (setq z
             (or z 4))
       (setq y
             (or y 2))
       (print z))))
  (should
   (equal
    (pyel "def a(x=1,y=2,z=4):\n print(z)")
    '(defun a
       (&optional x y z)
       (setq z
             (or z 4))
       (setq y
             (or y 2))
       (setq x
             (or x 1))
       (print z))))
  (should
   (equal
    (pyel "def a(x,y,z=4):\n print(z)")
    '(defun a
       (x y &optional z)
       (setq z
             (or z 4))
       (print z))))
  (should
   (equal
    (pyel "def a(x,y,z=4,*g):\n print(z)")
    '(defun a
       (x y &optional z &rest g)
       (setq z
             (or z 4))
       (print z))))
  (should
   (equal
    (pyel "def pyel_test(a,b=1,*c):\n if ab:\n  x = a+b\n y = 3\n _a_()\n z.a = 4")
    '(defun pyel-test
       (a &optional b &rest c)
       (setq b
             (or b 1))
       (let
           (x y)
         (if ab
             (progn
               (setq x
                     (pyel-+ a b))))
         (setq y 3)
         (-a-)
         (oset z a 4))))))
(ert-deftest pyel-def-py-ast nil
  (should
   (equal
    (py-ast "def a(b,c):\n  print('ok')\n  a=b")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Str(s='ok')], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='a', ctx=Store())], value=Name(id='b', ctx=Load()))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a(b,c):\n  if (a==b()):\n    c()\n    while (a < d.b):\n      b,c = 1,3\n  a.b.c = [a,(2,2)]")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='b', annotation=None), arg(arg='c', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[If(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Call(func=Name(id='b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), body=[Expr(value=Call(func=Name(id='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), While(test=Compare(left=Name(id='a', ctx=Load()), ops=[Lt()], comparators=[Attribute(value=Name(id='d', ctx=Load()), attr='b', ctx=Load())]), body=[Assign(targets=[Tuple(elts=[Name(id='b', ctx=Store()), Name(id='c', ctx=Store())], ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()))], orelse=[])], orelse=[]), Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=List(elts=[Name(id='a', ctx=Load()), Tuple(elts=[Num(n=2), Num(n=2)], ctx=Load())], ctx=Load()))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a():\n  return time()")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=Call(func=Name(id='time', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a(x,y=2,z=4):\n print(z)")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a(x=1,y=2,z=4):\n print(z)")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1), Num(n=2), Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a(x,y,z=4):\n print(z)")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def a(x,y,z=4,*g):\n print(z)")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "def pyel_test(a,b=1,*c):\n if ab:\n  x = a+b\n y = 3\n _a_()\n z.a = 4")
    "Module(body=[FunctionDef(name='pyel_test', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg='c', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=1)], kw_defaults=[]), body=[If(test=Name(id='ab', ctx=Load()), body=[Assign(targets=[Name(id='x', ctx=Store())], value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], orelse=[]), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=3)), Expr(value=Call(func=Name(id='_a_', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Attribute(value=Name(id='z', ctx=Load()), attr='a', ctx=Store())], value=Num(n=4))], decorator_list=[], returns=None)])\n")))
(ert-deftest pyel-def-el-ast nil
  (should
   (string=
    (pyel "def a(b,c):\n  print('ok')\n  a=b" t)
    "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((call  (name  \"print\" 'load) ((str \"ok\")) nil nil nil) (assign  ((name  \"a\" 'store)) (name  \"b\" 'load))) nil nil )\n"))
  (should
   (string=
    (pyel "def a(b,c):\n  if (a==b()):\n    c()\n    while (a < d.b):\n      b,c = 1,3\n  a.b.c = [a,(2,2)]" t)
    "(def \" a \" ((arguments  ((arg \"b\"  nil) (arg \"c\"  nil)) nil nil nil nil nil nil nil )) ((if  (compare  (name  \"a\" 'load) (\"==\") ((call  (name  \"b\" 'load) nil nil nil nil))) ((call  (name  \"c\" 'load) nil nil nil nil) (while  (compare  (name  \"a\" 'load) (\"<\") ((attribute  (name  \"d\" 'load) \"b\" 'load))) ((assign  ((tuple  ((name  \"b\" 'store) (name  \"c\" 'store)) 'store)) (tuple  ((num 1) (num 3)) 'load))) nil)) nil) (assign  ((attribute  (attribute  (name  \"a\" 'load) \"b\" 'load) \"c\" 'store)) (list ((name  \"a\" 'load) (tuple  ((num 2) (num 2)) 'load)) 'load))) nil nil )\n"))
  (should
   (string=
    (pyel "def a():\n  return time()" t)
    "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((return (call  (name  \"time\" 'load) nil nil nil nil))) nil nil )\n"))
  (should
   (string=
    (pyel "def a(x,y=2,z=4):\n print(z)" t)
    "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 2) (num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )\n"))
  (should
   (string=
    (pyel "def a(x=1,y=2,z=4):\n print(z)" t)
    "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 1) (num 2) (num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )\n"))
  (should
   (string=
    (pyel "def a(x,y,z=4):\n print(z)" t)
    "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) nil nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )\n"))
  (should
   (string=
    (pyel "def a(x,y,z=4,*g):\n print(z)" t)
    "(def \" a \" ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)) nil nil )\n"))
  (should
   (string=
    (pyel "def pyel_test(a,b=1,*c):\n if ab:\n  x = a+b\n y = 3\n _a_()\n z.a = 4" t)
    "(def \" pyel_test \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) c nil nil nil nil ((num 1)) nil )) ((if  (name  \"ab\" 'load) ((assign  ((name  \"x\" 'store)) (bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) nil) (assign  ((name  \"y\" 'store)) (num 3)) (call  (name  \"_a_\" 'load) nil nil nil nil) (assign  ((attribute  (name  \"z\" 'load) \"a\" 'store)) (num 4))) nil nil )\n")))

(ert-deftest pyel-binop-full-transform nil
  (should
   (equal
    (pyel "assert 1//2 == 0")
    '(assert
      (pyel-==
       (pyel-// 1 2)
       0)
      t nil)))
  (should
   (equal
    (pyel "assert 1/2 == 0.5")
    '(assert
      (pyel-==
       (pyel-/ 1 2)
       0.5)
      t nil))))
(ert-deftest pyel-binop-py-ast nil
  (should
   (equal
    (py-ast "assert 1//2 == 0")
    "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=FloorDiv(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "assert 1/2 == 0.5")
    "Module(body=[Assert(test=Compare(left=BinOp(left=Num(n=1), op=Div(), right=Num(n=2)), ops=[Eq()], comparators=[Num(n=0.5)]), msg=None)])\n")))
(ert-deftest pyel-binop-el-ast nil
  (should
   (string=
    (pyel "assert 1//2 == 0" t)
    "(assert  (compare  (bin-op  (num 1) // (num 2)) (\"==\") ((num 0))) nil)\n"))
  (should
   (string=
    (pyel "assert 1/2 == 0.5" t)
    "(assert  (compare  (bin-op  (num 1) / (num 2)) (\"==\") ((num 0.5))) nil)\n")))

(ert-deftest pyel-subscript-full-transform nil
  (should
   (equal
    (pyel "a = '1X23'\nassert a[1] == 'X'")
    '(progn
       (setq a "1X23")
       (assert
        (pyel-==
         (pyel-subscript-load-index a 1)
         "X")
        t nil))))
  (should
   (equal
    (pyel "a = [1,2,3,4]\nassert a[1] == 2")
    '(progn
       (setq a
             (list 1 2 3 4))
       (assert
        (pyel-==
         (pyel-subscript-load-index a 1)
         2)
        t nil))))
  (should
   (equal
    (pyel "a = (1,2,3,4)\nassert a[1] == 2")
    '(progn
       (setq a
             (vector 1 2 3 4))
       (assert
        (pyel-==
         (pyel-subscript-load-index a 1)
         2)
        t nil))))
  (should
   (equal
    (pyel "class a:\n def __getitem__ (self, value):\n  return value + 4\nx = a()\nassert x[1] == 5")
    '(progn
       (defclass a nil nil "pyel class")
       (defmethod --getitem--
         ((self a)
          value)
         (pyel-+ value 4))
       (defmethod --init--
         ((self a))
         "Default initializer")
       (setq x
             (let
                 ((__c
                   (a "obj")))
               (--init-- __c)
               __c))
       (assert
        (pyel-==
         (pyel-subscript-load-index x 1)
         5)
        t nil))))
  (should
   (equal
    (pyel "a = (1,2,3,4,5)\nassert a[1:4] == (2,3,4)\nassert a[:4] == (1,2,3,4)\nassert a[2:] == (3,4,5)\nassert a[:] == (1,2,3,4,5)")
    '(progn
       (setq a
             (vector 1 2 3 4 5))
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 1 4 nil)
         (vector 2 3 4))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 4 nil)
         (vector 1 2 3 4))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 2 nil nil)
         (vector 3 4 5))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 nil nil)
         (vector 1 2 3 4 5))
        t nil))))
  (should
   (equal
    (pyel "a = [1,2,3,4,5]\nassert a[1:4] == [2,3,4]\nassert a[:4] == [1,2,3,4]\nassert a[2:] == [3,4,5]\nassert a[:] == [1,2,3,4,5]")
    '(progn
       (setq a
             (list 1 2 3 4 5))
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 1 4 nil)
         (list 2 3 4))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 4 nil)
         (list 1 2 3 4))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 2 nil nil)
         (list 3 4 5))
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 nil nil)
         (list 1 2 3 4 5))
        t nil))))
  (should
   (equal
    (pyel "a = '012345678'\nassert a[1:4] == '123'\nassert a[:4] == '0123'\nassert a[2:] == '2345678'\nassert a[:] == '012345678'")
    '(progn
       (setq a "012345678")
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 1 4 nil)
         "123")
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 4 nil)
         "0123")
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 2 nil nil)
         "2345678")
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice a 0 nil nil)
         "012345678")
        t nil))))
  (should
   (equal
    (pyel "class a:\n def __getitem__ (self, value):\n  return value.start + value.end\nx = a()\nassert x[1:2] == 3\nassert x[5:7] == 12")
    '(progn
       (defclass a nil
         ((start :initarg :start :initform nil)
          (end :initarg :end :initform nil))
         "pyel class")
       (defmethod --getitem--
         ((self a)
          value)
         (pyel-+
          (oref value start)
          (oref value end)))
       (defmethod --init--
         ((self a))
         "Default initializer")
       (setq x
             (let
                 ((__c
                   (a "obj")))
               (--init-- __c)
               __c))
       (assert
        (pyel-==
         (pyel-subscript-load-slice x 1 2 nil)
         3)
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-slice x 5 7 nil)
         12)
        t nil))))
  (should
   (equal
    (pyel "def __add(a,b):\n return a+b\na = [1,2,3,4]\na[0] = __add(a[1],a[2])\nassert a[0] == 5\na[2] = 'str'\nassert a[2] == 'str'")
    '(progn
       (defun --add
         (a b)
         (pyel-+ a b))
       (setq a
             (list 1 2 3 4))
       (pyel-subscript-store-index a 0
                                   (--add
                                    (pyel-subscript-load-index a 1)
                                    (pyel-subscript-load-index a 2)))
       (assert
        (pyel-==
         (pyel-subscript-load-index a 0)
         5)
        t nil)
       (pyel-subscript-store-index a 2 "str")
       (assert
        (pyel-==
         (pyel-subscript-load-index a 2)
         "str")
        t nil))))
  (should
   (equal
    (pyel "a = (1,2,3,4)\na[0] = a[1] + a[2]\nassert aa[0] == 5\na[2] = 'str'\nassert a[2] == 'str'")
    '(progn
       (setq a
             (vector 1 2 3 4))
       (pyel-subscript-store-index a 0
                                   (pyel-+
                                    (pyel-subscript-load-index a 1)
                                    (pyel-subscript-load-index a 2)))
       (assert
        (pyel-==
         (pyel-subscript-load-index aa 0)
         5)
        t nil)
       (pyel-subscript-store-index a 2 "str")
       (assert
        (pyel-==
         (pyel-subscript-load-index a 2)
         "str")
        t nil))))
  (should
   (equal
    (pyel "class a:\n def __setitem__ (self, index, value):\n  self.index = index\n  self.value = value\nx = a()\nx[3] = 5\nassert x.index == 3\nassert x.value == 5")
    '(progn
       (defclass a nil
         ((value :initarg :value :initform nil)
          (index :initarg :index :initform nil))
         "pyel class")
       (defmethod --setitem--
         ((self a)
          index value)
         (oset self index index)
         (oset self value value))
       (defmethod --init--
         ((self a))
         "Default initializer")
       (setq x
             (let
                 ((__c
                   (a "obj")))
               (--init-- __c)
               __c))
       (pyel-subscript-store-index x 3 5)
       (assert
        (pyel-==
         (oref x index)
         3)
        t nil)
       (assert
        (pyel-==
         (oref x value)
         5)
        t nil))))
  (should
   (equal
    (pyel "a = [1,2,3,4,5,6]\na[1:4] = [5,4,'f']\nassert a == [1,5,4,'f',5,6]\na[:3] = ['a',4,2.2]\nassert a == ['a',4,2.2,'f',5,6]\na[3:] = [3,3]\nassert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]")
    '(progn
       (setq a
             (list 1 2 3 4 5 6))
       (pyel-subscript-store-slice a 1 4 nil
                                   (list 5 4 "f"))
       (assert
        (pyel-== a
                 (list 1 5 4 "f" 5 6))
        t nil)
       (pyel-subscript-store-slice a 0 3 nil
                                   (list "a" 4 2.2))
       (assert
        (pyel-== a
                 (list "a" 4 2.2 "f" 5 6))
        t nil)
       (pyel-subscript-store-slice a 3 nil nil
                                   (list 3 3))
       (assert
        (pyel-== a
                 (list "a" 4 2.2 3 3 6))
        t nil))))
  (should
   (equal
    (pyel "a = (1,2,3,4,5,6)\na[1:4] = (5,4,'f')\nassert a == (1,5,4,'f',5,6)\na[:3] = ('a',4,2.2)\nassert a == ('a',4,2.2,'f',5,6)\na[3:] = (3,3)\nassert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)")
    '(progn
       (setq a
             (vector 1 2 3 4 5 6))
       (pyel-subscript-store-slice a 1 4 nil
                                   (vector 5 4 "f"))
       (assert
        (pyel-== a
                 (vector 1 5 4 "f" 5 6))
        t nil)
       (pyel-subscript-store-slice a 0 3 nil
                                   (vector "a" 4 2.2))
       (assert
        (pyel-== a
                 (vector "a" 4 2.2 "f" 5 6))
        t nil)
       (pyel-subscript-store-slice a 3 nil nil
                                   (vector 3 3))
       (assert
        (pyel-== a
                 (vector "a" 4 2.2 3 3 6))
        t nil))))
  (should
   (equal
    (pyel "a = '123456'\na[1:4] = '54f'\nassert a == '154f56'\na[:3] = 'a42'\nassert a == 'a42f56'\na[3:] = '33'\nassert a == 'a42336'#TODO: should == 'a4233'")
    '(progn
       (setq a "123456")
       (pyel-subscript-store-slice a 1 4 nil "54f")
       (assert
        (pyel-== a "154f56")
        t nil)
       (pyel-subscript-store-slice a 0 3 nil "a42")
       (assert
        (pyel-== a "a42f56")
        t nil)
       (pyel-subscript-store-slice a 3 nil nil "33")
       (assert
        (pyel-== a "a42336")
        t nil))))
  (should
   (equal
    (pyel "class a:\n def __setitem__ (self, index, value):\n  self.start = index.start\n  self.end = index.end\n  self.step = index.step\n  self.value = value\nx = a()\nx[2:3] = [1,2,3]\nassert x.start == 2\nassert x.end == 3\nassert x.value == [1,2,3]")
    '(progn
       (defclass a nil
         ((value :initarg :value :initform nil)
          (start :initarg :start :initform nil)
          (end :initarg :end :initform nil)
          (step :initarg :step :initform nil))
         "pyel class")
       (defmethod --setitem--
         ((self a)
          index value)
         (oset self start
               (oref index start))
         (oset self end
               (oref index end))
         (oset self step
               (oref index step))
         (oset self value value))
       (defmethod --init--
         ((self a))
         "Default initializer")
       (setq x
             (let
                 ((__c
                   (a "obj")))
               (--init-- __c)
               __c))
       (pyel-subscript-store-slice x 2 3 nil
                                   (list 1 2 3))
       (assert
        (pyel-==
         (oref x start)
         2)
        t nil)
       (assert
        (pyel-==
         (oref x end)
         3)
        t nil)
       (assert
        (pyel-==
         (oref x value)
         (list 1 2 3))
        t nil)))))
(ert-deftest pyel-subscript-py-ast nil
  (should
   (equal
    (py-ast "a = '1X23'\nassert a[1] == 'X'")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='1X23')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='X')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = [1,2,3,4]\nassert a[1] == 2")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = (1,2,3,4)\nassert a[1] == 2")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "class a:\n def __getitem__ (self, value):\n  return value + 4\nx = a()\nassert x[1] == 5")
    "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='value', ctx=Load()), op=Add(), right=Num(n=4)))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = (1,2,3,4,5)\nassert a[1:4] == (2,3,4)\nassert a[:4] == (1,2,3,4)\nassert a[2:] == (3,4,5)\nassert a[:] == (1,2,3,4,5)")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = [1,2,3,4,5]\nassert a[1:4] == [2,3,4]\nassert a[:4] == [1,2,3,4]\nassert a[2:] == [3,4,5]\nassert a[:] == [1,2,3,4,5]")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5)], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = '012345678'\nassert a[1:4] == '123'\nassert a[:4] == '0123'\nassert a[2:] == '2345678'\nassert a[:] == '012345678'")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='012345678')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=4), step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='0123')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=2), upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='2345678')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=None, step=None), ctx=Load()), ops=[Eq()], comparators=[Str(s='012345678')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "class a:\n def __getitem__ (self, value):\n  return value.start + value.end\nx = a()\nassert x[1:2] == 3\nassert x[5:7] == 12")
    "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__getitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Attribute(value=Name(id='value', ctx=Load()), attr='start', ctx=Load()), op=Add(), right=Attribute(value=Name(id='value', ctx=Load()), attr='end', ctx=Load())))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=2), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=5), upper=Num(n=7), step=None), ctx=Load()), ops=[Eq()], comparators=[Num(n=12)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "def __add(a,b):\n return a+b\na = [1,2,3,4]\na[0] = __add(a[1],a[2])\nassert a[0] == 5\na[2] = 'str'\nassert a[2] == 'str'")
    "Module(body=[FunctionDef(name='__add', args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load())))], decorator_list=[], returns=None), Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=Call(func=Name(id='__add', ctx=Load()), args=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = (1,2,3,4)\na[0] = a[1] + a[2]\nassert aa[0] == 5\na[2] = 'str'\nassert a[2] == 'str'")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Store())], value=BinOp(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), op=Add(), right=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()))), Assert(test=Compare(left=Subscript(value=Name(id='aa', ctx=Load()), slice=Index(value=Num(n=0)), ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "class a:\n def __setitem__ (self, index, value):\n  self.index = index\n  self.value = value\nx = a()\nx[3] = 5\nassert x.index == 3\nassert x.value == 5")
    "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__setitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='index', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='index', ctx=Store())], value=Name(id='index', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='value', ctx=Store())], value=Name(id='value', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Store())], value=Num(n=5)), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='index', ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='value', ctx=Load()), ops=[Eq()], comparators=[Num(n=5)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = [1,2,3,4,5,6]\na[1:4] = [5,4,'f']\nassert a == [1,5,4,'f',5,6]\na[:3] = ['a',4,2.2]\nassert a == ['a',4,2.2,'f',5,6]\na[3:] = [3,3]\nassert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=List(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=List(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=List(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = (1,2,3,4,5,6)\na[1:4] = (5,4,'f')\nassert a == (1,5,4,'f',5,6)\na[:3] = ('a',4,2.2)\nassert a == ('a',4,2.2,'f',5,6)\na[3:] = (3,3)\nassert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4), Num(n=5), Num(n=6)], ctx=Load())), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Tuple(elts=[Num(n=5), Num(n=4), Str(s='f')], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Num(n=1), Num(n=5), Num(n=4), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Str(s='f'), Num(n=5), Num(n=6)], ctx=Load())]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Tuple(elts=[Num(n=3), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Tuple(elts=[Str(s='a'), Num(n=4), Num(n=2.2), Num(n=3), Num(n=3), Num(n=6)], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = '123456'\na[1:4] = '54f'\nassert a == '154f56'\na[:3] = 'a42'\nassert a == 'a42f56'\na[3:] = '33'\nassert a == 'a42336'#TODO: should == 'a4233'")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='123456')), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store())], value=Str(s='54f')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='154f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=None, upper=Num(n=3), step=None), ctx=Store())], value=Str(s='a42')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42f56')]), msg=None), Assign(targets=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=3), upper=None, step=None), ctx=Store())], value=Str(s='33')), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Str(s='a42336')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "class a:\n def __setitem__ (self, index, value):\n  self.start = index.start\n  self.end = index.end\n  self.step = index.step\n  self.value = value\nx = a()\nx[2:3] = [1,2,3]\nassert x.start == 2\nassert x.end == 3\nassert x.value == [1,2,3]")
    "Module(body=[ClassDef(name='a', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__setitem__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='index', annotation=None), arg(arg='value', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='start', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='start', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='end', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='end', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='step', ctx=Store())], value=Attribute(value=Name(id='index', ctx=Load()), attr='step', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='value', ctx=Store())], value=Name(id='value', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Subscript(value=Name(id='x', ctx=Load()), slice=Slice(lower=Num(n=2), upper=Num(n=3), step=None), ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='start', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='end', ctx=Load()), ops=[Eq()], comparators=[Num(n=3)]), msg=None), Assert(test=Compare(left=Attribute(value=Name(id='x', ctx=Load()), attr='value', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())]), msg=None)])\n")))
(ert-deftest pyel-subscript-el-ast nil
  (should
   (string=
    (pyel "a = '1X23'\nassert a[1] == 'X'" t)
    "(assign  ((name  \"a\" 'store)) (str \"1X23\"))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((str \"X\"))) nil)\n"))
  (should
   (string=
    (pyel "a = [1,2,3,4]\nassert a[1] == 2" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((num 2))) nil)\n"))
  (should
   (string=
    (pyel "a = (1,2,3,4)\nassert a[1] == 2" t)
    "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 1)) 'load) (\"==\") ((num 2))) nil)\n"))
  (should
   (string=
    (pyel "class a:\n def __getitem__ (self, value):\n  return value + 4\nx = a()\nassert x[1] == 5" t)
    "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"value\" 'load) + (num 4)))) nil nil )) nil)\n(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))\n(assert  (compare  (subscript (name  \"x\" 'load) (index (num 1)) 'load) (\"==\") ((num 5))) nil)\n"))
  (should
   (string=
    (pyel "a = (1,2,3,4,5)\nassert a[1:4] == (2,3,4)\nassert a[:4] == (1,2,3,4)\nassert a[2:] == (3,4,5)\nassert a[:] == (1,2,3,4,5)" t)
    "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((tuple  ((num 2) (num 3) (num 4)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((tuple  ((num 3) (num 4) (num 5)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((tuple  ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "a = [1,2,3,4,5]\nassert a[1:4] == [2,3,4]\nassert a[:4] == [1,2,3,4]\nassert a[2:] == [3,4,5]\nassert a[:] == [1,2,3,4,5]" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((list ((num 2) (num 3) (num 4)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((list ((num 1) (num 2) (num 3) (num 4)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((list ((num 3) (num 4) (num 5)) 'load))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "a = '012345678'\nassert a[1:4] == '123'\nassert a[:4] == '0123'\nassert a[2:] == '2345678'\nassert a[:] == '012345678'" t)
    "(assign  ((name  \"a\" 'store)) (str \"012345678\"))\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'load) (\"==\") ((str \"123\"))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 (num 4) nil) 'load) (\"==\") ((str \"0123\"))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice (num 2) nil nil) 'load) (\"==\") ((str \"2345678\"))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (slice 0 nil nil) 'load) (\"==\") ((str \"012345678\"))) nil)\n"))
  (should
   (string=
    (pyel "class a:\n def __getitem__ (self, value):\n  return value.start + value.end\nx = a()\nassert x[1:2] == 3\nassert x[5:7] == 12" t)
    "(classdef a nil nil nil nil ((def \" __getitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (attribute  (name  \"value\" 'load) \"start\" 'load) + (attribute  (name  \"value\" 'load) \"end\" 'load)))) nil nil )) nil)\n(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))\n(assert  (compare  (subscript (name  \"x\" 'load) (slice (num 1) (num 2) nil) 'load) (\"==\") ((num 3))) nil)\n(assert  (compare  (subscript (name  \"x\" 'load) (slice (num 5) (num 7) nil) 'load) (\"==\") ((num 12))) nil)\n"))
  (should
   (string=
    (pyel "def __add(a,b):\n return a+b\na = [1,2,3,4]\na[0] = __add(a[1],a[2])\nassert a[0] == 5\na[2] = 'str'\nassert a[2] == 'str'" t)
    "(def \" __add \" ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((return (bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) nil nil )\n(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))\n(assign  ((subscript (name  \"a\" 'load) (index (num 0)) 'store)) (call  (name  \"__add\" 'load) ((subscript (name  \"a\" 'load) (index (num 1)) 'load) (subscript (name  \"a\" 'load) (index (num 2)) 'load)) nil nil nil))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 0)) 'load) (\"==\") ((num 5))) nil)\n(assign  ((subscript (name  \"a\" 'load) (index (num 2)) 'store)) (str \"str\"))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 2)) 'load) (\"==\") ((str \"str\"))) nil)\n"))
  (should
   (string=
    (pyel "a = (1,2,3,4)\na[0] = a[1] + a[2]\nassert aa[0] == 5\na[2] = 'str'\nassert a[2] == 'str'" t)
    "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4)) 'load))\n(assign  ((subscript (name  \"a\" 'load) (index (num 0)) 'store)) (bin-op  (subscript (name  \"a\" 'load) (index (num 1)) 'load) + (subscript (name  \"a\" 'load) (index (num 2)) 'load)))\n(assert  (compare  (subscript (name  \"aa\" 'load) (index (num 0)) 'load) (\"==\") ((num 5))) nil)\n(assign  ((subscript (name  \"a\" 'load) (index (num 2)) 'store)) (str \"str\"))\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 2)) 'load) (\"==\") ((str \"str\"))) nil)\n"))
  (should
   (string=
    (pyel "class a:\n def __setitem__ (self, index, value):\n  self.index = index\n  self.value = value\nx = a()\nx[3] = 5\nassert x.index == 3\nassert x.value == 5" t)
    "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load) \"index\" 'store)) (name  \"index\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"value\" 'store)) (name  \"value\" 'load))) nil nil )) nil)\n(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))\n(assign  ((subscript (name  \"x\" 'load) (index (num 3)) 'store)) (num 5))\n(assert  (compare  (attribute  (name  \"x\" 'load) \"index\" 'load) (\"==\") ((num 3))) nil)\n(assert  (compare  (attribute  (name  \"x\" 'load) \"value\" 'load) (\"==\") ((num 5))) nil)\n"))
  (should
   (string=
    (pyel "a = [1,2,3,4,5,6]\na[1:4] = [5,4,'f']\nassert a == [1,5,4,'f',5,6]\na[:3] = ['a',4,2.2]\nassert a == ['a',4,2.2,'f',5,6]\na[3:] = [3,3]\nassert a == ['a', 4, 2.2, 3, 3, 6]#TODO: should == ['a', 4, 2.2, 3, 3]" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (num 4) (num 5) (num 6)) 'load))\n(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (list ((num 5) (num 4) (str \"f\")) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((num 1) (num 5) (num 4) (str \"f\") (num 5) (num 6)) 'load))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (list ((str \"a\") (num 4) (num 2.2)) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((str \"a\") (num 4) (num 2.2) (str \"f\") (num 5) (num 6)) 'load))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (list ((num 3) (num 3)) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((list ((str \"a\") (num 4) (num 2.2) (num 3) (num 3) (num 6)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "a = (1,2,3,4,5,6)\na[1:4] = (5,4,'f')\nassert a == (1,5,4,'f',5,6)\na[:3] = ('a',4,2.2)\nassert a == ('a',4,2.2,'f',5,6)\na[3:] = (3,3)\nassert a == ('a', 4, 2.2, 3, 3, 6)#TODO: should == ('a', 4, 2.2, 3, 3)" t)
    "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2) (num 3) (num 4) (num 5) (num 6)) 'load))\n(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (tuple  ((num 5) (num 4) (str \"f\")) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((num 1) (num 5) (num 4) (str \"f\") (num 5) (num 6)) 'load))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (tuple  ((str \"a\") (num 4) (num 2.2)) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((str \"a\") (num 4) (num 2.2) (str \"f\") (num 5) (num 6)) 'load))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (tuple  ((num 3) (num 3)) 'load))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((tuple  ((str \"a\") (num 4) (num 2.2) (num 3) (num 3) (num 6)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "a = '123456'\na[1:4] = '54f'\nassert a == '154f56'\na[:3] = 'a42'\nassert a == 'a42f56'\na[3:] = '33'\nassert a == 'a42336'#TODO: should == 'a4233'" t)
    "(assign  ((name  \"a\" 'store)) (str \"123456\"))\n(assign  ((subscript (name  \"a\" 'load) (slice (num 1) (num 4) nil) 'store)) (str \"54f\"))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"154f56\"))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice 0 (num 3) nil) 'store)) (str \"a42\"))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"a42f56\"))) nil)\n(assign  ((subscript (name  \"a\" 'load) (slice (num 3) nil nil) 'store)) (str \"33\"))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((str \"a42336\"))) nil)\n"))
  (should
   (string=
    (pyel "class a:\n def __setitem__ (self, index, value):\n  self.start = index.start\n  self.end = index.end\n  self.step = index.step\n  self.value = value\nx = a()\nx[2:3] = [1,2,3]\nassert x.start == 2\nassert x.end == 3\nassert x.value == [1,2,3]" t)
    "(classdef a nil nil nil nil ((def \" __setitem__ \" ((arguments  ((arg \"self\"  nil) (arg \"index\"  nil) (arg \"value\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load) \"start\" 'store)) (attribute  (name  \"index\" 'load) \"start\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"end\" 'store)) (attribute  (name  \"index\" 'load) \"end\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"step\" 'store)) (attribute  (name  \"index\" 'load) \"step\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"value\" 'store)) (name  \"value\" 'load))) nil nil )) nil)\n(assign  ((name  \"x\" 'store)) (call  (name  \"a\" 'load) nil nil nil nil))\n(assign  ((subscript (name  \"x\" 'load) (slice (num 2) (num 3) nil) 'store)) (list ((num 1) (num 2) (num 3)) 'load))\n(assert  (compare  (attribute  (name  \"x\" 'load) \"start\" 'load) (\"==\") ((num 2))) nil)\n(assert  (compare  (attribute  (name  \"x\" 'load) \"end\" 'load) (\"==\") ((num 3))) nil)\n(assert  (compare  (attribute  (name  \"x\" 'load) \"value\" 'load) (\"==\") ((list ((num 1) (num 2) (num 3)) 'load))) nil)\n")))

(ert-deftest pyel-class-full-transform nil
  (should
   (equal
    (pyel "class test:\n def __init__(self,aa,bb):\n  self.a = aa\n  self.b = bb\n def geta(self):\n  return self.a\n def getb(self):\n  return self.b\nx = test(5,6)\nassert x.geta() == 5\nassert x.getb() == 6\nx.b = 2\nassert x.getb() == 2")
    '(progn
       (defclass test nil
         ((b :initarg :b :initform nil)
          (a :initarg :a :initform nil))
         "pyel class")
       (defmethod --init--
         ((self test)
          aa bb)
         (oset self a aa)
         (oset self b bb))
       (defmethod geta
         ((self test))
         (oref self a))
       (defmethod getb
         ((self test))
         (oref self b))
       (setq x
             (let
                 ((__c
                   (test "obj")))
               (--init-- __c 5 6)
               __c))
       (assert
        (pyel-==
         (geta x)
         5)
        t nil)
       (assert
        (pyel-==
         (getb x)
         6)
        t nil)
       (oset x b 2)
       (assert
        (pyel-==
         (getb x)
         2)
        t nil)))))
(ert-deftest pyel-class-py-ast nil
  (should
   (equal
    (py-ast "class test:\n def __init__(self,aa,bb):\n  self.a = aa\n  self.b = bb\n def geta(self):\n  return self.a\n def getb(self):\n  return self.b\nx = test(5,6)\nassert x.geta() == 5\nassert x.getb() == 6\nx.b = 2\nassert x.getb() == 2")
    "Module(body=[ClassDef(name='test', bases=[], keywords=[], starargs=None, kwargs=None, body=[FunctionDef(name='__init__', args=arguments(args=[arg(arg='self', annotation=None), arg(arg='aa', annotation=None), arg(arg='bb', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='a', ctx=Store())], value=Name(id='aa', ctx=Load())), Assign(targets=[Attribute(value=Name(id='self', ctx=Load()), attr='b', ctx=Store())], value=Name(id='bb', ctx=Load()))], decorator_list=[], returns=None), FunctionDef(name='geta', args=arguments(args=[arg(arg='self', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=Attribute(value=Name(id='self', ctx=Load()), attr='a', ctx=Load()))], decorator_list=[], returns=None), FunctionDef(name='getb', args=arguments(args=[arg(arg='self', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Return(value=Attribute(value=Name(id='self', ctx=Load()), attr='b', ctx=Load()))], decorator_list=[], returns=None)], decorator_list=[]), Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='test', ctx=Load()), args=[Num(n=5), Num(n=6)], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='geta', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=5)]), msg=None), Assert(test=Compare(left=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='getb', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=6)]), msg=None), Assign(targets=[Attribute(value=Name(id='x', ctx=Load()), attr='b', ctx=Store())], value=Num(n=2)), Assert(test=Compare(left=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='getb', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])\n")))
(ert-deftest pyel-class-el-ast nil
  (should
   (string=
    (pyel "class test:\n def __init__(self,aa,bb):\n  self.a = aa\n  self.b = bb\n def geta(self):\n  return self.a\n def getb(self):\n  return self.b\nx = test(5,6)\nassert x.geta() == 5\nassert x.getb() == 6\nx.b = 2\nassert x.getb() == 2" t)
    "(classdef test nil nil nil nil ((def \" __init__ \" ((arguments  ((arg \"self\"  nil) (arg \"aa\"  nil) (arg \"bb\"  nil)) nil nil nil nil nil nil nil )) ((assign  ((attribute  (name  \"self\" 'load) \"a\" 'store)) (name  \"aa\" 'load)) (assign  ((attribute  (name  \"self\" 'load) \"b\" 'store)) (name  \"bb\" 'load))) nil nil ) (def \" geta \" ((arguments  ((arg \"self\"  nil)) nil nil nil nil nil nil nil )) ((return (attribute  (name  \"self\" 'load) \"a\" 'load))) nil nil ) (def \" getb \" ((arguments  ((arg \"self\"  nil)) nil nil nil nil nil nil nil )) ((return (attribute  (name  \"self\" 'load) \"b\" 'load))) nil nil )) nil)\n(assign  ((name  \"x\" 'store)) (call  (name  \"test\" 'load) ((num 5) (num 6)) nil nil nil))\n(assert  (compare  (call  (attribute  (name  \"x\" 'load) \"geta\" 'load) nil nil nil nil) (\"==\") ((num 5))) nil)\n(assert  (compare  (call  (attribute  (name  \"x\" 'load) \"getb\" 'load) nil nil nil nil) (\"==\") ((num 6))) nil)\n(assign  ((attribute  (name  \"x\" 'load) \"b\" 'store)) (num 2))\n(assert  (compare  (call  (attribute  (name  \"x\" 'load) \"getb\" 'load) nil nil nil nil) (\"==\") ((num 2))) nil)\n")))

(ert-deftest pyel-assert-full-transform nil
  (should
   (equal
    (pyel "assert sldk()")
    '(assert
      (sldk)
      t nil)))
  (should
   (equal
    (pyel "assert adk,'messsage'")
    '(assert adk t "messsage"))))
(ert-deftest pyel-assert-py-ast nil
  (should
   (equal
    (py-ast "assert sldk()")
    "Module(body=[Assert(test=Call(func=Name(id='sldk', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), msg=None)])\n"))
  (should
   (equal
    (py-ast "assert adk,'messsage'")
    "Module(body=[Assert(test=Name(id='adk', ctx=Load()), msg=Str(s='messsage'))])\n")))
(ert-deftest pyel-assert-el-ast nil
  (should
   (string=
    (pyel "assert sldk()" t)
    "(assert  (call  (name  \"sldk\" 'load) nil nil nil nil) nil)\n"))
  (should
   (string=
    (pyel "assert adk,'messsage'" t)
    "(assert  (name  \"adk\" 'load) (str \"messsage\"))\n")))

(ert-deftest pyel-append-full-transform nil
  (should
   (equal
    (pyel "a=[1,2,3]\na.append('str')\nassert len(a) == 4\nassert a[3] == 'str'")
    '(progn
       (setq a
             (list 1 2 3))
       (pyel-append-method a "str")
       (assert
        (pyel-==
         (pyel-len-function a)
         4)
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-index a 3)
         "str")
        t nil)))))
(ert-deftest pyel-append-py-ast nil
  (should
   (equal
    (py-ast "a=[1,2,3]\na.append('str')\nassert len(a) == 4\nassert a[3] == 'str'")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load())), Expr(value=Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='append', ctx=Load()), args=[Str(s='str')], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=4)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=3)), ctx=Load()), ops=[Eq()], comparators=[Str(s='str')]), msg=None)])\n")))
(ert-deftest pyel-append-el-ast nil
  (should
   (string=
    (pyel "a=[1,2,3]\na.append('str')\nassert len(a) == 4\nassert a[3] == 'str'" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3)) 'load))\n(call  (attribute  (name  \"a\" 'load) \"append\" 'load) ((str \"str\")) nil nil nil)\n(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 4))) nil)\n(assert  (compare  (subscript (name  \"a\" 'load) (index (num 3)) 'load) (\"==\") ((str \"str\"))) nil)\n")))

(ert-deftest pyel-len-full-transform nil
  (should
   (equal
    (pyel "a = [1,2,3,'5']\nassert len(a) == 4")
    '(progn
       (setq a
             (list 1 2 3 "5"))
       (assert
        (pyel-==
         (pyel-len-function a)
         4)
        t nil))))
  (should
   (equal
    (pyel "a = []\nassert len(a) == 0")
    '(progn
       (setq a
             (list))
       (assert
        (pyel-==
         (pyel-len-function a)
         0)
        t nil))))
  (should
   (equal
    (pyel "a = 'str'\nassert len(a) == 3")
    '(progn
       (setq a "str")
       (assert
        (pyel-==
         (pyel-len-function a)
         3)
        t nil))))
  (should
   (equal
    (pyel "a = (1,2)\nassert len(a) == 2")
    '(progn
       (setq a
             (vector 1 2))
       (assert
        (pyel-==
         (pyel-len-function a)
         2)
        t nil))))
  (should
   (equal
    (pyel "assert len('')==0")
    '(assert
      (pyel-==
       (pyel-len-function "")
       0)
      t nil))))
(ert-deftest pyel-len-py-ast nil
  (should
   (equal
    (py-ast "a = [1,2,3,'5']\nassert len(a) == 4")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Str(s='5')], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=4)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = []\nassert len(a) == 0")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=List(elts=[], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = 'str'\nassert len(a) == 3")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Str(s='str')), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=3)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "a = (1,2)\nassert len(a) == 2")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Tuple(elts=[Num(n=1), Num(n=2)], ctx=Load())), Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Name(id='a', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=2)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "assert len('')==0")
    "Module(body=[Assert(test=Compare(left=Call(func=Name(id='len', ctx=Load()), args=[Str(s='')], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=0)]), msg=None)])\n")))
(ert-deftest pyel-len-el-ast nil
  (should
   (string=
    (pyel "a = [1,2,3,'5']\nassert len(a) == 4" t)
    "(assign  ((name  \"a\" 'store)) (list ((num 1) (num 2) (num 3) (str \"5\")) 'load))\n(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 4))) nil)\n"))
  (should
   (string=
    (pyel "a = []\nassert len(a) == 0" t)
    "(assign  ((name  \"a\" 'store)) (list nil 'load))\n(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 0))) nil)\n"))
  (should
   (string=
    (pyel "a = 'str'\nassert len(a) == 3" t)
    "(assign  ((name  \"a\" 'store)) (str \"str\"))\n(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 3))) nil)\n"))
  (should
   (string=
    (pyel "a = (1,2)\nassert len(a) == 2" t)
    "(assign  ((name  \"a\" 'store)) (tuple  ((num 1) (num 2)) 'load))\n(assert  (compare  (call  (name  \"len\" 'load) ((name  \"a\" 'load)) nil nil nil) (\"==\") ((num 2))) nil)\n"))
  (should
   (string=
    (pyel "assert len('')==0" t)
    "(assert  (compare  (call  (name  \"len\" 'load) ((str \"\")) nil nil nil) (\"==\") ((num 0))) nil)\n")))

;;

;;

;;

;;

;;

;;

;;

;;

(ert-deftest pyel-cond-full-transform nil
  (should
   (equal
    (pyel "x = cond([1 > 2, 'first']\n   [2 == 2, 'second']\n   [5 == 7, 'third']\n   [True, error('wtf')])\nassert x == 'second'")
    '(progn
       (setq x
             (cond
              ((pyel-> 1 2)
               "first")
              ((pyel-== 2 2)
               "second")
              ((pyel-== 5 7)
               "third")
              (t
               (error "wtf"))))
       (assert
        (pyel-== x "second")
        t nil)))))
(ert-deftest pyel-cond-py-ast nil
  (should
   (equal
    (py-ast "x = cond([1 > 2, 'first']\n   [2 == 2, 'second']\n   [5 == 7, 'third']\n   [True, error('wtf')])\nassert x == 'second'")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='cond', ctx=Load()), args=[Subscript(value=Subscript(value=Subscript(value=List(elts=[Compare(left=Num(n=1), ops=[Gt()], comparators=[Num(n=2)]), Str(s='first')], ctx=Load()), slice=Index(value=Tuple(elts=[Compare(left=Num(n=2), ops=[Eq()], comparators=[Num(n=2)]), Str(s='second')], ctx=Load())), ctx=Load()), slice=Index(value=Tuple(elts=[Compare(left=Num(n=5), ops=[Eq()], comparators=[Num(n=7)]), Str(s='third')], ctx=Load())), ctx=Load()), slice=Index(value=Tuple(elts=[Name(id='True', ctx=Load()), Call(func=Name(id='error', ctx=Load()), args=[Str(s='wtf')], keywords=[], starargs=None, kwargs=None)], ctx=Load())), ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Str(s='second')]), msg=None)])\n")))
(ert-deftest pyel-cond-el-ast nil
  (should
   (string=
    (pyel "x = cond([1 > 2, 'first']\n   [2 == 2, 'second']\n   [5 == 7, 'third']\n   [True, error('wtf')])\nassert x == 'second'" t)
    "(assign  ((name  \"x\" 'store)) (name  \"__pyel_marker_1__\" 'load))\n(assert  (compare  (name  \"x\" 'load) (\"==\") ((str \"second\"))) nil)\n")))

(ert-deftest pyel-lambda-full-transform nil
  (should
   (equal
    (pyel "x = [2,3,4]\nsquare = lambda([x]\n x*x)\ny = mapcar(square,x)\nassert y == [4,9,16]\n")
    '(progn
       (setq x
             (list 2 3 4))
       (setq square
             (lambda
               (x)
               (pyel-* x x)))
       (setq y
             (mapcar square x))
       (assert
        (pyel-== y
                 (list 4 9 16))
        t nil))))
  (should
   (equal
    (pyel "f = lambda([x,y]\nif x > y:\n 'x'\nelse:\n 'y')\nx=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])\nassert x == ['y', 'y', 'x', 'y', 'x']")
    '(progn
       (setq f
             (lambda
               (x y)
               (if
                   (pyel-> x y)
                   (progn "x")
                 "y")))
       (setq x
             (cl_mapcar f
                        (list 1 2 3 4 5)
                        (list 4 2 1 6 3)))
       (assert
        (pyel-== x
                 (list "y" "y" "x" "y" "x"))
        t nil)))))
(ert-deftest pyel-lambda-py-ast nil
  (should
   (equal
    (py-ast "x = [2,3,4]\nsquare = lambda([x]\n x*x)\ny = mapcar(square,x)\nassert y == [4,9,16]\n")
    "Traceback (most recent call last):\n  File \"/tmp/py2el.py\", line 7, in <module>\n    \"\"\")))\n  File \"/usr/lib/python3.2/ast.py\", line 36, in parse\n    return compile(source, filename, mode, PyCF_ONLY_AST)\n  File \"<unknown>\", line 2\n    square = lambda([x]\n                   ^\nSyntaxError: invalid syntax\n"))
  (should
   (equal
    (py-ast "f = lambda([x,y]\nif x > y:\n 'x'\nelse:\n 'y')\nx=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])\nassert x == ['y', 'y', 'x', 'y', 'x']")
    "Traceback (most recent call last):\n  File \"/tmp/py2el.py\", line 8, in <module>\n    assert x == ['y', 'y', 'x', 'y', 'x']\"\"\")))\n  File \"/usr/lib/python3.2/ast.py\", line 36, in parse\n    return compile(source, filename, mode, PyCF_ONLY_AST)\n  File \"<unknown>\", line 1\n    f = lambda([x,y]\n              ^\nSyntaxError: invalid syntax\n")))
(ert-deftest pyel-lambda-el-ast nil
  (should
   (string=
    (pyel "x = [2,3,4]\nsquare = lambda([x]\n x*x)\ny = mapcar(square,x)\nassert y == [4,9,16]\n" t)
    "(assign  ((name  \"x\" 'store)) (list ((num 2) (num 3) (num 4)) 'load))\n(assign  ((name  \"square\" 'store)) (name  \"__pyel_marker_81__\" 'load))\n(assign  ((name  \"y\" 'store)) (call  (name  \"mapcar\" 'load) ((name  \"square\" 'load) (name  \"x\" 'load)) nil nil nil))\n(assert  (compare  (name  \"y\" 'load) (\"==\") ((list ((num 4) (num 9) (num 16)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "f = lambda([x,y]\nif x > y:\n 'x'\nelse:\n 'y')\nx=cl_mapcar(f, [1, 2, 3, 4, 5], [4, 2, 1, 6, 3])\nassert x == ['y', 'y', 'x', 'y', 'x']" t)
    "(assign  ((name  \"f\" 'store)) (name  \"__pyel_marker_79__\" 'load))\n(assign  ((name  \"x\" 'store)) (call  (name  \"cl_mapcar\" 'load) ((name  \"f\" 'load) (list ((num 1) (num 2) (num 3) (num 4) (num 5)) 'load) (list ((num 4) (num 2) (num 1) (num 6) (num 3)) 'load)) nil nil nil))\n(assert  (compare  (name  \"x\" 'load) (\"==\") ((list ((str \"y\") (str \"y\") (str \"x\") (str \"y\") (str \"x\")) 'load))) nil)\n")))

;;

(ert-deftest pyel-for-loop-full-transform nil
  (should
   (equal
    (pyel "b = [1,2,3,4]\nc = 0\nfor a in b:\n c = c + a\nassert c==10")
    '(progn
       (setq b
             (list 1 2 3 4))
       (setq c 0)
       (loop for a in b do
             (setq c
                   (pyel-+ c a)))
       (assert
        (pyel-== c 10)
        t nil))))
  (should
   (equal
    (pyel "for i in range(n):\n break")
    '(catch '__break__
       (loop for i in
             (py-range n)
             do
             (throw '__break__ nil)))))
  (should
   (equal
    (pyel "for i in range(n):\n continue")
    '(loop for i in
           (py-range n)
           do
           (catch '__continue__
             (throw '__continue__ nil)))))
  (should
   (equal
    (pyel "x = []\nfor i in range(5):\n if i == 2:\n  continue\n x.append(i)\nassert x == [0,1,3,4]")
    '(progn
       (setq x
             (list))
       (loop for i in
             (py-range 5)
             do
             (catch '__continue__
               (if
                   (pyel-== i 2)
                   (progn
                     (throw '__continue__ nil)))
               (pyel-append-method x i)))
       (assert
        (pyel-== x
                 (list 0 1 3 4))
        t nil)))))
(ert-deftest pyel-for-loop-py-ast nil
  (should
   (equal
    (py-ast "b = [1,2,3,4]\nc = 0\nfor a in b:\n c = c + a\nassert c==10")
    "Module(body=[Assign(targets=[Name(id='b', ctx=Store())], value=List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load())), Assign(targets=[Name(id='c', ctx=Store())], value=Num(n=0)), For(target=Name(id='a', ctx=Store()), iter=Name(id='b', ctx=Load()), body=[Assign(targets=[Name(id='c', ctx=Store())], value=BinOp(left=Name(id='c', ctx=Load()), op=Add(), right=Name(id='a', ctx=Load())))], orelse=[]), Assert(test=Compare(left=Name(id='c', ctx=Load()), ops=[Eq()], comparators=[Num(n=10)]), msg=None)])\n"))
  (should
   (equal
    (py-ast "for i in range(n):\n break")
    "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Break()], orelse=[])])\n"))
  (should
   (equal
    (py-ast "for i in range(n):\n continue")
    "Module(body=[For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='n', ctx=Load())], keywords=[], starargs=None, kwargs=None), body=[Continue()], orelse=[])])\n"))
  (should
   (equal
    (py-ast "x = []\nfor i in range(5):\n if i == 2:\n  continue\n x.append(i)\nassert x == [0,1,3,4]")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=5)], keywords=[], starargs=None, kwargs=None), body=[If(test=Compare(left=Name(id='i', ctx=Load()), ops=[Eq()], comparators=[Num(n=2)]), body=[Continue()], orelse=[]), Expr(value=Call(func=Attribute(value=Name(id='x', ctx=Load()), attr='append', ctx=Load()), args=[Name(id='i', ctx=Load())], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[Num(n=0), Num(n=1), Num(n=3), Num(n=4)], ctx=Load())]), msg=None)])\n")))
(ert-deftest pyel-for-loop-el-ast nil
  (should
   (string=
    (pyel "b = [1,2,3,4]\nc = 0\nfor a in b:\n c = c + a\nassert c==10" t)
    "(assign  ((name  \"b\" 'store)) (list ((num 1) (num 2) (num 3) (num 4)) 'load))\n(assign  ((name  \"c\" 'store)) (num 0))\n(for  (name  \"a\" 'store) (name  \"b\" 'load) ((assign  ((name  \"c\" 'store)) (bin-op  (name  \"c\" 'load) + (name  \"a\" 'load)))) nil)\n(assert  (compare  (name  \"c\" 'load) (\"==\") ((num 10))) nil)\n"))
  (should
   (string=
    (pyel "for i in range(n):\n break" t)
    "(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((name  \"n\" 'load)) nil nil nil) ((break)) nil)\n"))
  (should
   (string=
    (pyel "for i in range(n):\n continue" t)
    "(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((name  \"n\" 'load)) nil nil nil) ((continue)) nil)\n"))
  (should
   (string=
    (pyel "x = []\nfor i in range(5):\n if i == 2:\n  continue\n x.append(i)\nassert x == [0,1,3,4]" t)
    "(assign  ((name  \"x\" 'store)) (list nil 'load))\n(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 5)) nil nil nil) ((if  (compare  (name  \"i\" 'load) (\"==\") ((num 2))) ((continue)) nil) (call  (attribute  (name  \"x\" 'load) \"append\" 'load) ((name  \"i\" 'load)) nil nil nil)) nil)\n(assert  (compare  (name  \"x\" 'load) (\"==\") ((list ((num 0) (num 1) (num 3) (num 4)) 'load))) nil)\n")))

(ert-deftest pyel-global-full-transform nil
  (should
   (equal
    (pyel "def a():\n global x\n x = 3\n y = 1")
    '(defun a nil
       (let
           (y)
         (setq x 3)
         (setq y 1)))))
  (should
   (equal
    (pyel "x = 1\ny = 1\ndef func():\n global x\n x = 7\n y = 7\nfunc()\nassert x == 7\nassert y == 1\n")
    '(progn
       (setq x 1)
       (setq y 1)
       (defun func nil
         (let
             (y)
           (setq x 7)
           (setq y 7)))
       (func)
       (assert
        (pyel-== x 7)
        t nil)
       (assert
        (pyel-== y 1)
        t nil)))))
(ert-deftest pyel-global-py-ast nil
  (should
   (equal
    (py-ast "def a():\n global x\n x = 3\n y = 1")
    "Module(body=[FunctionDef(name='a', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=3)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1))], decorator_list=[], returns=None)])\n"))
  (should
   (equal
    (py-ast "x = 1\ny = 1\ndef func():\n global x\n x = 7\n y = 7\nfunc()\nassert x == 7\nassert y == 1\n")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=1)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=1)), FunctionDef(name='func', args=arguments(args=[], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=[Global(names=['x']), Assign(targets=[Name(id='x', ctx=Store())], value=Num(n=7)), Assign(targets=[Name(id='y', ctx=Store())], value=Num(n=7))], decorator_list=[], returns=None), Expr(value=Call(func=Name(id='func', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Num(n=7)]), msg=None), Assert(test=Compare(left=Name(id='y', ctx=Load()), ops=[Eq()], comparators=[Num(n=1)]), msg=None)])\n")))
(ert-deftest pyel-global-el-ast nil
  (should
   (string=
    (pyel "def a():\n global x\n x = 3\n y = 1" t)
    "(def \" a \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x)) (assign  ((name  \"x\" 'store)) (num 3)) (assign  ((name  \"y\" 'store)) (num 1))) nil nil )\n"))
  (should
   (string=
    (pyel "x = 1\ny = 1\ndef func():\n global x\n x = 7\n y = 7\nfunc()\nassert x == 7\nassert y == 1\n" t)
    "(assign  ((name  \"x\" 'store)) (num 1))\n(assign  ((name  \"y\" 'store)) (num 1))\n(def \" func \" ((arguments  nil nil nil nil nil nil nil nil )) ((global (x)) (assign  ((name  \"x\" 'store)) (num 7)) (assign  ((name  \"y\" 'store)) (num 7))) nil nil )\n(call  (name  \"func\" 'load) nil nil nil nil)\n(assert  (compare  (name  \"x\" 'load) (\"==\") ((num 7))) nil)\n(assert  (compare  (name  \"y\" 'load) (\"==\") ((num 1))) nil)\n")))

(ert-deftest pyel-lambda-full-transform nil
  (should
   (equal
    (pyel "lambda x,y,z=4,*g: print(z);x()")
    '(progn
       (lambda
         (x y &optional z &rest g)
         (setq z
               (or z 4))
         (print z))
       (x))))
  (should
   (equal
    (pyel "x = range(2, 9)\nx2 = reduce(lambda a,b:a+b, x)\nassert x2 == 35")
    '(progn
       (setq x
             (py-range 2 9))
       (setq x2
             (reduce
              (lambda
                (a b)
                (pyel-+ a b))
              x))
       (assert
        (pyel-== x2 35)
        t nil)))))
(ert-deftest pyel-lambda-py-ast nil
  (should
   (equal
    (py-ast "lambda x,y,z=4,*g: print(z);x()")
    "Module(body=[Expr(value=Lambda(args=arguments(args=[arg(arg='x', annotation=None), arg(arg='y', annotation=None), arg(arg='z', annotation=None)], vararg='g', varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[Num(n=4)], kw_defaults=[]), body=Call(func=Name(id='print', ctx=Load()), args=[Name(id='z', ctx=Load())], keywords=[], starargs=None, kwargs=None))), Expr(value=Call(func=Name(id='x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])\n"))
  (should
   (equal
    (py-ast "x = range(2, 9)\nx2 = reduce(lambda a,b:a+b, x)\nassert x2 == 35")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Call(func=Name(id='range', ctx=Load()), args=[Num(n=2), Num(n=9)], keywords=[], starargs=None, kwargs=None)), Assign(targets=[Name(id='x2', ctx=Store())], value=Call(func=Name(id='reduce', ctx=Load()), args=[Lambda(args=arguments(args=[arg(arg='a', annotation=None), arg(arg='b', annotation=None)], vararg=None, varargannotation=None, kwonlyargs=[], kwarg=None, kwargannotation=None, defaults=[], kw_defaults=[]), body=BinOp(left=Name(id='a', ctx=Load()), op=Add(), right=Name(id='b', ctx=Load()))), Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None)), Assert(test=Compare(left=Name(id='x2', ctx=Load()), ops=[Eq()], comparators=[Num(n=35)]), msg=None)])\n")))
(ert-deftest pyel-lambda-el-ast nil
  (should
   (string=
    (pyel "lambda x,y,z=4,*g: print(z);x()" t)
    "(lambda ((arguments  ((arg \"x\"  nil) (arg \"y\"  nil) (arg \"z\"  nil)) g nil nil nil nil ((num 4)) nil )) ((call  (name  \"print\" 'load) ((name  \"z\" 'load)) nil nil nil)))\n(call  (name  \"x\" 'load) nil nil nil nil)\n"))
  (should
   (string=
    (pyel "x = range(2, 9)\nx2 = reduce(lambda a,b:a+b, x)\nassert x2 == 35" t)
    "(assign  ((name  \"x\" 'store)) (call  (name  \"range\" 'load) ((num 2) (num 9)) nil nil nil))\n(assign  ((name  \"x2\" 'store)) (call  (name  \"reduce\" 'load) ((lambda ((arguments  ((arg \"a\"  nil) (arg \"b\"  nil)) nil nil nil nil nil nil nil )) ((bin-op  (name  \"a\" 'load) + (name  \"b\" 'load)))) (name  \"x\" 'load)) nil nil nil))\n(assert  (compare  (name  \"x2\" 'load) (\"==\") ((num 35))) nil)\n")))

;;

(ert-deftest pyel-aug-assign-full-transform nil
  (should
   (equal
    (pyel "a += b")
    '(setq a
           (pyel-+ a b))))
  (should
   (equal
    (pyel "a -= b")
    '(setq a
           (pyel-- a b))))
  (should
   (equal
    (pyel "a /= b")
    '(setq a
           (pyel-/ a b))))
  (should
   (equal
    (pyel "a *= b")
    '(setq a
           (pyel-* a b))))
  (should
   (equal
    (pyel "a **= b")
    '(setq a
           (pyel-** a b))))
  (should
   (equal
    (pyel "a ^= b")
    '(setq a
           (pyel-^ a b))))
  (should
   (equal
    (pyel "a |= b")
    '(setq a
           (pyel-| a b))))
  (should
   (equal
    (pyel "a = 3\nb = 4\na += b + 1\nassert a == 8")
    '(progn
       (setq a 3)
       (setq b 4)
       (setq a
             (pyel-+ a
                     (pyel-+ b 1)))
       (assert
        (pyel-== a 8)
        t nil)))))
(ert-deftest pyel-aug-assign-py-ast nil
  (should
   (equal
    (py-ast "a += b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Add(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a -= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Sub(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a /= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Div(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a *= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Mult(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a **= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=Pow(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a ^= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitXor(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a |= b")
    "Module(body=[AugAssign(target=Name(id='a', ctx=Store()), op=BitOr(), value=Name(id='b', ctx=Load()))])\n"))
  (should
   (equal
    (py-ast "a = 3\nb = 4\na += b + 1\nassert a == 8")
    "Module(body=[Assign(targets=[Name(id='a', ctx=Store())], value=Num(n=3)), Assign(targets=[Name(id='b', ctx=Store())], value=Num(n=4)), AugAssign(target=Name(id='a', ctx=Store()), op=Add(), value=BinOp(left=Name(id='b', ctx=Load()), op=Add(), right=Num(n=1))), Assert(test=Compare(left=Name(id='a', ctx=Load()), ops=[Eq()], comparators=[Num(n=8)]), msg=None)])\n")))
(ert-deftest pyel-aug-assign-el-ast nil
  (should
   (string=
    (pyel "a += b" t)
    "(aug-assign (name  \"a\" 'store) + (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a -= b" t)
    "(aug-assign (name  \"a\" 'store) - (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a /= b" t)
    "(aug-assign (name  \"a\" 'store) / (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a *= b" t)
    "(aug-assign (name  \"a\" 'store) * (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a **= b" t)
    "(aug-assign (name  \"a\" 'store) ** (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a ^= b" t)
    "(aug-assign (name  \"a\" 'store) ^ (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a |= b" t)
    "(aug-assign (name  \"a\" 'store) | (name  \"b\" 'load))\n"))
  (should
   (string=
    (pyel "a = 3\nb = 4\na += b + 1\nassert a == 8" t)
    "(assign  ((name  \"a\" 'store)) (num 3))\n(assign  ((name  \"b\" 'store)) (num 4))\n(aug-assign (name  \"a\" 'store) + (bin-op  (name  \"b\" 'load) + (num 1)))\n(assert  (compare  (name  \"a\" 'load) (\"==\") ((num 8))) nil)\n")))

;;

;;

;;

(ert-deftest pyel-try-full-transform nil
  (should
   (equal
    (pyel "x = ''\ntry:\n 1 / 0\n x = 'yes'\nexcept:\n x = 'no'\nassert x == 'no'")
    '(progn
       (setq x "")
       (condition-case nil
           (pyel-/ 1 0)
         (setq x "yes")
         (error
          (setq x "no")))
       (assert
        (pyel-== x "no")
        t nil))))
  (should
   (equal
    (pyel "try:\n _a()\nexcept:\n try:\n  _x()\n except:\n  _b()")
    '(condition-case nil
         (-a)
       (error
        (condition-case nil
            (-x)
          (error
           (-b))))))))
(ert-deftest pyel-try-py-ast nil
  (should
   (equal
    (py-ast "x = ''\ntry:\n 1 / 0\n x = 'yes'\nexcept:\n x = 'no'\nassert x == 'no'")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='')), TryExcept(body=[Expr(value=BinOp(left=Num(n=1), op=Div(), right=Num(n=0))), Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='yes'))], handlers=[ExceptHandler(type=None, name=None, body=[Assign(targets=[Name(id='x', ctx=Store())], value=Str(s='no'))])], orelse=[]), Assert(test=Compare(left=Name(id='x', ctx=Load()), ops=[Eq()], comparators=[Str(s='no')]), msg=None)])\n"))
  (should
   (equal
    (py-ast "try:\n _a()\nexcept:\n try:\n  _x()\n except:\n  _b()")
    "Module(body=[TryExcept(body=[Expr(value=Call(func=Name(id='_a', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[TryExcept(body=[Expr(value=Call(func=Name(id='_x', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))], handlers=[ExceptHandler(type=None, name=None, body=[Expr(value=Call(func=Name(id='_b', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])], orelse=[])])], orelse=[])])\n")))
(ert-deftest pyel-try-el-ast nil
  (should
   (string=
    (pyel "x = ''\ntry:\n 1 / 0\n x = 'yes'\nexcept:\n x = 'no'\nassert x == 'no'" t)
    "(assign  ((name  \"x\" 'store)) (str \"\"))\n(try ((bin-op  (num 1) / (num 0)) (assign  ((name  \"x\" 'store)) (str \"yes\"))) ((except-handler nil nil ((assign  ((name  \"x\" 'store)) (str \"no\"))))) ())\n(assert  (compare  (name  \"x\" 'load) (\"==\") ((str \"no\"))) nil)\n"))
  (should
   (string=
    (pyel "try:\n _a()\nexcept:\n try:\n  _x()\n except:\n  _b()" t)
    "(try ((call  (name  \"_a\" 'load) nil nil nil nil)) ((except-handler nil nil ((try ((call  (name  \"_x\" 'load) nil nil nil nil)) ((except-handler nil nil ((call  (name  \"_b\" 'load) nil nil nil nil)))) ())))) ())\n")))

;;

;;

(ert-deftest pyel-list-comprehensions-full-transform nil
  (should
   (equal
    (pyel "[x*x for x in range(10)]")
    '(let
         ((__list__ nil))
       (loop for x in
             (py-range 10)
             do
             (setq __list__
                   (cons
                    (pyel-* x x)
                    __list__)))
       (reverse __list__))))
  (should
   (equal
    (pyel "[x*x for x in range(10) if x > 5]")
    '(let
         ((__list__ nil))
       (loop for x in
             (py-range 10)
             if
             (pyel-> x 5)
             do
             (setq __list__
                   (cons
                    (pyel-* x x)
                    __list__)))
       (reverse __list__))))
  (should
   (equal
    (pyel "[x*x for x in range(10) if x > 5 if x < 8]")
    '(let
         ((__list__ nil))
       (loop for x in
             (py-range 10)
             if
             (and
              (pyel-> x 5)
              (pyel-< x 8))
             do
             (setq __list__
                   (cons
                    (pyel-* x x)
                    __list__)))
       (reverse __list__))))
  (should
   (equal
    (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]")
    '(assert
      (pyel-==
       (let
           ((__list__ nil))
         (loop for x in
               (list 1 2 3)
               do
               (loop for y in
                     (list 3 1 4)
                     if
                     (pyel-!= x y)
                     do
                     (setq __list__
                           (cons
                            (vector x y)
                            __list__))))
         (reverse __list__))
       (list
        (vector 1 3)
        (vector 1 4)
        (vector 2 3)
        (vector 2 1)
        (vector 2 4)
        (vector 3 1)
        (vector 3 4)))
      t nil)))
  (should
   (equal
    (pyel "\nmatrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]\n_x = [[row[i] for row in matrix] for i in range(4)]\nassert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]")
    '(progn
       (setq matrix
             (list
              (list 1 2 3 4)
              (list 5 6 7 8)
              (list 9 10 11 12)))
       (setq -x
             (let
                 ((__list__ nil))
               (loop for i in
                     (py-range 4)
                     do
                     (setq __list__
                           (cons
                            (let
                                ((__list__ nil))
                              (loop for row in matrix do
                                    (setq __list__
                                          (cons
                                           (pyel-subscript-load-index row i)
                                           __list__)))
                              (reverse __list__))
                            __list__)))
               (reverse __list__)))
       (assert
        (pyel-== -x
                 (list
                  (list 1 5 9)
                  (list 2 6 10)
                  (list 3 7 11)
                  (list 4 8 12)))
        t nil))))
  (should
   (equal
    (pyel "\ntransposed = []\nfor i in range(4):\n transposed.append([row[i] for row in matrix])\nassert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]\n")
    '(progn
       (setq transposed
             (list))
       (loop for i in
             (py-range 4)
             do
             (pyel-append-method transposed
                                 (let
                                     ((__list__ nil))
                                   (loop for row in matrix do
                                         (setq __list__
                                               (cons
                                                (pyel-subscript-load-index row i)
                                                __list__)))
                                   (reverse __list__))))
       (assert
        (pyel-== transposed
                 (list
                  (list 1 5 9)
                  (list 2 6 10)
                  (list 3 7 11)
                  (list 4 8 12)))
        t nil))))
  (should
   (equal
    (pyel "{x: [y*y for y in range(x)] for x in range(20)}")
    '(let
         ((__dict__
           (make-hash-table :test 'equal)))
       (loop for x in
             (py-range 20)
             do
             (puthash x
                      (let
                          ((__list__ nil))
                        (loop for y in
                              (py-range x)
                              do
                              (setq __list__
                                    (cons
                                     (pyel-* y y)
                                     __list__)))
                        (reverse __list__))
                      __dict__))
       __dict__)))
  (should
   (equal
    (pyel "x = {x: number_to_string(x) for x in range(10)}\nassert hash_table_count(x) == 10\nassert x[1] == '1'\nassert x[9] == '9'\n")
    '(progn
       (setq x
             (let
                 ((__dict__
                   (make-hash-table :test 'equal)))
               (loop for x in
                     (py-range 10)
                     do
                     (puthash x
                              (number-to-string x)
                              __dict__))
               __dict__))
       (assert
        (pyel-==
         (hash-table-count x)
         10)
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-index x 1)
         "1")
        t nil)
       (assert
        (pyel-==
         (pyel-subscript-load-index x 9)
         "9")
        t nil)))))
(ert-deftest pyel-list-comprehensions-py-ast nil
  (should
   (equal
    (py-ast "[x*x for x in range(10)]")
    "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])\n"))
  (should
   (equal
    (py-ast "[x*x for x in range(10) if x > 5]")
    "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)])])]))])\n"))
  (should
   (equal
    (py-ast "[x*x for x in range(10) if x > 5 if x < 8]")
    "Module(body=[Expr(value=ListComp(elt=BinOp(left=Name(id='x', ctx=Load()), op=Mult(), right=Name(id='x', ctx=Load())), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[Gt()], comparators=[Num(n=5)]), Compare(left=Name(id='x', ctx=Load()), ops=[Lt()], comparators=[Num(n=8)])])]))])\n"))
  (should
   (equal
    (py-ast "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]")
    "Module(body=[Assert(test=Compare(left=ListComp(elt=Tuple(elts=[Name(id='x', ctx=Load()), Name(id='y', ctx=Load())], ctx=Load()), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=List(elts=[Num(n=1), Num(n=2), Num(n=3)], ctx=Load()), ifs=[]), comprehension(target=Name(id='y', ctx=Store()), iter=List(elts=[Num(n=3), Num(n=1), Num(n=4)], ctx=Load()), ifs=[Compare(left=Name(id='x', ctx=Load()), ops=[NotEq()], comparators=[Name(id='y', ctx=Load())])])]), ops=[Eq()], comparators=[List(elts=[Tuple(elts=[Num(n=1), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=1), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=3)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=2), Num(n=4)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=1)], ctx=Load()), Tuple(elts=[Num(n=3), Num(n=4)], ctx=Load())], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "\nmatrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]\n_x = [[row[i] for row in matrix] for i in range(4)]\nassert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]")
    "Module(body=[Assign(targets=[Name(id='matrix', ctx=Store())], value=List(elts=[List(elts=[Num(n=1), Num(n=2), Num(n=3), Num(n=4)], ctx=Load()), List(elts=[Num(n=5), Num(n=6), Num(n=7), Num(n=8)], ctx=Load()), List(elts=[Num(n=9), Num(n=10), Num(n=11), Num(n=12)], ctx=Load())], ctx=Load())), Assign(targets=[Name(id='_x', ctx=Store())], value=ListComp(elt=ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])]), generators=[comprehension(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Name(id='_x', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "\ntransposed = []\nfor i in range(4):\n transposed.append([row[i] for row in matrix])\nassert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]\n")
    "Module(body=[Assign(targets=[Name(id='transposed', ctx=Store())], value=List(elts=[], ctx=Load())), For(target=Name(id='i', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=4)], keywords=[], starargs=None, kwargs=None), body=[Expr(value=Call(func=Attribute(value=Name(id='transposed', ctx=Load()), attr='append', ctx=Load()), args=[ListComp(elt=Subscript(value=Name(id='row', ctx=Load()), slice=Index(value=Name(id='i', ctx=Load())), ctx=Load()), generators=[comprehension(target=Name(id='row', ctx=Store()), iter=Name(id='matrix', ctx=Load()), ifs=[])])], keywords=[], starargs=None, kwargs=None))], orelse=[]), Assert(test=Compare(left=Name(id='transposed', ctx=Load()), ops=[Eq()], comparators=[List(elts=[List(elts=[Num(n=1), Num(n=5), Num(n=9)], ctx=Load()), List(elts=[Num(n=2), Num(n=6), Num(n=10)], ctx=Load()), List(elts=[Num(n=3), Num(n=7), Num(n=11)], ctx=Load()), List(elts=[Num(n=4), Num(n=8), Num(n=12)], ctx=Load())], ctx=Load())]), msg=None)])\n"))
  (should
   (equal
    (py-ast "{x: [y*y for y in range(x)] for x in range(20)}")
    "Module(body=[Expr(value=DictComp(key=Name(id='x', ctx=Load()), value=ListComp(elt=BinOp(left=Name(id='y', ctx=Load()), op=Mult(), right=Name(id='y', ctx=Load())), generators=[comprehension(target=Name(id='y', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ifs=[])]), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=20)], keywords=[], starargs=None, kwargs=None), ifs=[])]))])\n"))
  (should
   (equal
    (py-ast "x = {x: number_to_string(x) for x in range(10)}\nassert hash_table_count(x) == 10\nassert x[1] == '1'\nassert x[9] == '9'\n")
    "Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=DictComp(key=Name(id='x', ctx=Load()), value=Call(func=Name(id='number_to_string', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), generators=[comprehension(target=Name(id='x', ctx=Store()), iter=Call(func=Name(id='range', ctx=Load()), args=[Num(n=10)], keywords=[], starargs=None, kwargs=None), ifs=[])])), Assert(test=Compare(left=Call(func=Name(id='hash_table_count', ctx=Load()), args=[Name(id='x', ctx=Load())], keywords=[], starargs=None, kwargs=None), ops=[Eq()], comparators=[Num(n=10)]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=1)), ctx=Load()), ops=[Eq()], comparators=[Str(s='1')]), msg=None), Assert(test=Compare(left=Subscript(value=Name(id='x', ctx=Load()), slice=Index(value=Num(n=9)), ctx=Load()), ops=[Eq()], comparators=[Str(s='9')]), msg=None)])\n")))
(ert-deftest pyel-list-comprehensions-el-ast nil
  (should
   (string=
    (pyel "[x*x for x in range(10)]" t)
    "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ())))\n"))
  (should
   (string=
    (pyel "[x*x for x in range(10) if x > 5]" t)
    "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ((compare  (name  \"x\" 'load) (\">\") ((num 5)))))))\n"))
  (should
   (string=
    (pyel "[x*x for x in range(10) if x > 5 if x < 8]" t)
    "(list-comp (bin-op  (name  \"x\" 'load) * (name  \"x\" 'load)) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ((compare  (name  \"x\" 'load) (\">\") ((num 5))) (compare  (name  \"x\" 'load) (\"<\") ((num 8)))))))\n"))
  (should
   (string=
    (pyel "assert [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y] == [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]" t)
    "(assert  (compare  (list-comp (tuple  ((name  \"x\" 'load) (name  \"y\" 'load)) 'load) ((comprehension (name  \"x\" 'store) (list ((num 1) (num 2) (num 3)) 'load) ()) (comprehension (name  \"y\" 'store) (list ((num 3) (num 1) (num 4)) 'load) ((compare  (name  \"x\" 'load) (\"!=\") ((name  \"y\" 'load))))))) (\"==\") ((list ((tuple  ((num 1) (num 3)) 'load) (tuple  ((num 1) (num 4)) 'load) (tuple  ((num 2) (num 3)) 'load) (tuple  ((num 2) (num 1)) 'load) (tuple  ((num 2) (num 4)) 'load) (tuple  ((num 3) (num 1)) 'load) (tuple  ((num 3) (num 4)) 'load)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "\nmatrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]\n_x = [[row[i] for row in matrix] for i in range(4)]\nassert _x == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]" t)
    "(assign  ((name  \"matrix\" 'store)) (list ((list ((num 1) (num 2) (num 3) (num 4)) 'load) (list ((num 5) (num 6) (num 7) (num 8)) 'load) (list ((num 9) (num 10) (num 11) (num 12)) 'load)) 'load))\n(assign  ((name  \"_x\" 'store)) (list-comp (list-comp (subscript (name  \"row\" 'load) (index (name  \"i\" 'load)) 'load) ((comprehension (name  \"row\" 'store) (name  \"matrix\" 'load) ()))) ((comprehension (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 4)) nil nil nil) ()))))\n(assert  (compare  (name  \"_x\" 'load) (\"==\") ((list ((list ((num 1) (num 5) (num 9)) 'load) (list ((num 2) (num 6) (num 10)) 'load) (list ((num 3) (num 7) (num 11)) 'load) (list ((num 4) (num 8) (num 12)) 'load)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "\ntransposed = []\nfor i in range(4):\n transposed.append([row[i] for row in matrix])\nassert transposed == [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]\n" t)
    "(assign  ((name  \"transposed\" 'store)) (list nil 'load))\n(for  (name  \"i\" 'store) (call  (name  \"range\" 'load) ((num 4)) nil nil nil) ((call  (attribute  (name  \"transposed\" 'load) \"append\" 'load) ((list-comp (subscript (name  \"row\" 'load) (index (name  \"i\" 'load)) 'load) ((comprehension (name  \"row\" 'store) (name  \"matrix\" 'load) ())))) nil nil nil)) nil)\n(assert  (compare  (name  \"transposed\" 'load) (\"==\") ((list ((list ((num 1) (num 5) (num 9)) 'load) (list ((num 2) (num 6) (num 10)) 'load) (list ((num 3) (num 7) (num 11)) 'load) (list ((num 4) (num 8) (num 12)) 'load)) 'load))) nil)\n"))
  (should
   (string=
    (pyel "{x: [y*y for y in range(x)] for x in range(20)}" t)
    "(dict-comp (name  \"x\" 'load) (list-comp (bin-op  (name  \"y\" 'load) * (name  \"y\" 'load)) ((comprehension (name  \"y\" 'store) (call  (name  \"range\" 'load) ((name  \"x\" 'load)) nil nil nil) ()))) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 20)) nil nil nil) ())))\n"))
  (should
   (string=
    (pyel "x = {x: number_to_string(x) for x in range(10)}\nassert hash_table_count(x) == 10\nassert x[1] == '1'\nassert x[9] == '9'\n" t)
    "(assign  ((name  \"x\" 'store)) (dict-comp (name  \"x\" 'load) (call  (name  \"number_to_string\" 'load) ((name  \"x\" 'load)) nil nil nil) ((comprehension (name  \"x\" 'store) (call  (name  \"range\" 'load) ((num 10)) nil nil nil) ()))))\n(assert  (compare  (call  (name  \"hash_table_count\" 'load) ((name  \"x\" 'load)) nil nil nil) (\"==\") ((num 10))) nil)\n(assert  (compare  (subscript (name  \"x\" 'load) (index (num 1)) 'load) (\"==\") ((str \"1\"))) nil)\n(assert  (compare  (subscript (name  \"x\" 'load) (index (num 9)) 'load) (\"==\") ((str \"9\"))) nil)\n")))

(ert-deftest pyel-boolop-full-transform nil
  (should
   (equal
    (pyel "a or b")
    '(or a b)))
  (should
   (equal
    (pyel "a or b or c")
    '(or a b c)))
  (should
   (equal
    (pyel "a.c or b.c() or a[2]")
    '(or
      (oref a c)
      (c b)
      (pyel-subscript-load-index a 2))))
  (should
   (equal
    (pyel "a and b")
    '(and a b)))
  (should
   (equal
    (pyel "a and b or c")
    '(or
      (and a b)
      c)))
  (should
   (equal
    (pyel "a[2] and b.f() or c.e")
    '(or
      (and
       (pyel-subscript-load-index a 2)
       (f b))
      (oref c e))))
  (should
   (equal
    (pyel "a.e and b[2] or c.e() and 2 ")
    '(or
      (and
       (oref a e)
       (pyel-subscript-load-index b 2))
      (and
       (e c)
       2)))))
(ert-deftest pyel-boolop-py-ast nil
  (should
   (equal
    (py-ast "a or b")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a or b or c")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load()), Name(id='c', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a.c or b.c() or a[2]")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='c', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a and b")
    "Module(body=[Expr(value=BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a and b or c")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Name(id='a', ctx=Load()), Name(id='b', ctx=Load())]), Name(id='c', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a[2] and b.f() or c.e")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Subscript(value=Name(id='a', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load()), Call(func=Attribute(value=Name(id='b', ctx=Load()), attr='f', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None)]), Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load())]))])\n"))
  (should
   (equal
    (py-ast "a.e and b[2] or c.e() and 2 ")
    "Module(body=[Expr(value=BoolOp(op=Or(), values=[BoolOp(op=And(), values=[Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Load())]), BoolOp(op=And(), values=[Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), Num(n=2)])]))])\n")))
(ert-deftest pyel-boolop-el-ast nil
  (should
   (string=
    (pyel "a or b" t)
    "(boolop or ((name  \"a\" 'load) (name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a or b or c" t)
    "(boolop or ((name  \"a\" 'load) (name  \"b\" 'load) (name  \"c\" 'load)))\n"))
  (should
   (string=
    (pyel "a.c or b.c() or a[2]" t)
    "(boolop or ((attribute  (name  \"a\" 'load) \"c\" 'load) (call  (attribute  (name  \"b\" 'load) \"c\" 'load) nil nil nil nil) (subscript (name  \"a\" 'load) (index (num 2)) 'load)))\n"))
  (should
   (string=
    (pyel "a and b" t)
    "(boolop and ((name  \"a\" 'load) (name  \"b\" 'load)))\n"))
  (should
   (string=
    (pyel "a and b or c" t)
    "(boolop or ((boolop and ((name  \"a\" 'load) (name  \"b\" 'load))) (name  \"c\" 'load)))\n"))
  (should
   (string=
    (pyel "a[2] and b.f() or c.e" t)
    "(boolop or ((boolop and ((subscript (name  \"a\" 'load) (index (num 2)) 'load) (call  (attribute  (name  \"b\" 'load) \"f\" 'load) nil nil nil nil))) (attribute  (name  \"c\" 'load) \"e\" 'load)))\n"))
  (should
   (string=
    (pyel "a.e and b[2] or c.e() and 2 " t)
    "(boolop or ((boolop and ((attribute  (name  \"a\" 'load) \"e\" 'load) (subscript (name  \"b\" 'load) (index (num 2)) 'load))) (boolop and ((call  (attribute  (name  \"c\" 'load) \"e\" 'load) nil nil nil nil) (num 2)))))\n")))

;;

;;

(provide 'pyel-tests)
;;pyel-tests.el ends here

;;
