% CS F301 Assignment 2, Group 72
% P2: Form a Valid Arithmetic Equation

:- use_module(library(lists)).

% Expression trees:
%   num(N)          a single number N
%   bin(Op, L, R)   L Op R, where Op is one of + - * /

%! expr(+Nums, -Tree, -Value) is nondet.
%  Tree is an expression over the non-empty list Nums, using every number
%  once and in order, and Value is its integer value. Every division in
%  Tree has a non-zero divisor and no remainder.
%  Reading: a single number is an expression; otherwise split Nums into a
%  non-empty left part and a non-empty right part, build an expression on
%  each, and join them with one operator.
expr([N], num(N), N).
expr(Nums, bin(Op, L, R), Value) :-
    append(LeftNums, RightNums, Nums),
    LeftNums = [_|_],
    RightNums = [_|_],
    expr(LeftNums, L, LV),
    expr(RightNums, R, RV),
    apply_op(Op, LV, RV, Value).

%! apply_op(?Op, +A, +B, -V) is nondet.
%  V is A Op B. Division succeeds only if B is non-zero and B divides A exactly.
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :- B =\= 0, A rem B =:= 0, V is A // B.
