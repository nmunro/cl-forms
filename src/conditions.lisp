(in-package #:cl-forms)

(define-condition csrf-error (error) 
  ((message :initarg :message :reader message)
   (form :initarg :form :reader form))
  (:report (lambda (condition stream) (format stream "~A for ~A" (message condition) (form condition)))))
