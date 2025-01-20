(define (if-program condition if-true if-false)
  `(if ,condition
      ,if-true
      ,if-false))

(define (square n) (* n n))

;scm> (pow-expr 2 0)
;1
;scm> (pow-expr 2 1)
;(* 2 1)
;scm> (pow-expr 2 5)
;(* 2 (square (square (* 2 1))))
;scm> (pow-expr 2 15)
;(* 2 (square (* 2 (square (* 2 (square (* 2 1)))))))
;scm> (pow-expr 2 16)
;(square (square (square (square (* 2 1)))))
;scm> (eval (pow-expr 2 16))
;65536
(define (pow-expr base exp) 
  (if (= exp 0)
      1
      (if (= exp 1)
          `(* ,base 1)
          (if (even? exp)
              `(square ,(pow-expr base (/ exp 2)))
              `(* ,base ,(pow-expr base (- exp 1)))))))

(define-macro (repeat n expr)
  `(repeated-call ,n (lambda () ,expr)))

; Call zero-argument procedure f n times and return the final result.
(define (repeated-call n f)
  (if (= n 1)
      (f)
      (begin (f)
             (repeated-call (- n 1) f))))
