% Tests for P2 (72_q2.pl).
% Run from this folder:  swipl -q -g run_tests -t halt test_q2.pl

:- consult('../code/72_q2.pl').
:- use_module(library(plunit)).
:- use_module(library(aggregate)).

% Independent check used only in the tests: read an equation string back as a
% Prolog term and compare both sides numerically. (The solution itself never
% parses strings.) In SWI-Prolog, / on integers that divide exactly gives an
% integer, so exact equations compare equal.
holds_numerically(EqString) :-
    term_string(L = R, EqString),
    L =:= R.

:- begin_tests(p2_examples).

test(all_4253) :-
    all_equations([4,2,5,3], Es),
    Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
           "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"].

test(generate_4253_is_one_of_the_seven) :-
    all_equations([4,2,5,3], Es),
    generate_equation([4,2,5,3], E), !,
    memberchk(E, Es).

test(generate_234_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(all_234_empty) :-
    all_equations([2,3,4], []).

test(all_248) :-
    all_equations([2,4,8], ["2*4=8"]).

test(count_4253) :- count_equations([4,2,5,3], 7).
test(count_234)  :- count_equations([2,3,4], 0).
test(count_248)  :- count_equations([2,4,8], 1).

:- end_tests(p2_examples).

:- begin_tests(p2_printer).

% The parenthesis examples from the assignment, built as trees.
paren_example(bin(*, bin(+, num(4), num(2)), num(3)), "(4+2)*3").
paren_example(bin(+, num(4), bin(*, num(2), num(3))), "4+2*3").
paren_example(bin(*, bin(/, num(8), num(4)), num(2)), "8/4*2").
paren_example(bin(/, num(8), bin(*, num(4), num(2))), "8/(4*2)").
paren_example(bin(-, bin(-, num(1), num(2)), num(3)), "1-2-3").
paren_example(bin(-, num(1), bin(-, num(2), num(3))), "1-(2-3)").
paren_example(bin(+, num(1), bin(+, num(2), num(3))), "1+(2+3)").
paren_example(bin(+, bin(+, num(1), num(2)), num(3)), "1+2+3").
paren_example(num(42), "42").

test(paren_examples, [forall(paren_example(T, Expected))]) :-
    tree_string(T, S),
    S == Expected.

test(different_trees_different_strings) :-
    findall(S, (expr([1,2,3,4], T, _), tree_string(T, S)), Ss),
    length(Ss, N),
    sort(Ss, Unique),
    length(Unique, N).

:- end_tests(p2_printer).

:- begin_tests(p2_edge_cases).

test(empty_list_generate_fails, [fail]) :- generate_equation([], _).
test(empty_list_all)    :- all_equations([], []).
test(empty_list_count)  :- count_equations([], 0).

test(one_number_generate_fails, [fail]) :- generate_equation([5], _).
test(one_number_all)    :- all_equations([5], []).

test(two_equal_numbers) :- all_equations([7,7], ["7=7"]).
test(two_different_numbers) :- all_equations([7,8], []).

test(zeros_two) :- all_equations([0,0], ["0=0"]).

test(zeros_three) :-
    all_equations([0,0,0], Es),
    Es == ["0*0=0", "0+0=0", "0-0=0", "0=0*0", "0=0+0", "0=0-0"].

test(division_by_zero_rejected) :-
    all_equations([0,0,0], Es),
    \+ memberchk("0/0=0", Es),
    \+ memberchk("0=0/0", Es).

test(division_by_zero_inside_rejected) :-
    all_equations([6,0,0,6], Es),
    \+ ( member(E, Es), sub_string(E, _, _, _, "/0") ).

test(non_exact_division_rejected) :-
    % 7/2 would be 3 with integer division, but it is not exact.
    all_equations([7,2,3], Es),
    \+ memberchk("7/2=3", Es).

test(non_exact_inner_division_rejected) :-
    % (7/2)*2 = 7 only if 7/2 were allowed; (7*2)/2 = 7 is exact and valid.
    all_equations([7,2,2,7], Es),
    \+ memberchk("7/2*2=7", Es),
    memberchk("7*2/2=7", Es).

test(negative_intermediate_allowed) :-
    % 2-5 = -3 on the way, then -3+3 = 0.
    all_equations([2,5,3,0], Es),
    memberchk("2-5+3=0", Es).

test(negative_on_both_sides) :-
    all_equations([1,4,2,5], Es),
    memberchk("1-4=2-5", Es).

:- end_tests(p2_edge_cases).

:- begin_tests(p2_properties).

test(results_are_strings_without_spaces) :-
    all_equations([1,2,3,4,5], Es),
    Es \== [],
    forall(member(E, Es),
           ( string(E), \+ sub_string(E, _, _, _, " ") )).

test(every_equation_holds, [forall(member(L, [[4,2,5,3],[1,2,3,4,5],[6,3,2,1],[8,4,2,2,1]]))]) :-
    all_equations(L, Es),
    forall(member(E, Es), holds_numerically(E)).

test(exactly_one_equals_sign) :-
    all_equations([1,2,3,4,5], Es),
    forall(member(E, Es),
           ( split_string(E, "=", "", Parts), length(Parts, 2) )).

test(all_is_sorted_and_unique) :-
    all_equations([1,2,3,4,5,6], Es),
    sort(Es, Es).

test(all_equations_det, [true(Count == 1)]) :-
    aggregate_all(count, all_equations([4,2,5,3], _), Count).

test(count_matches_all) :-
    all_equations([1,2,3,4,5,6], Es),
    length(Es, N),
    count_equations([1,2,3,4,5,6], N).

test(generate_accepts_any_valid_bound_equation, [nondet]) :-
    generate_equation([4,2,5,3], "4=2+5-3").

test(seven_numbers_terminates) :-
    count_equations([1,2,3,4,5,6,7], N),
    N > 0.

:- end_tests(p2_properties).
