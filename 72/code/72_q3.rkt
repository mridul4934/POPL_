#lang racket/base
;; CS F301 Assignment 2, Group 72
;; S1: Binary Tree Traversals
;;
;; A binary tree is either the empty list (), or a three-element list
;; (value left right) where left and right are binary trees.

;; (empty-tree? tree) -> boolean
;; Recursive reading: not recursive; a tree is empty exactly when it is ().
(define (empty-tree? tree)
  (null? tree))

;; (node-value tree) -> number or symbol
;; The value stored at a non-empty node: the first element of (value left right).
(define (node-value tree)
  (car tree))

;; (node-left tree) -> tree
;; The left subtree of a non-empty node: the second element.
(define (node-left tree)
  (cadr tree))

;; (node-right tree) -> tree
;; The right subtree of a non-empty node: the third element.
(define (node-right tree)
  (caddr tree))

;; (leaf? tree) -> boolean
;; Recursive reading: not recursive; a tree is a leaf when it is a node whose
;; left and right subtrees are both empty. The empty tree is not a leaf.
(define (leaf? tree)
  (and (not (empty-tree? tree))
       (empty-tree? (node-left tree))
       (empty-tree? (node-right tree))))
