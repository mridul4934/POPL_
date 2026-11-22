# P1 Report (Group 72)

## P1.b: number of solutions for clues 1 to 8

```
$ swipl -q -f 72/code/72_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
3
```

**N = 3.** Out of the 24 × 24 × 24 = 13,824 possible assignments, three satisfy clues 1 to 8:

| # | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| A | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| B | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| C | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

`main/0` prints A, the first one found.

## What this tells us about the puzzle

The puzzle as given is **under-constrained**: the eight clues do not determine a unique answer,
so it is not a well-posed logic puzzle.

Some facts are forced in every solution:

- Ben is always (development, javascript, web).
- The research person always uses C++ and prefers data.
- Testing always goes with Python (clue 3), and design with Java (clue 5).

The freedom left is in two places:

1. **Which project goes with design/Java and which with testing/Python.** One gets AI and the
   other embedded. No clue links AI or embedded to those departments.
2. **Which of Alex, Carla and Dana gets which combination.** The clues about those three
   (2, 6, 7) only rule options *out*, so more than one arrangement survives.

Solutions A and C have **the same four (department, language, project) combinations**: going
from A to C, Alex, Carla and Dana rotate their three combinations while Ben keeps his. Only B
pairs AI with testing/Python. So the three solutions contain only **2 distinct sets** of
combinations.

This matters for P1.c: a ninth clue that may refer to friends only through attribute values
(not by name) cannot tell A and C apart, so the only solution such a clue can keep is **B**.

## P1.c: repair with a ninth clue

```prolog
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Sol) :-
    memberchk(p(_, Dept, _, 'AI'), Sol),
    Dept == testing.
```

The clue names no friend; it picks out the AI fan by attribute value, as clue 5 does with Java.
It is true in solution B (the AI fan, Carla, works in testing) and false in A and C (the AI fan
works in design). With it:

```
$ swipl -q -f 72/code/72_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), print(N), nl" -t halt
1
```

The unique solution is B: Alex = (design, java, embedded), Ben = (development, javascript, web),
Carla = (testing, python, AI), Dana = (research, c++, data).
