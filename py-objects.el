;; experimental object system

(defconst obj-instance-symbol 'pyel-obj)
(defconst obj-class-symbol 'pyel-class)

(set
 (defvar object-indexes-alist nil 
   "alist of name and corresponding indexes
the rest are in `special-method-names'")
 (let ((n -1))
   (mapcar (lambda (x)
	     (setq n (setq n (1+ n)))
	     (eval (list 'setq x n))
	     (cons x n))
	   
	   '(obj-symbol-index
	     obj-dict-index
	     obj-bases-index ;;for instances, this contains their class
	     setatter-index
	     getattribute-index
	     getattr-index
	     ))))

(set
 (defvar special-method-names nil
   "alist of speical method names and their corresponding indexes")
 (let ((n (- (length object-indexes-alist) 1)))
   (mapcar (lambda (x) (cons x (setq n (1+ n))))
	   
	   '(--init--
	     --str--
	     --repr--
	     --call--
	     --get--
	     --set--	     
	     ))))

;;add the special methods whose indexes are explicitly defined 
;;in `object-indexes-alist' instead of `special-method-names'
(mapc (lambda (x) (push (cons (cadr x) (eval (car x))) special-method-names))
      '((setatter-index  --setattr--)
	(getattribute-index --getattribute--)
	(getattr-index --getattr--)))


;;TODO: add spcial-method-names to object-indexes-alist
(setq py-class-vector-length (+ (length special-method-names)
				(length object-indexes-alist)))

(defvar setter-functions '(setq pset py-set)
  "list of symbols of function that can bind values
The second element of the list must be the symbol to be bound")

(defvar object-indexes nil "list of variables refer to object array indexes
These names will be set globally to their index in this list")

(defun make-empty-class ()
  (let ((v (make-vector py-class-vector-length nil)))
    (aset v 0 obj-class-symbol)
    v))

(defun make-empty-instance ()
  (let ((v (make-vector py-class-vector-length nil)))
    (aset v 0 obj-instance-symbol)
    v))

(defmacro define-class (name bases &rest attributes)
  (let* ((new (make-empty-class))
	 (bases (if (eq name 'object)
		    nil
		  (or bases '(object)))) ;;everything inherits from object
	 (bases (list-to-vector bases)) ;;Python keeps the bases in a tuple
	 (doc (if (eq (type-of (car attributes)) 'string)
		  (pop attributes) nil))
	 class-variables
	 methods non-method)

    (when (eq name 'object) ;;give the first one some help...
      (aset new setatter-index 
	    (list (list (lambda (self attr value)
			  (_obj-setattr self attr value))))))

    (if (not (eq bases []))
	(let ((base (aref bases 0)))
	  ;;TODO: proper MRO -- currently just picking the first class
	  
	  (aset new setatter-index (aref base setatter-index))
	  (aset new getattribute-index (aref base getattribute-index))
	  ;;TODO: copy all special methods from the base classes
	  ))
    
    (dolist (attr attributes)
      
      ;;collect symbols that get bound during class definition
      (cond ((and (consp attr)
		  (symbolp (cadr attr))
		  (member (car attr) setter-functions))
	     (progn (push (cadr attr) class-variables)
		    (push attr non-method)))

	    ;;add special methods to 'new' and collect other methods in 'methods'
	    ((eq (car attr) 'def)
	     (if (< (length attr) 4)
		 (error "improper method form")
	       (let* ((name (pop attr))
		      (name (pop attr))
		      (args (pop attr))
		      (decorators (pop attr))
		      (doc (if (eq (type-of (car attr)) 'string) (pop attr) nil))
		      (func `(lambda ,args ,@attr))
		      attr type )
		 (setq type (cond ((assoc name special-method-names) 'special)
				  ((member 'property decorators) 'property)
				  (t 'method)))

		 (if (eq type 'special)
		     ;;TODO: decorators?
		     ;;special methods don't have the usual attribute format
		     (aset new (cdr (assoc name special-method-names)) (list (list func)))
		   ;;else normal method
		   (setq methods (cons (cons name func) methods))))))
	    (t (push attr non-method))))

    ;;eval non-method bits
    (setq class-variables
	  (mapcar* 'cons
		   class-variables
		   (eval `(let ,class-variables
			    ,@(reverse non-method)
			    (list ,@class-variables)))))
    
    ;;add class variables and methods to object dict
    (aset new obj-dict-index
	  (append methods
		  (mapcar (lambda (var--value)
			    (cons (car var--value)
				  (cdr var--value)))
			  class-variables)))
    (setattr new --name-- name)
    (when doc
      (setattr new --doc-- doc))

    ;;This double reference makes the __bases__ attribute available
    ;;for users and provides this implementation quicker access
    (setattr new --bases-- bases)
    (aset new obj-bases-index bases)
    
    `(progn
       (setq ,name ',new)
       (defun ,name (&rest args)
	 (obj-make-instance ,name args)))))

(defun add-to-end (list thing)
  "add THING to the end of LIST"
  (while (not (null (cdr list)))
    (setq list (cdr list)))
  (setcdr list (list thing)))


(defun obj-make-instance (class args)
  (let ((new (make-empty-instance)))

    ;;each instance has its own reference to the getter and setter methods
    ;;for faster lookup
    ;;This must also be done before any calls to `setattr'
    (aset new setatter-index (aref (setq _x class) setatter-index))
    (aset new getattribute-index (aref class getattribute-index))
    (dolist (special special-method-names)
      (let* ((class-ref (aref class (cdr special)))
	     (instance-ref (list (car (car class-ref)))))
	(when class-ref
	  (add-to-end class-ref instance-ref)
	  (aset new (cdr special) (list instance-ref)))))
    
    (aset new obj-bases-index (vector class)) ;;TODO: nesseary to vectorize again?
    (obj-setattr new '--class-- class);;double reference

    (setq _x new)
    (setq _a args)
    (eval `(call-method new --init-- ,@args))
    new))

(defun descriptor-p (object)
  (and (py-object-p object)
       (or (obj-hasattr object '__get__)
	   (obj-hasattr object '__set__))))

(defun data-descriptor-p (object)
  (and (py-object-p object)
       (obj-hasattr object '__get__)
       (obj-hasattr object '__set__)))

(defun non-data-descriptor-p (object)
  (or (functionp object)
      (and (py-object-p object)
	   (obj-hasattr object '__get__)
	   (not (obj-hasattr object '__set__)))))

(defmacro getattr (object attr)
  (let* ((attr (if (stringp attr) (intern attr) attr))
	 (special (assoc attr special-method-names)))
    (if special
	`(_obj-get-special ,object ,(cdr special))
      `(getattr-1 ,object ',attr))))

(defun getattr-1 (object attr)
  "lookup ATTR in OBJECT. Presumes ATTR is not a special method.
if it is not call OBJECT's --getattr-- method if defined"
  (let* ((attr (condition-case nil
		   (funcall (caar (aref object getattribute-index)) object attr)  ;;__getattribute__
		 (AttributeError
		  (funcall (caar (aref object getattr-index)) object attr) ;;__getattr__
		  )))
	 (val (cdr attr)))
    (if (and (py-object-p object)
	     (functionp val))
	(bind-method object val)
      val)))

(defun _obj-getattribute (obj attr)
  ;; retrieves the internal attribute representation
  
  ;;This does not call the objects --getattr-- method
  ;; (but the --getattr-- method of the class will get called
  ;; if it has to look for it there)  
  (let ((val (assq attr (aref obj obj-dict-index)))
	bases nbases i)
    (if val
	val
      ;;did not find it in this object
      ;;now check the class or the base classes

      (setq bases (aref obj obj-bases-index))
      ;;TODO: obj-bases-index is being used interchangeably with the type-index
      (setq nbases (length bases)
	    i 0)
      (while (not val) ;;TODO: proper MRO
	(setq val (_obj-getattribute (aref bases i) attr))
	(setq i (1+ i))
	(if (and (not val)
		 (>= i nbases)) (error "attr does not exist")))
      val
					;      (obj-class-getattr (aref obj obj-bases-index) attr))
      )))


(defun bind-method (object method)
  "bind METHOD to OBJECT"
  ;;TODO: this is not fully compatible with python
  ;;      maybe this should return an object
  ;;presumes that method is a lambda function
  (let ((args (cdadr method)))
    `(lambda ,args
       (funcall ,method ,object ,@args))))

(defun py-class-p (thing)
  (and (vectorp thing)
       (= (length thing) py-class-vector-length)
       (eq (aref thing obj-symbol-index) obj-class-symbol)))

(defun py-object-p (thing)
  (and (vectorp thing)
       (= (length thing) py-class-vector-length)
       (eq (aref thing obj-symbol-index) obj-instance-symbol)))

(defun _obj-get-special (object method-index)
  "get a special method of OBJECT indexed by METHOD-INDEX"
  (let ((method (caar (aref object method-index))))
    (or method
	(let* ((bases (aref object obj-bases-index))
	       (nbases (length bases))
	       (i 0))
	  (while (not method) ;;TODO: proper MRO
	    (setq method (_obj-get-special (aref bases i) method-index))
	    (setq i (1+ i))
	    (if (and (not method)
		     (>= i nbases)) (error "attr does not exist")))
	  method)
	(error "method not found"))
    ;;TODO: inheritance
    ))

(defmacro call-method (object method &rest args)
  ;;'bind' method and call it
  (let ((special (assoc method special-method-names)))
    (if special
	`(funcall (_obj-get-special ,object ,(cdr special)) ,object ,@args)
      
      `(funcall (cdr (_obj-getattribute ,object ',method))
		,object ,@args))))

(defmacro setattr (obj attr value)
  `(obj-setattr ,obj ',(if (stringp attr) (intern attr) attr) ,value))

(defun obj-setattr (obj attr value)
  (funcall (caar (aref obj setatter-index)) obj attr value))

(defun _obj-setattr (obj attr value)
  ;;TODO: specify the type?
  ;;TODO: this does not remove the old value, just shadows it
  (push (cons attr value)
	(aref obj obj-dict-index))
  nil)

(defun obj-hasattr (object attr)
  (condition-case nil
      (progn (getattr-1 object attr)
	     t)
    (AttributeError nil)))

(defun obj-isinstance (object class)
  ;;TODO: built in types
  (and (py-object-p object)
       (py-class-p class)
       (eq (aref (aref object obj-bases-index) 0) class)))


(defmacro def (name args decorator-list doc &rest body)

  )

(defmacro pyel-def-error (name)
  `(progn
     (put ',name 'error-conditions '(error ,name))
     (put ',name 'error-message '(concat "Error: " (symbol-name name)))))

(pyel-def-error AttributeError)


(define-class object ()
  "The most base type"
  (def --init-- () ()
       "x.__init__(...) initializes x; see help(type(x)) for signature"
       nil)
  (def --getattribute-- (self name) ()
       "x.__getattribute__('name') <==> x.name"
       (_obj-getattribute self name))
  (def --setattr-- (self name value) ()
       "x.__setattr__('name', value) <==> x.name = value"
       (_obj-setattr self name value))
  (def --str-- (self) ()
       "x.__str__() <==> str(x)"
       "<class 'object'>")
  (def --repr-- (self) ()
       "x.__repr__() <==> repr(x)"
       "<class 'object'>")
  )
