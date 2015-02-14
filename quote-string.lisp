;;;; quote-string.lisp

(in-package #:quote-string)

;;; "quote-string" goes here. Hacks and glory await!

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun make-string-section (part)
  (cond ((stringp part) part)
        ((eq (first part) :insert) "~a")
        ((eq (first part) :splice) "~{~a~^ ~}")))

(defun grab-var-symbs (part)
  (when (not (stringp part))
    (second part)))

(defun reconstruct-string (parts)
  (format nil "~{~a~}" 
          (mapcar #'make-string-section parts)))

(defun collate-input (input &optional accum)
  (cond
    ((null input) (reverse accum))
    ((characterp (first input))      
     (let ((end (or (position-if (lambda (x) (not (characterp x))) input)
                    (length input))))
       (collate-input (subseq input end)
                      (cons (concatenate 'string (subseq input 0 end)) accum))))
    (t (collate-input (rest input)
                      (cons (first input) accum)))))

(defun extract-hash-string (stream)
  (loop :for char = (read-char stream t nil t)
     :while (and (characterp char) (char/= char #\"))
     :if (char= char #\,) :collect
     (progn 
       (if (char= (peek-char nil stream) #\@)
           (progn (read-char stream)
                  (list :splice (read stream t nil t)))
           (list :insert (read stream t nil t))))
     :else :collect char))

(defun quote-string-reader (stream subchar arg)
  (declare (ignore subchar arg))
  (let* ((body (extract-hash-string stream))
         (collated (collate-input body))
         (new-string (reconstruct-string collated))
         (vars (remove nil (mapcar #'grab-var-symbs collated))))
    `(format nil ,new-string ,@vars))

  (named-readtables:defreadtable quote-string
    (:merge :standard)
    (:dispatch-macro-char #\# #\" #'quote-string-reader)))


;;(named-readtables:in-readtable quote-string)
