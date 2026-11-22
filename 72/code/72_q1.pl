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
