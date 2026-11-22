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
