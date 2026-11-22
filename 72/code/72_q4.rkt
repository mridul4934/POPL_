#lang racket/base
;; CS F301 Assignment 2, Group 72
;; S2: Conditionally Insert into a Nested List

;; (my-length lst) -> number of top-level elements of lst.
;; Recursive reading: the length of () is 0; the length of (e . rest) is one
;; more than the length of rest. The named let carries the count so far in
;; count, which makes the loop tail recursive.
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))

;; (my-map f lst) -> list of (f e) for each top-level element e of lst, in order.
;; Recursive reading: mapping over () gives (); mapping over (e . rest) gives
;; (f e) in front of the mapping over rest.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst)) (my-map f (cdr lst)))))

;; (is-list? e) -> #t when element e is a list (empty or not), #f for an atom.
;; There are no dotted pairs, so a pair is always a non-empty list.
(define (is-list? e)
  (or (null? e) (pair? e)))

;; S2.c
;; (make-inserter x len-ok?) -> a function of one list that inserts x at the
;; front of every list, at every level of nesting (the given list included),
;; whose original length satisfies len-ok?.
;; Recursive reading of the returned function: first rebuild each element
;; (sublists recursively, atoms unchanged); then put x in front if the list's
;; own original length satisfies len-ok?. letrec lets the function call itself.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((rebuilt (my-map (lambda (e)
                                       (if (is-list? e)
                                           (insert e)
                                           e))
                                     lst)))
                (if (len-ok? (my-length lst))
                    (cons x rebuilt)
                    rebuilt)))))
    insert))

;; S2.b, defined through make-inserter
;; (insert-if-short x lst n) -> lst with x inserted at the front of every
;; list, at every level of nesting, whose original length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; S2.a
;; (print-insert-result) -> reads x, lst and n from standard input, in that
;; order, and prints (insert-if-short x lst n) followed by a newline.
;; let* makes the three reads happen one after another in the required order.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
