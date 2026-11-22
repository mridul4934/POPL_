---
name: prolog-dev
description: Conventions, allowed libraries, forbidden constructs, run and test commands, self-review checklist and known AI failure modes for writing SWI-Prolog 9.x solutions in the CS F301 Assignment 2 (group 72 files 72_q1.pl and 72_q2.pl).
---

# Prolog development (SWI-Prolog 9.x)

## Scope of one request
Produce exactly one unit per request: one predicate (with the small helpers it needs),
one test file, or one review. Never write a whole problem at once.

## Language and environment
- SWI-Prolog 9.x. The grader runs:
  - `swipl -q -f 72_qN.pl -g main -t halt`
  - `swipl -q -f 72_qN.pl -g "<goal>" -t halt`
- A solution file contains only `use_module` directives for allowed libraries and clause
  definitions. Nothing is printed when it loads.

## Allowed libraries
`lists`, `apply`, `yall`, `aggregate`, loaded with `:- use_module(library(Name)).`
Built-in predicates (`format/2,3`, `findall/3`, `forall/2`, `memberchk/2`, `sort/2`,
`msort/2`, `number_string/2`, arithmetic, ...) are fine.

## Forbidden constructs
- `assert`, `asserta`, `assertz`, `retract`, `retractall`
- Global variables: `b_setval`, `b_getval`, `nb_setval`, `nb_getval`
- `halt/0,1` anywhere in the file
- Any `:- initialization(...)` directive
- Any library other than the four above (including `clpfd`, `dcg/basics`, `strings`, `error`)
- Printing anything not asked for (debug `write`, `print`, `format` to the screen)
- P1: hard-coding the answer instead of deriving it from the clues
- P2: building an equation string and parsing it back into a term to evaluate it
  (`term_string/2`, `term_to_atom/2`, `read_term/2` on the string)

## Coding conventions
- Predicate names in `snake_case`; variables in `CamelCase` (`Dept`, `Lang`, `Sol`).
- Every predicate has a header comment:
  - `%! name(+In, -Out) is det/semidet/nondet.` with argument modes.
  - A **declarative reading**: one or two lines saying when the predicate is true,
    e.g. "`clue(5, Sol)` holds when the Java fan in Sol works in design."
- Atoms match the specification exactly, quoted where needed: `'Alex'`, `'c++'`, `'AI'`.
- Use `==` and `\==` only on terms that are already bound; use `memberchk/2` when the
  matching element is unique and `member/2` only when backtracking is wanted.
- Count with `aggregate_all(count, Goal, N)` or `findall/3` + `length/2`.
- Output only with `format/2`, exactly in the specified layout, each line ending in `~n`.
- Build strings with `format(string(S), ...)`, never by parsing.

## How to run and test
- Run a goal: `swipl -q -f 72/code/72_q1.pl -g main -t halt`
- Tests live in `72/tests/test_qN.pl`. They load the solution with
  `:- consult('../code/72_qN.pl').` and use `plunit` (only in the test file, never in the solution).
- Run the tests from `72/tests/`: `swipl -g run_tests -t halt test_qN.pl`
- Tests include every example from the assignment, edge cases, and at least one check that
  would fail if the code were wrong (a near miss), not only checks of correct answers.

## Self-review checklist (apply before answering)
1. The file loads with no warnings (singleton variables, discontiguous clauses, unknown procedures).
2. Only allowed libraries are loaded; none of the forbidden constructs appear.
3. Atoms match the spec exactly, including quoting and case.
4. The predicate terminates in every mode the spec uses, and fails (not errors) when it should fail.
5. Printed output is exactly the required format, with nothing extra; non-printing predicates print nothing.
6. Results are derived, not hard-coded.
7. Each predicate has its mode comment and declarative reading.
8. The claim was checked by actually running it, not by reasoning alone.

## Known AI failure modes in Prolog
- Unquoted atoms that need quotes: `Alex` becomes a variable, `c++` is a syntax error.
- Using `\=`, `\==` or `dif`-style tests on unbound variables, so a constraint passes too early.
- Leaving choice points, so `main` prints several solutions or a count is doubled.
- Using `print/1` or `writeq/1`, which add quotes (`'AI'`) to output that should be plain.
- Adding `:- initialization(main).` or `halt.` at the end of the file.
- Using `/` and getting a float or rational instead of exact integer division; forgetting to
  check the divisor is non-zero and the remainder is zero.
- Calling `nth0`/`nth1` or `sub_string` with arguments in the wrong order.
- Inventing library predicates that do not exist in SWI-Prolog 9, or using ones from
  libraries not on the allowed list.
- Writing a test that checks the code against itself (e.g. comparing `main`'s output with a
  helper from the same file) instead of against literal expected values.
