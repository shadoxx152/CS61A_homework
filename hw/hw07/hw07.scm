(define (square n) (* n n))

(define (pow base exp) (if (= exp 0)
  1
  (if (= (modulo exp 2) 1)
  (* base (square (pow base (/ (- exp 1) 2))))
  (square (pow base (/ exp 2))))))

(define (repeatedly-cube n x)
  (if (zero? n)
      x
      (let ((y (repeatedly-cube (- n 1) x)))
        (* y y y))))

;cSpell:disable
(define (cddr s) (cdr (cdr s)))

(define (cadr s) (car (cdr s)))

(define (caddr s) (car (cdr (cdr s))))
