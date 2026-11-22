---
name: scheme-dev
description: Conventions, allowed built-ins, run and test commands, self-review checklist and known AI failure modes for writing Racket 8.x (#lang racket/base) solutions in the CS F301 assignment (files 72_q3.rkt, 72_q4.rkt).
---

# Scheme development (Racket 8.x, `#lang racket/base`)

## Scope of one request
Produce exactly one unit per request: one function (with its helpers), one test file, or one review.
Never write a whole problem at once.

## Language and environment
- Racket 8.x. Every solution file starts with the line `#lang racket/base`.
- The grader runs `racket 72_q3.rkt` / `racket 72_q4.rkt` after appending its own calls to the end of the file.
- The file contains **only definitions**: no top-level calls, nothing printed when it loads,
  no `provide`, no `require`.

## Allowed built-ins (nothing else from racket/base)
- Definitions and binding: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`
- Control: `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`
- Data: `quote` (written `'`), `cons`, `car`, `cdr`, `list`, and every `c[ad]{2,4}r`
  composition (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ...)
- Predicates and lookup: `null?`, `pair?`, `eq?`, `assq`, `assoc`
- Arithmetic and comparison: `+ - * < > <= >= =`, `max`
- Output: `display`, `newline`
- S2 only: `read`

**Forbidden** (write your own helper instead, e.g. `my-reverse`): `set!` and its relatives, vectors,
hash tables, strings, `do`, `for` loops, `length`, `append`, `reverse`, `map`, `filter`, `member`,
`memq`, `list-ref`, `list-tail`, `equal?`, `number?`, `symbol?`, `list?`, `else` outside `cond`,
`when`, `unless`, `case`, `printf`, `write`, `displayln`, `void`, `apply`, `foldl`, `foldr`.

## Coding conventions
- Names in `kebab-case`; predicates end in `?`; own versions of library functions start with `my-`.
- Each function has a comment block above it:
  - `;; (name arg ...) -> result`: what it takes and returns.
  - `;; Recursive reading:` the base case, then how the result for a larger input is built
    from the result for smaller ones.
- Pass all state through arguments (no mutation). Use an accumulator and a named `let` or
  helper for tail recursion where it is natural (list building, counting).
- Every printing function ends its output with `(newline)`.

## How to run and test
- Run a file with extra calls: copy it, append calls, run `racket copy.rkt`.
- Tests live in `72/tests/test_qN.rkt` (written in `#lang racket`, which may use anything).
  They load the solution without changing it:
  ```racket
  (require racket/runtime-path)
  (define-runtime-path solution "../code/72_q3.rkt")
  (dynamic-require solution #f)
  (define ns (module->namespace solution))
  (define (run expr) (with-output-to-string (lambda () (eval expr ns))))
  ```
  and compare `run`'s output with the exact expected text. For functions that use `read`,
  wrap the call in `(parameterize ([current-input-port (open-input-string "...")]) ...)`.
- Also run one test the way the grader does: append calls to a copy of the file and run
  `racket` on it as a separate process.
- Run: `cd 72/tests && racket test_q3.rkt`. It prints a summary and exits non-zero on failure.
- Every example in the assignment PDF is a test, plus edge cases (empty input, single element,
  deep nesting, long lists).

## Self-review checklist (apply before answering)
1. First line is `#lang racket/base`; the file only defines things and prints nothing when loaded.
2. Every identifier used is in the allowed list above or defined in the file.
3. No `set!`, strings, vectors, loops, or forbidden list functions (search the file for them).
4. Output is exactly as specified, including parentheses, spaces and the final newline.
5. Base cases cover the empty list / empty tree.
6. Long lists (10,000 elements) and deep nesting (depth 100) work without hitting limits.
7. Each function has its contract comment and recursive reading.

## Known AI failure modes in Scheme
- Using `length`, `append`, `reverse`, `map`, `filter` or `equal?` out of habit.
- Using `else` in `if`, or `when`/`unless`, which are not allowed.
- Calling functions at the top level "to demonstrate", which prints when the grader loads the file.
- Using `displayln` or `printf` instead of `display` + `newline`.
- Building lists in reverse with an accumulator and forgetting to restore the order.
- Quadratic `append` inside recursion on big inputs.
- Writing `'()` where an unquoted `()` is needed, or the reverse, in test data.
- Mixing up `eq?` (identity, fine for symbols and small numbers) with deep equality.
- Treating a symbol as a list or calling `car` on `'()`.
