;;;; quote-string.asd

(asdf:defsystem #:quote-string
  :description "Describe quote-string here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:split-sequence #:named-readtables)
  :components ((:file "package")
               (:file "quote-string")))

