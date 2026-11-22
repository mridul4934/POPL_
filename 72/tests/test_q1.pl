% Tests for P1 (72_q1.pl).
% Run from this folder:  swipl -q -g run_tests -t halt test_q1.pl

:- consult('../code/72_q1.pl').
:- use_module(library(plunit)).

% The format example from the assignment (not the answer): first two friends.
example_partial([p('Alex', design, java, web), p('Ben', testing, python, data)]).

% The three solutions of clues 1-8, listed by enumerating solution/1 and checked by hand against the clues.
sol_a([p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
       p('Carla',research,'c++',data), p('Dana',testing,python,embedded)]).
sol_b([p('Alex',design,java,embedded), p('Ben',development,javascript,web),
       p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)]).
sol_c([p('Alex',testing,python,embedded), p('Ben',development,javascript,web),
       p('Carla',design,java,'AI'), p('Dana',research,'c++',data)]).

:- begin_tests(p1_generator).

test(all_candidates) :-
    aggregate_all(count, solution(_), 13824).

test(order_and_names) :-
    solution(S), !,
    S = [p('Alex',_,_,_), p('Ben',_,_,_), p('Carla',_,_,_), p('Dana',_,_,_)].

test(example_shape_is_valid_prefix) :-
    example_partial(Prefix),
    solution(S), append(Prefix, _, S), !.

:- end_tests(p1_generator).

:- begin_tests(p1_clues).

% Every one of the three solutions satisfies each of clues 1-8.
test(sol_a_satisfies_1_to_8) :- sol_a(S), satisfies([1,2,3,4,5,6,7,8], S).
test(sol_b_satisfies_1_to_8) :- sol_b(S), satisfies([1,2,3,4,5,6,7,8], S).
test(sol_c_satisfies_1_to_8) :- sol_c(S), satisfies([1,2,3,4,5,6,7,8], S).

% Near misses: near_miss(K, S) satisfies every clue 1-8 except clue K.
% Each shows that clue K is needed and that clue/2 rejects a break of it.
near_miss(1, [p('Alex',design,java,embedded), p('Ben',development,javascript,web),
              p('Carla',research,'c++',data), p('Dana',testing,python,'AI')]).
near_miss(2, [p('Alex',research,'c++',data), p('Ben',development,javascript,web),
              p('Carla',design,java,'AI'), p('Dana',testing,python,embedded)]).
near_miss(3, [p('Alex',research,python,data), p('Ben',development,'c++',web),
              p('Carla',design,java,'AI'), p('Dana',testing,javascript,embedded)]).
near_miss(4, [p('Alex',design,java,'AI'), p('Ben',development,javascript,embedded),
              p('Carla',research,'c++',data), p('Dana',testing,python,web)]).
near_miss(5, [p('Alex',research,java,data), p('Ben',development,'c++',web),
              p('Carla',design,javascript,'AI'), p('Dana',testing,python,embedded)]).
near_miss(6, [p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
              p('Carla',testing,python,embedded), p('Dana',research,'c++',data)]).
near_miss(7, [p('Alex',testing,python,'AI'), p('Ben',development,javascript,web),
              p('Carla',research,'c++',data), p('Dana',design,java,embedded)]).
near_miss(8, [p('Alex',research,javascript,embedded), p('Ben',development,'c++',web),
              p('Carla',design,java,'AI'), p('Dana',testing,python,data)]).

test(near_miss_breaks_only_its_clue, [forall(between(1, 8, K))]) :-
    near_miss(K, S),
    \+ clue(K, S),
    numlist(1, 8, All), subtract(All, [K], Others),
    satisfies(Others, S).

% Clue 9 keeps B and rejects A and C.
test(clue9_true_on_b)      :- sol_b(S), clue(9, S).
test(clue9_false_on_a, [fail]) :- sol_a(S), clue(9, S).
test(clue9_false_on_c, [fail]) :- sol_c(S), clue(9, S).

test(unknown_clue_number, [fail]) :- sol_a(S), clue(42, S).

% Clue 9 refers to friends only through attribute values: giving the same
% rows to different names never changes its result.
rename([p(_,D1,L1,P1), p(_,D2,L2,P2), p(_,D3,L3,P3), p(_,D4,L4,P4)], [N1,N2,N3,N4],
       [p(N1,D1,L1,P1), p(N2,D2,L2,P2), p(N3,D3,L3,P3), p(N4,D4,L4,P4)]).
test(clue9_ignores_names, [forall(member(Which, [sol_a, sol_b, sol_c]))]) :-
    call(Which, S),
    ( clue(9, S) -> Expected = true ; Expected = false ),
    forall(permutation(['Alex','Ben','Carla','Dana'], Names),
           ( rename(S, Names, R),
             ( clue(9, R) -> Got = true ; Got = false ),
             Got == Expected )).

:- end_tests(p1_clues).

:- begin_tests(p1_count).

test(clues_1_to_8)  :- count_solutions([1,2,3,4,5,6,7,8], 3).
test(clues_1_to_9)  :- count_solutions([1,2,3,4,5,6,7,8,9], 1).
test(no_clues)      :- count_solutions([], 13824).
test(order_does_not_matter) :- count_solutions([8,7,6,5,4,3,2,1], 3).
test(duplicates_ignored)    :- count_solutions([1,1,2,3,4,5,6,7,8], 3).
test(single_clue_4)         :- count_solutions([4], 2592).
test(unknown_clue_counts_zero) :- count_solutions([99], 0).
test(clue_9_alone)          :- count_solutions([9], 3456).

test(found_set_is_a_b_c) :-
    findall(S, (solution(S), satisfies([1,2,3,4,5,6,7,8], S)), Found),
    sol_a(A), sol_b(B), sol_c(C),
    msort(Found, Sorted), msort([A, B, C], Sorted).

test(unique_after_repair) :-
    findall(S, (solution(S), satisfies([1,2,3,4,5,6,7,8,9], S)), [Only]),
    sol_b(Only).

:- end_tests(p1_count).

:- begin_tests(p1_main).

test(main_output_format) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "", Lines),
    Lines = [L1, L2, L3, L4, ""],
    sub_string(L1, 0, _, _, "Alex = ["),
    sub_string(L2, 0, _, _, "Ben = ["),
    sub_string(L3, 0, _, _, "Carla = ["),
    sub_string(L4, 0, _, _, "Dana = [").

% The exact text main may print: one of the three solutions of clues 1-8,
% written out literally so the test does not depend on print_friend/1.
expected_main("Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n").
expected_main("Alex = [design, java, embedded]\nBen = [development, javascript, web]\nCarla = [testing, python, AI]\nDana = [research, c++, data]\n").
expected_main("Alex = [testing, python, embedded]\nBen = [development, javascript, web]\nCarla = [design, java, AI]\nDana = [research, c++, data]\n").

test(main_prints_exactly_a_solution) :-
    with_output_to(string(Out), main),
    once(expected_main(Out)).

test(main_succeeds_once, [true(N == 1)]) :-
    aggregate_all(count, with_output_to(string(_), main), N).

:- end_tests(p1_main).
