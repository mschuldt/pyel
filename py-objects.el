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

    (setattr new --base-- (car bases))
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
    (setattr-1 new '--class-- class);;double reference

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
  (condition-case nil
      (funcall (caar (aref object getattribute-index)) object attr)  ;;__getattribute__
    (AttributeError
     (funcall (caar (aref object getattr-index)) object attr) ;;__getattr__
     )))


(defun _obj-getattribute (obj attr)
  ;; return the value of attribute ATTR of OBJ
  ;;assumes that ATTR is not special
  
  (let (val)
    (condition-case nil
	;;look for data descriptor in obj.__class__.__dict__
	(_find-data-descriptor (aref (aref obj obj-bases-index) 0) obj attr) 
      (AttributeError ;;look for attr in obj.__dict__
       (if (eq (aref obj obj-symbol-index) obj-class-symbol)
	   (_find-attr obj attr) ;; if obj is a class, search its bases as well
	 (if (setq val (assoc attr (aref obj obj-dict-index)))
	     (cdr val)
	   (_find-non-data-descriptor (aref (aref obj obj-bases-index) 0) obj attr)))
       ))))

(defun _find-data-descriptor (class object name)
  "return the value of the data descriptor NAME if found, else raise error"
  
  (let ((val (cdr (assq name (aref class obj-dict-index)))))
    (if (data-descriptor-p val)
	(call-method val __get__ class object)
      ;;data descriptor not found, now check the bases
      (let* ((bases (aref class obj-bases-index))
	     (nbases (length bases))
	     (i 0)
	     done  val)
	(if (> nbases 0)
	    (while (not done)
	      (setq done (condition-case nil
			     (progn (setq val
					  (_find-data-descriptor (aref bases i)
								 object name))
				    t)
			   (AttributeError nil)))

	      (setq i (1+ i))
	      (if (and (not done)
		       (>= i nbases)) (signal 'AttributeError nil))))
	(or (and done val)
	    (signal 'AttributeError nil))))))

(defun _find-attr (object attr)
  "return the value of ATTR.
if it is a descriptor, return its value
if it is not found, raise an AttributeError
this does not create bound methods"
  (let ((val (assq name (aref object obj-dict-index))))
    (if (not val)
	;;data descriptor not found, now check the bases
	(let* ((bases (aref object obj-bases-index))
	       (nbases (length bases))
	       (i 0)
	       done)
	  (while (not done)
	    (setq done (condition-case nil
			   (progn (setq val
					(_find-attr (aref bases i)
						    object name))
				  t)
			 (AttributeError nil)))

	    (setq i (1+ i))
	    (if (and (not done)
		     (>= i nbases)) (signal 'AttributeError nil)))))
    (if val
	(if (descriptor-p (setq val (cdr val))) 
	    (call-method val __get__ object object)
	  val)
      (signal 'AttributeError nil))))

(defun _find-non-data-descriptor (class object name)
  "search for the non-data descriptor or plan attribute NAME
if it is a descriptor, return its value"
  (let ((val (assq name (aref class obj-dict-index))))
    
    (if (not val)
	;;attr not found, now check the bases
	(let* ((bases (aref class obj-bases-index))
	       (nbases (length bases))
	       (i 0)
	       done)
	  (while (not done)
	    (setq done
		  (condition-case nil
		      (progn (setq val (_find-non-data-descriptor (aref bases i) object name))
			     t)
		    (AttributeError nil)))

	    (setq i (1+ i))
	    (if (and (not done)
		     (>= i nbases)) (signal 'AttributeError nil)))))

    
    (if val
	;;found the attr, now check if it is a data descriptor or method
	(cond ((functionp (setq val (cdr val)))
	       (bind-method object val))
	      ((non-data-descriptor-p val)
	       (call-method val __get__ class object))
	      (t val))
      (signal 'AttributeError nil))))

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

(defun py-instance-p (thing)
  (and (vectorp thing)
       (= (length thing) py-class-vector-length)
       (eq (aref thing obj-symbol-index) obj-instance-symbol)))

(defun py-object-p (thing)
  (and (vectorp thing)
       (= (length thing) py-class-vector-length)
       (or (eq (aref thing obj-symbol-index) obj-instance-symbol)
	   (eq (aref thing obj-symbol-index) obj-class-symbol))))

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
      
      `(funcall (getattr-1 ,object ',method)
		;;,object ,@args))))
		,@args))))

(defmacro setattr (obj attr value)
  `(setattr-1 ,obj ',(if (stringp attr) (intern attr) attr) ,value))

(defun setattr-1 (obj attr value)
  (funcall (caar (aref obj setatter-index)) obj attr value))

(defun _obj-setattr (obj attr value)
  ;;TODO: if attr is a data-descriptor, use that to set it
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
  `(defun ,name ,args
     ,doc
     ,@body
     ))

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
       (_obj-getatrtibute self name))
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
