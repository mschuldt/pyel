;; experimental object system

(defconst obj-instance-symbol 'pyel-obj)
(defconst obj-class-symbol 'pyel-class)

(set (defvar special-method-names nil
  "alist of special method names and index pairs")
     nil)

(defun is-special-method (name)
  "Return non-nil if NAME starts and ends with two dashes
The Value is actually the NAME without the dashes
NAME can be a symbol or a string, return type will match"
  (let* ((sym (symbolp name))
	 (name (if sym (symbol-name name) name)))
    (if (string-match "--\\(.+\\)--" name)
	(if sym (intern (match-string 1 name))
	  (match-string 1 name))
      nil)))

;;Create an alist of all slot name index pairs.
;;Indexes are also globally defined
;;ex: The index of special method '--M--' will be set to the variable 'M-index'
(set
 (defvar object-slot-indexes nil 
   "alist of all slot names and corresponding indexes")
 (let ((n -1) m)
   (mapcar (lambda (x)
	     (setq n (setq n (1+ n)))
	     (if (setq m (is-special-method x))
		 (progn (push (cons x n) special-method-names)
			(set (intern (format "%s-index" m)) n))
	       (set x n))
	     (cons x n))
	   
	   '(obj-symbol-index
	     obj-dict-index
	     obj-bases-index
	     obj-base-index
	     obj-class-index
	     --getattribute--
	     --setattr--
	     --getattr--
	     --init--
	     --str--
	     --repr--
	     --call--
	     --get--
	     --set--
	     ))))

(defconst py-class-vector-length (length object-slot-indexes))

(defvar setter-functions '(setq pset py-set pyel-set)
  "list of symbols of function that can bind values
The second element of the list must be the symbol to be bound")

(defvar object-indexes nil "list of variables refer to object array indexes
These names will be set globally to their index in this list")

(defun make-empty-class ()
  (let ((v (make-vector py-class-vector-length nil)))
    (aset v 0 obj-class-symbol)
    (aset v obj-dict-index (make-hash-table :test 'equal))
    v))

(defun make-empty-instance ()
  (let ((v (make-vector py-class-vector-length nil)))
    (aset v 0 obj-instance-symbol)
    (aset v obj-dict-index (make-hash-table :test 'equal))
    v))

(defmacro define-class (name bases &rest attributes)
  (let* ((new (make-empty-class))
	 (in-function-p (if (member '__defined-in-function-body bases)
			    (progn
			      (setq bases
				    (remove '__defined-in-function-body bases))
			      t)
			  nil))
	 (bases (if (eq name 'object)
		    nil
		  (or bases '(object)))) ;;everything inherits from object
	 (bases (list-to-vector bases)) ;;Python keeps the bases in a tuple
	 (doc (if (eq (type-of (car attributes)) 'string)
		  (pop attributes) nil))
	 class-variables
	 methods non-method)

    (when (eq name 'object) ;;give the first one some help...
      (aset new setattr-index 
	    (list (list (lambda (self attr value)
			  (_obj-setattr self attr value))))))

    (if (not (eq bases []))
	(let ((base (aref bases 0)))
	  ;;TODO: proper MRO -- currently just picking the first class
	  
	  (aset new setattr-index (aref base setattr-index))
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
    (let ((dict (aref new obj-dict-index)))
      (mapc (lambda (x) (puthash (car x) (cdr x) dict))
	    (append methods class-variables)))
    
    (setattr new --name-- (symbol-name name))

    (setattr new --doc-- doc)

    (let ((base (unless (eq bases []) (aref bases 0) nil))) ;;?
      (setattr new --base-- base)
      (aset new obj-base-index base))

    (setattr new --bases-- bases)
    (aset new obj-bases-index bases)
    
    (if in-function-p
	;;we cannnot use defun because the effect is global
	;;so we assign a lambda function instead, Usually
	;;the class vector is assigned to the name, now it 
	;;will be stored as a property of the name symbol 
	`(progn (put ',name 'pyel-class-def ,new)
		(setq ,name (lambda (&rest args)
			      ;;NOTE: `getattr-1' and `setattr-1' both assume that
			      ;;that this lambda will be in this form. If it
			      ;;is changed, they must be changed as well.
			      (obj-make-instance ,new
						 args))))
      `(progn (setq ,name ',new)
	      (defun ,name (&rest args)
		(obj-make-instance ,name args))))))

(defun py-append-list (list thing)
  "add THING to the end of LIST"
  (while (not (null (cdr list)))
    (setq list (cdr list)))
  (setcdr list (list thing)))

(defun obj-make-instance (class args)
  (let ((new (make-empty-instance)))

    ;;each instance has its own reference to the getter and setter methods
    ;;for faster lookup
    ;;This must also be done before any calls to `setattr'
    (aset new setattr-index (aref (setq _x class) setattr-index))
    (aset new getattribute-index (aref class getattribute-index))
    
    (dolist (special special-method-names)
      (let* ((class-ref (aref class (cdr special)))
	     (instance-ref (list (car (car class-ref)))))
	(when class-ref
	  (py-append-list class-ref instance-ref)
	  (aset new (cdr special) (list instance-ref)))))
    
    (aset new obj-class-index class)
    ;;will eventually be fully replaced with obj-class-index
    (aset new obj-bases-index (vector class))
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
	`(_getattr-special-explicit ,object ',attr)
      `(getattr-1 ,object ',attr))))

(defun getattr-1 (object attr)
  "lookup ATTR in OBJECT. Presumes ATTR is not a special method.
if it is not call OBJECT's --getattr-- method if defined"
  ;;in the case that OBJECT is a class, it will be a lambda function
  ;;if it was defined in a function (because defun has global effect)
  ;;here the actual class vector is retrieved from that lambda function
  (if (functionp object)
      (setq object (nth 1 (nth 2 object))))
  (condition-case nil
      (funcall (caar (aref object getattribute-index)) object attr)  ;;__getattribute__
    (AttributeError
     (let ((get-attr (caar (aref object getattr-index))))
       (if get-attr
	   (funcall get-attr object attr) ;;__getattr__
	 (signal 'AttributeError nil)
	 )))))

(setq pyel-none '__pyel-none__)

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
	 (if (eq (setq val (gethash attr (aref obj obj-dict-index) pyel-none))
		 pyel-none)
	     (_find-non-data-descriptor (aref (aref obj obj-bases-index) 0) obj attr)  
	   val
	   ))))))

(defun _find-data-descriptor (class object name)
  "return the value of the data descriptor NAME if found, else raise error"
  
  (let ((val (gethash name (aref class obj-dict-index))))
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
  (let ((val (gethash name (aref object obj-dict-index))))
    (if (not val)
	;;data descriptor not found, now check the bases
	(let* ((bases (aref object obj-bases-index))
	       (nbases (length bases))
	       (i 0)
	       done)
	  (if (> nbases 0)
	      (while (not done)
		(setq done (condition-case nil
			       (progn (setq val
					    (_find-attr (aref bases i)
							object name))
				      t)
			     (AttributeError nil)))

		(setq i (1+ i))
		(if (and (not done)
			 (>= i nbases)) (signal 'AttributeError nil))))))
    (if val
	(if (descriptor-p val) 
	    (call-method val __get__ object object)
	  val)
      (signal 'AttributeError nil))))

(defun _find-non-data-descriptor (class object name)
  "search for the non-data descriptor or plan attribute NAME
if it is a descriptor, return its value"
  (let ((val (gethash name (aref class obj-dict-index))))
    
    (if (not val)
	;;attr not found, now check the bases
	(let* ((bases (aref class obj-bases-index))
	       (nbases (length bases))
	       (i 0)
	       done)
	  (if (> nbases 0)
	      (while (not done)
		(setq done
		      (condition-case nil
			  (progn (setq val (_find-non-data-descriptor (aref bases i) object name))
				 t)
			(AttributeError nil)))

		(setq i (1+ i))
		(if (and (not done)
			 (>= i nbases)) (signal 'AttributeError nil))))))

    
    (if val
	;;found the attr, now check if it is a data descriptor or method
	(cond ((functionp val)
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
    `(lambda ,args ;;note: if this changes, `bound-method-p' must be updated
       (funcall ,method ,object ,@args))))

(defmacro bound-method-p (object)
  `(condition-case nil
       (let ((obj ,object))
	 (and (eq (car obj) 'lambda)
	      (= (length obj) 3)
	      (py-object-p (third (third obj)))))
     (error nil)))

(defmacro py-class-p (thing)
  `(condition-case nil
       (let ((thing ,thing))
	 (if (consp thing)
	     (setq thing (nth 1 (nth 2 thing))))
	 (eq (aref thing obj-symbol-index) obj-class-symbol))
     (error nil)))

(defmacro py-instance-p (thing)
  `(condition-case nil
       (let ((thing ,thing))
	 (if (consp thing)
	     (setq thing (nth 1 (nth 2 thing))))
	 (eq (aref thing obj-symbol-index) obj-instance-symbol))
     (error nil)))
  
(defmacro py-object-p (thing)
  `(condition-case nil
       (let ((thing ,thing))
	 (if (consp thing)
	     (setq thing (nth 1 (nth 2 thing))))
	 (or (eq (aref thing obj-symbol-index) obj-instance-symbol)
	     (eq (aref thing obj-symbol-index) obj-class-symbol)))
     (error nil)))

(defun _getattr-special-explicit (object attr)
  (condition-case nil
      (getattr-1 object attr)
    (AttributeError
     (let ((index (cdr (assoc attr special-method-names))))
       (if index
	   (let ((val (_getattr-special-implicit object index)))
	     (cond ((functionp val)
		    (bind-method object val))
		   ((non-data-descriptor-p val)
		    (call-method val __get__ class object))
		   (t val)))
	 (signal 'AttributeError nil))))))

(defun _getattr-special-implicit (object method-index)
  "get a special method of OBJECT indexed by METHOD-INDEX"
  (let ((method (caar (aref object method-index))))
    (or method
	(let* ((bases (if (eq (aref object obj-symbol-index)
			      obj-instance-symbol)
			  (vector (aref object obj-class-index))
			  (aref object obj-bases-index)))
	       (nbases (length bases))
	       (i 0))
	  (while (not method) ;;TODO: proper MRO
	    (setq method (_getattr-special-implicit (aref bases i) method-index))
	    (setq i (1+ i))
	    (if (and (not method)
		     (>= i nbases)) (signal 'AttributeError nil)))
	  method)
	(signal 'AttributeError nil))
    ;;TODO: inheritance
    ))

(defmacro call-method (object method &rest args)
  ;;'bind' method and call it
  (let ((special (assoc method special-method-names)))
    (if special
	`(funcall (_getattr-special-implicit ,object ,(cdr special)) ,object ,@args)
      
      `(funcall (getattr-1 ,object ',method)
		,@args))))

(defmacro setattr (obj attr value)
  `(setattr-1 ,obj ',(if (stringp attr) (intern attr) attr) ,value))

(defun setattr-1 (obj attr value)
  (if (functionp obj) ;;explanation in `getattr-1'
      (setq obj (nth 1 (nth 2 obj))))
  (funcall (caar (aref obj setattr-index)) obj attr value))

(defun _obj-setattr (obj attr value)
  ;;TODO: if attr is a data-descriptor, use that to set it
  (puthash attr value (aref obj obj-dict-index))
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

(defmacro pyel-def-error (name)
  `(progn
     (put ',name 'error-conditions '(error ,name))
     (put ',name 'error-message ,(concat "Error: " (symbol-name name)))))

(pyel-def-error AttributeError)
(pyel-def-error TypeError)

(define-class object ()
  "The most base type"
  (def --init-- (self) ()
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
       (format (if (py-class-p self) "<class '%s'>" "<%s object at 0x18b071>")
	       (getattr self --name--)))
  )

(provide 'py-objects)
