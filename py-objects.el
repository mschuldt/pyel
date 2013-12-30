;; experimental object system

(defconst obj-instance-symbol 'pyel-obj)
(defconst obj-class-symbol 'pyel-class)

(set
 (defvar object-indexes-alist nil
   "alist of name and corresponding indexes")
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
	     --getattr--
	     --getattribute--
	     --call--
	     ))))

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
	 	 (vector (lambda (self attr value)
	 		   (_obj-setattr self attr value)))))

	 (if (not (eq bases []))
	     (let ((base (aref bases 0)))
	       ;;TODO: proper MRO -- currently just picking the first class
	       
	       (aset new setatter-index (aref base setatter-index))
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
				((member 'property decorators) attr-property-type)
				(t attr-method-type)))

	       (if (eq type 'special)
		   ;;TODO: decorators?
		   ;;special methods don't have the usual attribute format
		   (aset new (cdr (assoc name special-method-names)) func)
		 
		 (setq methods (cons (_make-attr :name name
						 :value func
						 :type type
						 :args args
						 :doc doc
						 :decorators decorators ;;??
						 ) methods))))))
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
				 (_make-attr :name (car var--value)
					     :value (cdr var--value)
					     :type attr-normal-type))
			       class-variables)))

	 (obj-set new --name-- name)
	 (when doc
	   (obj-set new --doc-- doc))

	 ;;This double reference makes the __bases__ attribute available
	 ;;for users and provides this implementation quicker access
	 (obj-set new --bases-- bases)
	 (aset new obj-bases-index bases)
	 
	 `(progn
	    (setq ,name ',new)
	    (defun ,name (&rest args)
	      (obj-make-instance ,name args)))))

(defun obj-make-instance (class args)
  (let ((new (make-empty-instance)))

    ;;each instance has its own reference to the getter and setter methods
    ;;for faster lookup
    ;;This must also be done before any calls to `obj-set'
    (aset new setatter-index (aref class setatter-index))
;;    (aset new obj-getter-index (aref class obj-getter-index))
    (dolist (special special-method-names)
      (aset new (cdr special) (aref class (cdr special))))
    
    (aset new obj-bases-index (vector class)) ;;TODO: nesseary to vectorize again?
    (obj-setattr new '--class-- class);;double reference

    (setq _x new)
    (setq _a args)
    (eval `(call-method new --init-- ,@args))
    new))

(defmacro obj-get (object attr)
  (let ((special (assoc attr special-method-names)))
    (if special
	`(_obj-get-special ,object ,(cdr special))
      `(obj-getattr ,object ',attr))))

(defun obj-getattr (object attr)
  "lookup ATTR in OBJECT. Presumes ATTR is not a special method.
if it is not call OBJECT's --getattr-- method if defined"
  (let* ((attr (condition-case nil
		   (funcall (aref object getattribute-index) object attr)  ;;__getattribute__
		 (error
		  (if (setq getter (aref object getattr-index)) ;;__getattr__
		      (funcall getter object attr)
		    (error "attribute not found")))))
	 (type (aref attr attr-type-index))
	 (value (aref attr attr-value-index)))

    (cond ((py-class-p object);; class attribute
	   (aref attr attr-value-index))  
	  ((= type attr-property-type);; @property
	   (funcall attr object))
	  ((= type attr-method-type)  ;; method
	   (bind-method object attr))
	  (t value))))


(defun _obj-getattribute (obj attr)
  ;; retrieves the internal attribute representation
  
  ;;This does not call the objects --getattr-- method
  ;; (but the --getattr-- method of the class will get called
  ;; if it has to look for it there)
  (let ((val (assq attr (aref obj obj-dict-index)))
	bases nbases i)
    (if val
	(cdr val)

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
  (let ((func (_get-attr-prop method :value))
	(args (cdr (_get-attr-prop method :args))))
	       
  `(lambda ,args
     (funcall ,func ,object ,@args))))

(defun py-class-p (thing)
  (and (vectorp thing)
       (= (length thing) py-class-vector-length)
       (eq (aref thing obj-symbol-index) obj-class-symbol)))
  
(defun _obj-get-special (object method-index)
  "get a special method of OBJECT indexed by METHOD-INDEX"
  (let ((method (aref object method-index)))
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
      
      `(funcall (aref (_obj-getattribute ,object ',method) attr-value-index)
		,object ,@args))))

(defmacro obj-set (obj attr value)
  `(obj-setattr ,obj ',attr ,value))

(defun obj-setattr (obj attr value)
    (funcall (aref (aref obj setatter-index) 0) obj attr value))

(defun _obj-setattr (obj attr value)
  ;;TODO: specify the type?
  ;;TODO: this does not remove the old value, just shadows it
  (push (_make-attr :name attr
		    :value value
		    :type attr-normal-type
		    )
	(aref obj obj-dict-index))
  nil)


;;internal attribute representation

(defconst attr-name-index 0) ;;name of the propery
(defconst attr-type-index 1) ;;integer type (property, method, etc) ....
(defconst attr-value-index 2)
(defconst attr-alist-index 3) ;; other properties like documentation, args

(defconst attr-normal-type 0)
(defconst attr-method-type 1) ;;bound method
(defconst attr-property-type 2) ;; methods decorated with @property

(defun _make-attr (&rest keylist);;TODO: check that length is even
  (let ((new (vector nil nil nil nil))
	name
	key value)
    (while keylist
      (setq key (pop keylist)
	    value (pop keylist))
      (cond ((eq key :name)
	     (aset new attr-name-index value)
	     (setq name value))
	    ((eq key :value)
	     (aset new attr-value-index value))
	    ((eq key :type)
	     (aset new attr-type-index value))
	    (t (aset new attr-alist-index
		     (cons (cons key value) (aref new attr-alist-index ))))))
    (if name ;;this should be temporary, so that we can search with 'assq'
	(cons name new)
      (error "attribute has no name"))))

(defmacro _get-attr-prop (attr key)
  (cond ((eq key :name)
	 `(aref ,attr ,attr-name-index))
	((eq key :value)
	 `(aref ,attr ,attr-value-index))
	((eq key :type)
	 `(aref ,attr ,attr-type-index))
	(t `(cdr (assoc ,key (aref ,attr ,attr-alist-index))))))

(defmacro def (name args decorator-list doc &rest body)

)


(define-class object ()
  "The most base type"
  (def --getattribute-- (self name) ()
       "x.__getattribute__('name') <==> x.name"
       (_obj-getattribute self name))
  (def --setattr-- (self name value) ()
       "x.__setattr__('name', value) <==> x.name = value"
       (_obj-setattr self name value))
  (def --str-- (self) ()
       "" "<class 'object'>")
  (def --repr-- (self) ()
       "" "<class 'object'>")
  )
