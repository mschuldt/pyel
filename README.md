pyel translates .py files to .el files

The goal is to translate a usable subset of python to emacs-lisp. The generated code should be fast enough to make it practical for developing large extensions, even if this limits what can be translated.

# Status
Pyel is in development. It is full of bugs and unimplemented (or incomplete) features, so don't get too excited (yet).

Unimplemented features include: <br>
 - first class functions    <br>
 - lots of built-in type methods   <br>
 - yield   <br>
 - class variables   <br>
 - **kwargs <br> <br>
 - variable unpacking <br>
 - other random stuff
 
It's not all bad though. See the examples for some of what it can do already.
It is quite usable, if you know what it can't do and what e-lisp functions to call from it.

# Setup
In your configuration file:
```cl
(setq pyel-directory "path/to/pyel/directory")
(require 'pyel)
```
# Usage


```cl
(pyel "python code string")
```
returns unevaled e-lisp with supporting function added to `pyel-function-definitions
```cl
(pyel-load "filename.py")
```
translate filename.py, saving the e-lisp in filename.py.el, byte compiling and loading it

```cl
M-x ipyel
```
 ielm style mode that converts python to e-lisp and evaluates it interactively

```cl
M-x pyel-mode
```
displays the translated python side-by-side in a split buffer
 (still buggy, best to avoid for now)

# Examples

## assignment
```python
a = b

a,b = b,a
```

```cl
(setq a b)

(let ((__1__ b)
      (__2__ a))
  (setq a __1__)
  (setq b __2__))
```

## built-in types
```python
a = [1,2,3]
b = (1,2,3)
c = {1:'one', 2:'two', 3:'two'}
```

```cl
(setq a (list 1 2 3))
(setq b (vector 1 2 3))
(setq c (let ((__h__ (make-hash-table :test 'equal)))
	  (puthash 1 "one" __h__)
	  (puthash 2 "two" __h__)
	  (puthash 3 "two" __h__)
	  __h__))
```

## attribute access / method call
```python
a.b
a.b.c
a.b.c()
a.b.c(1,3)
a.b.c.d(x.y(), e.f.h())
```

```cl
(oref a b)
(oref (oref a b) c)
(c (oref a b))
(c (oref a b) 1 3)
(d (oref (oref a b) c) (y x) (h (oref e f)))
```
## translation of function names

```python
num = input('num: ')
map(lambda x: expt(x,2), range(number_to_string(num)))
```

```cl
(setq num (read-string "num: "))
(mapcar (lambda (x) (expt x 2)) (py-range (string-to-number num)))
```
## for loops

```python
m = []
for i in range(5):
    m.append(i)
```

```cl
(setq m (list))
(loop for i in (py-range 5)
      do (pyel-append-method m i))
```

## calling macros from python
```python
if a():
    save_excursion(
        end_of_buffer()
        p = point()
        message(format(\"I'm at point %s\",p)))
```

```cl
(if (a)
    (progn
      (save-excursion (end-of-buffer)
		      (setq p (point))
		      (message (format "I'm at point %s" p)))))
```

## functions
```python
def reverse_list(s):
  'reverse S by side-effect'
  start = 0
  end = len(s) -1
  while start < end:
      s[end],s[start] = s[start], s[end]
      start += 1
      end -= 1
```

```cl
(defun reverse-list (s)
  "reverse S by side-effect"
  (let (start end)
    (setq start 0)
    (setq end (pyel-- (pyel-len-function s) 1))
    (while (pyel-< start end)
      (let ((__1__ (pyel-subscript-load-index s start))
	    (__2__ (pyel-subscript-load-index s end)))
	(pyel-subscript-store-index s end __1__)
	(pyel-subscript-store-index s start __2__))
      (setq start (pyel-+ start 1))
      (setq end (pyel-- end 1)))))
```

### default and variable arguments
```python
def argsdemo(a,b=2,*c):
    return a + b + reduce(lambda a,b: a +b, c)
```

```cl
(defun argsdemo (a &optional b &rest c)
  (setq b (or b 2))
  (pyel-+ (pyel-+ a b) (reduce (lambda (a b) (pyel-+ a b)) c)))
```

### break and continue
```python
def break_continue_demo():
    a = 0
    while True:
        a += 1
        if a % 2 == 0:
            continue 
        elif a > 100:
            break
        
        print(a)
```
```cl
(defun break-continue-demo nil
  (let (a)
    (setq a 0)
    (catch '__break__
      (while t
	(catch '__continue__
	  (setq a (pyel-+ a 1))
	  (if (pyel-== (pyel-% a 2) 0)
	      (progn
		(throw '__continue__ nil))
	    (if (pyel-> a 100) (progn (throw '__break__ nil))))
	  (print a))))))
```

### return
```python
def ret_demo1():
    a()
    return b()
    c()
```

```cl
(defun ret-demo1 nil
  (catch '__return__
    (a)
    (throw '__return__ (b))
    (c)))
```


```python
def ret_demo2():
    a()
    return b()
```

```cl
(defun ret-demo2 nil
  (a)
  (b))
```

## classes
```python
class rlist():
    def __init__(self, first, rest):
        self.first = first
        self.rest = rest
    def len(self):
        if self.rest == None:
            return 1
        else:
            return 1 + self.rest.len()
    def __getitem__(self, i):
        if i == 0:
            return self.first
        else:
            return self.rest[i-1]
    def to_string(self):
        if self.rest == None:
            rest = ''
        else:
            rest = ', ' + self.rest.to_string()
        return format('rlist(%s%s)', self.first, rest)
            
lst = rlist(1, rlist(2, rlist(3, rlist(4,None))))
last = lst[lst.len()-1]
```

```cl
(defclass rlist
  nil
  ((rest :initarg :rest :initform nil)
   (first :initarg :first :initform nil)
   (len :initarg :len :initform nil)
   (to-string :initarg :to-string :initform nil))
  "pyel class")

(defmethod --init-- ((self rlist) first rest)
  (oset self first first)
  (oset self rest rest))

(defmethod len ((self rlist))
  (if (pyel-== (oref self rest) nil)
      (progn
	1)
    (pyel-+ 1 (len (oref self rest)))))

(defmethod --getitem-- ((self rlist) i)
  (if (pyel-== i 0)
      (progn
	(oref self first))
    (pyel-subscript-load-index (oref self rest) (pyel-- i 1))))

(defmethod to-string ((self rlist))
  (if (pyel-== (oref self rest) nil)
      (progn
	(setq rest ""))
    (setq rest (pyel-+ ", " (to-string (oref self rest)))))
  (format "rlist(%s%s)" (oref self first) rest))

(setq lst (let ((__c (rlist "obj")))
	    (--init-- __c 1
		      (let ((__c (rlist "obj")))
			(--init-- __c 2
				  (let ((__c (rlist "obj")))
				    (--init-- __c 3
					      (let ((__c (rlist "obj")))
						(--init-- __c 4 nil)
						__c))
				    __c))
			__c))
	    __c))

(setq last (pyel-subscript-load-index lst (pyel-- (len lst) 1)))
```


