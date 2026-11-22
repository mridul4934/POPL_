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

%! prec(?Op, ?P) is nondet.
%  P is the precedence of operator Op: * and / bind tighter than + and -.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

%! tree_string(+Tree, -String) is det.
%  String is the canonical text of Tree, with no spaces.
%  Reading: a number is written in decimal; a binary node is its left
%  operand, its operator and its right operand, each operand wrapped in
%  parentheses when operand_needs_parens/3 says so.
tree_string(num(N), S) :-
    number_string(N, S).
tree_string(bin(Op, L, R), S) :-
    prec(Op, P),
    operand_string(L, left, P, LS),
    operand_string(R, right, P, RS),
    format(string(S), "~w~w~w", [LS, Op, RS]).

%! operand_string(+Tree, +Side, +ParentPrec, -String) is det.
%  String is the canonical text of operand Tree, in parentheses if it needs
%  them on this Side of a parent operator with precedence ParentPrec.
operand_string(T, Side, P, S) :-
    tree_string(T, S0),
    (   operand_needs_parens(T, Side, P)
    ->  format(string(S), "(~w)", [S0])
    ;   S = S0
    ).

%! operand_needs_parens(+Tree, +Side, +ParentPrec) is semidet.
%  A left operand needs parentheses only if its operator binds looser than
%  the parent's; a right operand also needs them when the precedence is
%  equal (operators are left-associative). A single number never needs them.
operand_needs_parens(bin(Op, _, _), left, P) :-
    prec(Op, Q), Q < P.
operand_needs_parens(bin(Op, _, _), right, P) :-
    prec(Op, Q), Q =< P.
