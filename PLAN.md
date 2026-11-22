# Team plan: CS F301 Assignment 2 (Group 72)

Deadline: 22 Nov 2026, 24:00. Everyone commits to `main`, one person at a time.
Run `git pull` before you start and `git push` after every commit.

## Who does what

| Order | Person | Work | Files |
|---|---|---|---|
| 1 | Mridul | Repo layout, `prolog-dev` skill, **P1** (department puzzle) and its report | `72/skills/prolog-dev/SKILL.md`, `72/code/72_q1.pl`, `72/tests/test_q1.pl`, `72/prompts/P1.md`, `72/P1_REPORT.md` |
| 2 | Pratyush | **P2** (arithmetic equation) | `72/code/72_q2.pl`, `72/tests/test_q2.pl`, `72/prompts/P2.md` |
| 3 | Raghav | `scheme-dev` skill, **S1** (tree traversals) | `72/skills/scheme-dev/SKILL.md`, `72/code/72_q3.rkt`, `72/tests/test_q3.rkt`, `72/prompts/S1.md` |
| 4 | Vedant | **S2** (conditional insert), final check of the whole repo | `72/code/72_q4.rkt`, `72/tests/test_q4.rkt`, `72/prompts/S2.md` |

## Rules everyone must follow

**Process (marked under Git/process and individual commits)**
- **One prompt = one unit of work:** one predicate, one function, one test file, or one review.
  Never ask the AI for a whole problem.
- **Commit after each unit** with a message naming it, e.g. `P2: add expr/3 generator`.
  The history should show the problem being solved piece by piece.
- **Copy every prompt word for word** into `72/prompts/<problem>.md`. Only the prompts, in order.
- **Commit under your own GitHub account:** set `git config user.name` and `git config user.email`
  to your own name and the email verified on your GitHub account before your first commit.
- Sharing code, prompts or skill files with another group is an integrity violation.

**Code (marked by the grader)**
- File names use our group ID: `72_q1.pl`, `72_q2.pl`, `72_q3.rkt`, `72_q4.rkt`.
- Code files contain **only definitions**: no top-level calls, nothing printed on load.
- Prolog: SWI-Prolog 9.x; no `halt`, no `initialization` directive, no `assert`/`retract`,
  no `b_setval`/`nb_setval`; only the libraries `lists`, `apply`, `yall`, `aggregate`.
- Racket: Racket 8.x; first line `#lang racket/base`; only the built-ins listed in the assignment
  (no `set!`, strings, vectors, loops, `length`, `append`, `reverse`, `map`, `filter`, `member`, …).
- Tests go in `72/tests/`, one file per problem: every example from the assignment plus edge cases.

**Viva (individual)**
- Be able to explain every line of your own problem, and run its tests yourself.

## How to run

```bash
swipl -q -f 72/code/72_q1.pl -g main -t halt
swipl -q -f 72/code/72_q2.pl -g "all_equations([4,2,5,3], Es), print(Es)" -t halt
racket 72/code/72_q3.rkt
racket 72/code/72_q4.rkt
```

## Final checklist (Vedant)

- [ ] Layout matches section 4: `code/`, `tests/`, `skills/`, `prompts/`, `P1_REPORT.md`.
- [ ] `skills/prolog-dev/SKILL.md` and `skills/scheme-dev/SKILL.md` exist.
- [ ] `prompts/P1.md`, `P2.md`, `S1.md`, `S2.md` exist and are word for word.
- [ ] Every test file runs and passes.
- [ ] Each member has their own commits.
