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

;; Traversals. Each helper takes an accumulator acc and returns the values of
;; tree in the required order followed by acc. Filling the list from the right
;; (right subtree first) means every value is consed on once and no append is
;; needed, so each traversal is linear in the size of the tree.

;; (inorder-acc tree acc) -> list
;; Recursive reading: for (), the result is acc; for (v l r), it is the inorder
;; of l, then v, then the inorder of r, then acc.
(define (inorder-acc tree acc)
  (if (empty-tree? tree)
      acc
      (inorder-acc (node-left tree)
                   (cons (node-value tree)
                         (inorder-acc (node-right tree) acc)))))

;; (preorder-acc tree acc) -> list
;; Recursive reading: for (), the result is acc; for (v l r), it is v, then the
;; preorder of l, then the preorder of r, then acc.
(define (preorder-acc tree acc)
  (if (empty-tree? tree)
      acc
      (cons (node-value tree)
            (preorder-acc (node-left tree)
                          (preorder-acc (node-right tree) acc)))))

;; (postorder-acc tree acc) -> list
;; Recursive reading: for (), the result is acc; for (v l r), it is the
;; postorder of l, then the postorder of r, then v, then acc.
(define (postorder-acc tree acc)
  (if (empty-tree? tree)
      acc
      (postorder-acc (node-left tree)
                     (postorder-acc (node-right tree)
                                    (cons (node-value tree) acc)))))

;; (inorder tree) -> list of values: left subtree, node, right subtree.
(define (inorder tree) (inorder-acc tree '()))

;; (preorder tree) -> list of values: node, left subtree, right subtree.
(define (preorder tree) (preorder-acc tree '()))

;; (postorder tree) -> list of values: left subtree, right subtree, node.
(define (postorder tree) (postorder-acc tree '()))
