#lang racket
;; Tests for S2 (72_q4.rkt).
;; Run from this folder:  racket test_q4.rkt
;; The solution file is loaded unchanged. print-insert-result is run with the
;; given text as standard input, and its printed output is compared exactly.

(require racket/runtime-path)
(define-runtime-path solution "../code/72_q4.rkt")

;; Loading the module must print nothing.
(define load-output
  (with-output-to-string (lambda () (dynamic-require solution #f))))
(define ns (module->namespace solution))

;; (run-with-input text) -> what print-insert-result prints when stdin is text.
(define (run-with-input text)
  (with-output-to-string
    (lambda ()
      (parameterize ([current-input-port (open-input-string text)])
        (eval '(print-insert-result) ns)))))

;; (call expr) -> the value of expr evaluated inside the solution.
(define (call expr) (eval expr ns))

(define passed 0)
(define failed 0)
(define (check name actual expected)
  (if (equal? actual expected)
      (set! passed (add1 passed))
      (begin
        (set! failed (add1 failed))
        (printf "FAIL ~a\n  expected: ~s\n  actual:   ~s\n" name
                (shorten expected) (shorten actual)))))
(define (shorten v)
  (define s (format "~s" v))
  (if (> (string-length s) 200) (string-append (substring s 0 200) "...") s))

;; Reference implementation for building expected results of large inputs.
;; It uses full Racket and is written differently from the solution.
(define (reference x lst n)
  (define inner (for/list ([e lst]) (if (list? e) (reference x e n) e)))
  (if (< (length lst) n) (cons x inner) inner))

(define (as-line v) (format "~a\n" v))

;; ---- File-level rules ----
(check "loading prints nothing" load-output "")

;; ---- The four examples from the assignment (stdin -> output) ----
(check "example 1" (run-with-input "42 ((1 2) (3 4 5) (6) ()) 3")
       "((42 1 2) (3 4 5) (42 6) (42))\n")
(check "example 2" (run-with-input "0 (((1) 2) (3) ((4 5 6) ())) 3")
       "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check "example 3" (run-with-input "7 () 3") "(7)\n")
(check "example 4" (run-with-input "7 () 0") "()\n")

;; ---- Input layout ----
(check "input over several lines" (run-with-input "42\n((1 2) (3 4 5) (6) ())\n3\n")
       "((42 1 2) (3 4 5) (42 6) (42))\n")

;; ---- n = 0: nothing has length < 0, so nothing changes ----
(check "n = 0 nested" (run-with-input "x ((1 2) () (3 (4))) 0") "((1 2) () (3 (4)))\n")

;; ---- n = 1: only empty lists get x ----
(check "n = 1 only empty lists" (run-with-input "x ((1 2) () (3 ()) ((()))) 1")
       "((1 2) (x) (3 (x)) (((x))))\n")
(check "n = 1 empty top level" (run-with-input "x () 1") "(x)\n")

;; ---- Empty sublists ----
(check "all empty sublists" (run-with-input "q (() () ()) 4") "(q (q) (q) (q))\n")
(check "top length equals n is not short" (run-with-input "q (() () ()) 3") "((q) (q) (q))\n")
(check "top shorter than n" (run-with-input "q (() ()) 3") "(q (q) (q))\n")
(check "nested empties" (run-with-input "q ((())) 2") "(q (q (q)))\n")

;; ---- Symbols as x and as elements ----
(check "symbol x and symbol elements" (run-with-input "z (a (b c) (d e f) g) 3")
       "(a (z b c) (d e f) g)\n")
(check "symbol x into number lists" (run-with-input "hi ((1) (2 3)) 3")
       "(hi (hi 1) (hi 2 3))\n")
(check "large n changes every list" (run-with-input "s (a (b (c))) 100")
       "(s a (s b (s c)))\n")

;; ---- Length is measured on the original list, before insertion ----
(check "length equal to n is not short" (run-with-input "x ((1) (2 3)) 2")
       "((x 1) (2 3))\n")
(check "outer length counts sublists, not their contents" (run-with-input "x ((1 2 3 4) 5) 3")
       "(x (1 2 3 4) 5)\n")

;; ---- Nesting depth 100 ----
(define (nest d) (if (= d 0) '(1) (list (nest (- d 1)))))
(define deep (nest 100))
(check "depth 100, every level short"
       (run-with-input (format "x ~a 2" deep))
       (as-line (reference 'x deep 2)))
(check "depth 100, nothing short"
       (run-with-input (format "x ~a 1" deep))
       (as-line deep))

;; ---- A list of 10,000 elements ----
(define long (range 1 10001))
(check "10,000 elements, top level short"
       (run-with-input (format "x ~a 10001" long))
       (as-line (cons 'x long)))
(check "10,000 elements, top level not short"
       (run-with-input (format "x ~a 10000" long))
       (as-line long))
(define long-of-lists (for/list ([i 10000]) (if (even? i) '() (list i))))
(check "10,000 sublists"
       (run-with-input (format "x ~a 2" long-of-lists))
       (as-line (reference 'x long-of-lists 2)))

;; ---- S2.b and S2.c pieces ----
(check "my-length" (call '(list (my-length '()) (my-length '(a (b c) ())))) '(0 3))
(check "my-length 10,000" (call `(my-length ',long)) 10000)
(check "my-map" (call '(my-map (lambda (e) (+ e 1)) '(1 2 3))) '(2 3 4))
(check "my-map empty" (call '(my-map (lambda (e) e) '())) '())
(check "make-inserter with another predicate"
       (call '((make-inserter 'k (lambda (len) (= len 2))) '((1 2) (3) (4 5) ())))
       '((k 1 2) (3) (k 4 5) ()))
(check "insert-if-short direct call"
       (call '(insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
       '((42 1 2) (3 4 5) (42 6) (42)))

;; ---- Run exactly as the grader does: append a call, pipe stdin to racket ----
(define (run-as-grader input)
  (define tmp (make-temporary-file "q4-~a.rkt"))
  (with-output-to-file tmp #:exists 'truncate
    (lambda ()
      (display (file->string solution))
      (newline)
      (displayln "(print-insert-result)")))
  (define out
    (with-output-to-string
      (lambda ()
        (parameterize ([current-input-port (open-input-string input)])
          (system* (find-executable-path "racket") tmp)))))
  (delete-file tmp)
  out)

(check "grader-style run" (run-as-grader "0 (((1) 2) (3) ((4 5 6) ())) 3")
       "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")

(printf "~a passed, ~a failed\n" passed failed)
(exit (if (= failed 0) 0 1))
