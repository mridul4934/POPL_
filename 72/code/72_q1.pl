% CS F301 Assignment 2, Group 72
% P1: Department Assignment Puzzle, Reloaded

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

%! departments(-Ds) is det.
%  Ds is the list of the four departments.
departments([research, development, design, testing]).

%! languages(-Ls) is det.
%  Ls is the list of the four favorite languages.
languages([python, java, 'c++', javascript]).

%! projects(-Ps) is det.
%  Ps is the list of the four project preferences.
projects(['AI', web, embedded, data]).

%! solution(-Sol) is nondet.
%  Sol is a fully filled-in assignment, in the order Alex, Ben, Carla, Dana,
%  where each department, language and project is used exactly once.
%  Reading: each attribute column is a permutation of its domain, so every
%  value appears once and the 24 x 24 x 24 = 13824 assignments are all produced.
solution([p('Alex',  D1, L1, P1),
          p('Ben',   D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana',  D4, L4, P4)]) :-
    departments(Ds), permutation(Ds, [D1, D2, D3, D4]),
    languages(Ls),   permutation(Ls, [L1, L2, L3, L4]),
    projects(Ps),    permutation(Ps, [P1, P2, P3, P4]).

%! clue(+N, +Sol) is semidet.
%  clue(N, Sol) holds when clue number N is true in the filled-in Sol.
%  Each value occurs exactly once in Sol, so memberchk/2 finds the one
%  friend with that value; == and \== then compare ground atoms.

% 1. The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Sol) :-
    memberchk(p(Name, Dept, _, 'AI'), Sol),
    Dept \== research,
    Name \== 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, Sol) :-
    memberchk(p('Alex', Dept, Lang, _), Sol),
    Dept \== development,
    Lang \== 'c++'.

% 3. The friend working in the testing department likes Python.
clue(3, Sol) :-
    memberchk(p(_, testing, Lang, _), Sol),
    Lang == python.

% 4. Ben prefers web projects and does not work in testing.
clue(4, Sol) :-
    memberchk(p('Ben', Dept, _, Proj), Sol),
    Proj == web,
    Dept \== testing.

% 5. The friend whose favorite language is Java works in the design department.
clue(5, Sol) :-
    memberchk(p(_, Dept, java, _), Sol),
    Dept == design.

% 6. Carla's project preference is not embedded, and her department is not development.
clue(6, Sol) :-
    memberchk(p('Carla', Dept, _, Proj), Sol),
    Proj \== embedded,
    Dept \== development.

% 7. Dana's favorite language is not Java, and she works in research or testing.
clue(7, Sol) :-
    memberchk(p('Dana', Dept, Lang, _), Sol),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Sol) :-
    memberchk(p(_, Dept, Lang, data), Sol),
    Dept == research,
    Lang \== javascript.

% P1.c repair: clues 1-8 allow three solutions; this clue keeps exactly one.
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Sol) :-
    memberchk(p(_, Dept, _, 'AI'), Sol),
    Dept == testing.

%! satisfies(+Active, +Sol) is semidet.
%  Sol satisfies every clue whose number is in the list Active.
satisfies(Active, Sol) :-
    forall(member(N, Active), clue(N, Sol)).

%! print_friend(+Friend) is det.
%  Prints one friend as "Name = [Dept, Lang, Project]" followed by a newline.
%  ~w writes atoms without quotes, so 'c++' and 'AI' appear as c++ and AI.
print_friend(p(Name, Dept, Lang, Proj)) :-
    format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj]).

%! main is semidet.
%  Finds the first assignment that satisfies clues 1 to 8 and prints it,
%  one friend per line in the order Alex, Ben, Carla, Dana. The cut keeps
%  backtracking from printing a second solution.
main :-
    solution(Sol),
    satisfies([1, 2, 3, 4, 5, 6, 7, 8], Sol),
    !,
    maplist(print_friend, Sol).

%! count_solutions(+Active, -N) is det.
%  N is the number of complete assignments that satisfy every clue listed in
%  Active; clues not in Active are ignored.
count_solutions(Active, N) :-
    aggregate_all(count, (solution(Sol), satisfies(Active, Sol)), N).
