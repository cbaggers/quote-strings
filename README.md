# quote-strings

Allows you to use the unquote syntax (from backquote) inside strings

    ;; With these vars
    > (defvar test 1)
    > (defvar test2 '(1 2 3))

    ;; these are equivilent
    > (format nil "something: ~a" test)
    "something: 1"
    > #"something: ,test1"
    "something: 1"

    ;; as are these :)
    > (format nil "somethings: ~{~a~^ ~}" test2)
    "somethings: 1 2 3"
    > #"somethings: ,@test2"
    "somethings: 1 2 3"

Seems handy