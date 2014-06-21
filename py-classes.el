;;built-in classes

(require 'py-objects)
(require 'py-lib)

(pyel-def-error BaseException)
(pyel-def-error AttributeError)
(pyel-def-error TypeError)
(pyel-def-error StopIteration)
(pyel-def-error ValueError)
(pyel-def-error IndexError)

(define-class object ()
  "The most base type"
  (def --new-- (self &rest args) ()
       (obj-make-instance self args))
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

(define-class BaseException ()
  ;;TODO: these should be data descriptors
  (setq --cause-- nil)
  (setq --context-- nil)
  (setq --traceback-- nil)
  (setq args [])

  (def --init-- (self &rest args) ()
       (setattr self args (vconcat args)))
  (def --repr-- (self) ()
       (format "%s(%s)"
               (getattr self --name--)
               (mapconcat (lambda (x) (pyel-repr x))
                          (mapcar 'identity (getattr self args))  ", ")))
  (def --str-- (self) ()
       (format "(%s)"
               (mapconcat (lambda (x) (pyel-str x))
                          (mapcar 'identity (getattr self args)) ", "))))

;;TODO: these should inherit from the Exception class instead
(define-class AttributeError (BaseException))
(define-class TypeError (BaseException))
(define-class StopIteration (BaseException))
(define-class ValueError (BaseException))
(define-class IndexError (BaseException))

(provide 'py-classes)
