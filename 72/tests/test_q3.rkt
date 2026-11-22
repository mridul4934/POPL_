#lang racket
;; Tests for S1 (72_q3.rkt).
;; Run from this folder:  racket test_q3.rkt
;; The solution file is loaded unchanged; its definitions are reached through
;; the module's namespace, and printed output is captured and compared exactly.

(require racket/runtime-path)
(define-runtime-path solution "../code/72_q3.rkt")

;; Loading the module must print nothing.
(define load-output
  (with-output-to-string (lambda () (dynamic-require solution #f))))
(define ns (module->namespace solution))

;; (run expr) -> the exact text printed by evaluating expr inside the solution.
(define (run expr)
  (with-output-to-string (lambda () (eval expr ns))))

(define passed 0)
(define failed 0)
(define (check name actual expected)
  (if (equal? actual expected)
      (set! passed (add1 passed))
      (begin
        (set! failed (add1 failed))
        (printf "FAIL ~a\n  expected: ~s\n  actual:   ~s\n" name expected actual))))

;; Trees from the assignment.
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; Edge-case trees.
(define single '(9 () ()))
(define left-chain '(3 (2 (1 () ()) ()) ()))
(define right-chain '(1 () (2 () (3 () ()))))
(define symbols '(m (f (b () ()) ()) (t () (z () ()))))

;; (chain n side) -> a chain of n nodes n, n-1, ..., 1 going down one side.
(define (chain n side)
  (if (= n 0)
      '()
      (if (eq? side 'left)
          (list n (chain (- n 1) side) '())
          (list n '() (chain (- n 1) side)))))

;; (full d lo) -> a complete tree of depth d whose inorder is lo, lo+1, ...
(define (full d lo)
  (if (= d 0)
      '()
      (let ([half (- (expt 2 (- d 1)) 1)])
        (list (+ lo half) (full (- d 1) lo) (full (- d 1) (+ lo half 1))))))

(define (line lst) (format "~a\n" lst))
(define (lines . lsts) (apply string-append (map line lsts)))

;; ---- File-level rules ----
(check "loading prints nothing" load-output "")

;; ---- Examples from the assignment ----
(check "t1 print-inorder" (run `(print-inorder ',t1)) "(1 2 3 4 5 6 7)\n")
(check "t1 print-all-traversals" (run `(print-all-traversals ',t1))
       "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check "t1 print-height-and-leaves" (run `(print-height-and-leaves ',t1)) "(3 4)\n")

(check "t2 print-inorder" (run `(print-inorder ',t2)) "(1 2 3)\n")
(check "t2 print-all-traversals" (run `(print-all-traversals ',t2))
       "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check "t2 print-height-and-leaves" (run `(print-height-and-leaves ',t2)) "(3 1)\n")

(check "t3 print-inorder" (run `(print-inorder ',t3)) "(b a c)\n")
(check "t3 print-all-traversals" (run `(print-all-traversals ',t3))
       "(b a c)\n(a b c)\n(b c a)\n")
(check "t3 print-height-and-leaves" (run `(print-height-and-leaves ',t3)) "(2 2)\n")

(check "empty print-inorder" (run '(print-inorder '())) "()\n")
(check "empty print-all-traversals" (run '(print-all-traversals '())) "()\n()\n()\n")
(check "empty print-height-and-leaves" (run '(print-height-and-leaves '())) "(0 0)\n")

;; ---- Edge cases ----
(check "single node inorder" (run `(print-inorder ',single)) "(9)\n")
(check "single node traversals" (run `(print-all-traversals ',single)) "(9)\n(9)\n(9)\n")
(check "single node height/leaves" (run `(print-height-and-leaves ',single)) "(1 1)\n")

(check "left chain traversals" (run `(print-all-traversals ',left-chain))
       "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
(check "left chain height/leaves" (run `(print-height-and-leaves ',left-chain)) "(3 1)\n")

(check "right chain traversals" (run `(print-all-traversals ',right-chain))
       "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check "right chain height/leaves" (run `(print-height-and-leaves ',right-chain)) "(3 1)\n")

(check "mixed shape with symbols" (run `(print-all-traversals ',symbols))
       "(b f m t z)\n(m f b t z)\n(b f z t m)\n")
(check "mixed shape height/leaves" (run `(print-height-and-leaves ',symbols)) "(3 2)\n")

;; A node with only one child is not a leaf, even when the child has several leaves.
(define one-child-left '(1 (2 (3 () ()) (4 () ())) ()))
(define one-child-right '(1 () (2 (3 () ()) (4 () ()))))
(check "one-child root over two leaves (left)"
       (run `(print-height-and-leaves ',one-child-left)) "(3 2)\n")
(check "one-child root over two leaves (right)"
       (run `(print-height-and-leaves ',one-child-right)) "(3 2)\n")
(check "one-child root traversals"
       (run `(print-all-traversals ',one-child-left)) "(3 2 4 1)\n(1 2 3 4)\n(3 4 2 1)\n")

;; ---- Deep and large trees ----
(define deep-left (chain 10000 'left))
(define deep-right (chain 10000 'right))
(check "deep left chain inorder"
       (run `(print-inorder ',deep-left))
       (line (range 1 10001)))
(check "deep right chain preorder line"
       (cadr (string-split (run `(print-all-traversals ',deep-right)) "\n"))
       (format "~a" (range 10000 0 -1)))
(check "deep left chain height/leaves" (run `(print-height-and-leaves ',deep-left)) "(10000 1)\n")
(check "deep right chain height/leaves" (run `(print-height-and-leaves ',deep-right)) "(10000 1)\n")

(define big (full 12 1)) ; 4095 nodes, 2048 leaves
(check "complete tree inorder is sorted"
       (run `(print-inorder ',big))
       (line (range 1 4096)))
(check "complete tree height/leaves" (run `(print-height-and-leaves ',big)) "(12 2048)\n")

;; ---- Run exactly as the grader does: append calls to a copy and run racket ----
(define (run-as-grader calls)
  (define tmp (make-temporary-file "q3-~a.rkt"))
  (with-output-to-file tmp #:exists 'truncate
    (lambda ()
      (display (file->string solution))
      (newline)
      (for ([c calls]) (writeln c))))
  (define out (with-output-to-string
                (lambda () (system* (find-executable-path "racket") tmp))))
  (delete-file tmp)
  out)

(check "grader-style run"
       (run-as-grader (list `(define t1 ',t1)
                            '(print-inorder t1)
                            '(print-all-traversals t1)
                            '(print-height-and-leaves t1)))
       (lines '(1 2 3 4 5 6 7) '(1 2 3 4 5 6 7) '(4 2 1 3 6 5 7)
              '(1 3 2 5 7 6 4) '(3 4)))

(printf "~a passed, ~a failed\n" passed failed)
(exit (if (= failed 0) 0 1))
