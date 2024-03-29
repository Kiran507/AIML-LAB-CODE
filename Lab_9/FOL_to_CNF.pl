%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% normalize.P
%%% SWI-Prolog version
%%% Convert wffs to list of normal logic clauses
%%%
%%% and /\
%%% or \/
%%% not ~
%%% xor xor
%%% implies =>
%%% iff <=>
%%% all all(X,-)
%%% some exists(Y,-)
%%%
%%% all(X,p(X) => exists(Y, r(Y) /\ q(X,Y)))
%%% --------------------------------------------
%%% p(X) => r(sk1(X)) /\ q(X,sk1(X))
%%% --------------------------------------------
%%% r(sk1(X)) :- p(X).
%%% q(X,sk1(X)) :- p(X).

:- op(300,fx,'~').
:- op(400,yfx,'/\\').
:- op(500,yfx,'\\/').
:- op(600,xfx,'=>').
:- op(650,xfx,'<=>').
:- op(350,xfx,'xor').


%%%%%%%%%%%%%%%%%%%%%%
%%% generate a skolem
:- dynamic skolems/1.
:- assert(skolems([sk1,sk2,sk3,sk4,sk5,sk6,sk7,sk8,sk9,sk10,sk11,
                   sk12,sk13,sk14,sk15,sk16,sk17,sk18,sk19,sk20])).
genskolem(SK) :- retract(skolems([SK|R])),
                 assert(skolems(R)).


  %%----- drive negation inward --------------
conVert(~(~X),Uvars,Y) :-
   !,
   conVert(X,Uvars,Y).
conVert(~(X /\ Y),Uvars,A) :-
   !,
   conVert((~X \/ ~Y), Uvars,A).
conVert(~(X \/ Y),Uvars,A) :-
   !,
   conVert((~X /\ ~Y),Uvars,A).
conVert(~(X => Y),Uvars,A) :-
   !,
   conVert((X /\ ~Y),Uvars,A).
conVert(~(X <=> Y),Uvars,A) :-
   !,
   conVert((X /\ ~Y) \/ (~X /\ Y),Uvars,A).
conVert(~exists(X,P),Uvars,A) :-
   !,
   conVert(all(X,~P),Uvars,A).
conVert(~all(X,P),Uvars,A) :-
   !,
   conVert(exists(X,~P),Uvars,A).
conVert(~(X xor Y),Uvars,A) :-
   !,
   conVert((X /\ Y) \/ (~X /\ ~Y), Uvars, A).
  %%----- quantifiers -----------------------
conVert(all(X,P),Uvars,Q) :-
   !,
   \+ occurs(X,Uvars), %% MUST use separate variables
   conVert(P,[X|Uvars],Q).
conVert(exists(X,P),Uvars,Q) :-
   !,
   \+ occurs(X,Uvars), %% MUST use separate variables
   genskolem(SK),
   X=..[SK|Uvars],
   conVert(P,Uvars,Q).
  %%----- connectives ------------------------
conVert((X <=> Y),Uvars,(A /\ B)) :-
   !,
   conVert((X => Y),Uvars,A),
   conVert((Y => X),Uvars,B).
conVert((X => Y),Uvars,Q) :-
   !,
   conVert((~X \/ Y),Uvars,Q).
conVert((X /\ Y),Uvars,(A /\ B)) :-
   !,
   conVert(X,Uvars,A),
   conVert(Y,Uvars,B).
conVert((X \/ Y),Uvars,(A \/ B)) :-
   !,
   conVert(X,Uvars,A),
   conVert(Y,Uvars,B).
conVert((X xor Y),Uvars,(A \/ B) /\ (~A \/ ~B)) :-
   !,
   conVert(X,Uvars,A),
   conVert(Y,Uvars,B).
  %%----- logically atomic --------------------
conVert(X,_,X).


%%----- distribute --------------------------
distriBute((X /\ Y) \/ Z,
            (X \/ Z) /\ (Y \/ Z),true) :- !.
distriBute(X \/ (Y /\ Z),
             (X \/ Y) /\ (X \/ Z),true) :- !.
distriBute(X,X,fail).


%%----- conjunctive normal form --------------
cnF((X /\ Y),(A /\ B)) :-
   !,
   cnF(X,A),
   cnF(Y,B).
cnF((X \/ Y),G) :-
   !,
   cnF(X,A),
   cnF(Y,B),
   distriBute((A \/ B),F,Flag),
   (Flag -> cnF(F,G) %% More work may be needed
             ;
            G = F ).
cnF(X,X).


%%----- make a sequence out of a conjunction -----
flatten_and(X /\ Y, F) :-
   !,
   flatten_and(X,A),
   flatten_and(Y, B),
   sequence_append(A,B,F).
flatten_and(X,X).

%%----- make a sequence out of a disjunction -----
flatten_or(X \/ Y, F) :-
   !,
   flatten_or(X,A),
   flatten_or(Y,B),
   sequence_append(A,B,F).
flatten_or(X,X).


%%----- append two sequences -------------------------------
sequence_append((X,R),S,(X,T)) :- !, sequence_append(R,S,T).
sequence_append((X),S,(X,S)).

%%----- separate into positive and negative literals -----------
separate((A,B),P,N) :-
   !,
   (A = ~X -> N=[X|N1],
               separate(B,P,N1)
             ;
               P=[A|P1],
               separate(B,P1,N) ).
separate(A,P,N) :-
   (A = ~X -> N=[X],
               P = []
            ;
               P=[A],
               N = [] ).

%%----- tautology ----------------------------
tautology(P,N) :- some_occurs(N,P).

some_occurs([F|R],B) :-
   occurs(F,B) | some_occurs(R,B).

occurs(A,[F|_]) :-
   A == F,
   !.
occurs(A,[_|R]) :-
   occurs(A,R).

%%----- normalize(+Wff,-NormalClauses) ------
normalize(Wff,NormalClauses) :-
   conVert(Wff,[],S),
   cnF(S,T),
   flatten_and(T,U),
   make_clauses(U,NormalClauses).

make_clauses((A,B),C) :-
   !,
   flatten_or(A,F),
   separate(F,P,N),
   (tautology(P,N) ->
      make_clauses(B,C)
          ;
      make_clause(P,N,D),
      C = [D|R],
      make_clauses(B,R) ).
make_clauses(A,C) :-
   flatten_or(A,F),
   separate(F,P,N),
   (tautology(P,N) ->
       C = []
        ;
       make_clause(P,N,D),
       C = [D] ).

make_clause([],N, (false :- B)) :-
   !,
   make_sequence(N,B,',').
make_clause(P,[],H) :-
   !,
   make_sequence(P,H,'|').
make_clause(P,N, (H :- T)) :-
   make_sequence(P,H,'|'),
   make_sequence(N,T,',').

make_sequence([A],A,_) :- !.
make_sequence([F|R],(F|S),'|') :-
   make_sequence(R,S,'|').
make_sequence([F|R],(F,S),',') :-
   make_sequence(R,S,',').


%% --------- to test program -------------
test :- write('wff? '),
        read(Wff),
        normalize(Wff,NCs),
        write_list(NCs),
        nl, test.

write_list([F|R]) :-
   write(F), write('.'), nl,
   write_list(R).
write_list([]).







tocnf(FBF, FCNF) :-
 is_wff(FBF),
 rew(FBF, _, SFBF),
 dist(SFBF, CNFFBF),
 simplify(CNFFBF, FCNF), !.
tocnf(FBF, CNFFBF) :-
 is_wff(FBF),
 rew(FBF, _, SFBF),
 dist(SFBF, CNFFBF), !.
tocnf(FBF, FCNF) :-
 is_wff(FBF),
 rew(FBF, _, SFBF),
 simplify(SFBF, FCNF), !.
tocnf(FBF, SFBF) :-
 is_wff(FBF),
 rew(FBF, _, SFBF), !.

%
% --- Horn check
%

is_horn(A) :- tocnf(A, B), is_horn_cnf(B), !.
is_horn_cnf(A) :- A=..[and|Clauses], is_horn_conj(Clauses), !.
is_horn_cnf(A) :- is_horn_conj(A), !.

is_horn_conj([]) :- !.
is_horn_conj([H|T]) :- is_horn_clause(H), is_horn_conj(T), !.
is_horn_conj(Clause) :- is_horn_clause(Clause).

is_horn_clause(Clause) :- Clause=..[or|Literals],
   positive_lit(Literals, N), N=<1, !.
is_horn_clause(Term) :- is_literal(Term),
   positive_lit([Term], N), N=<1, !.

positive_lit([], 0).
positive_lit([H|T], N) :- functor(H, Name, _), Name \= not, !,
           positive_lit(T, N2), N is N2+1.
positive_lit([_|T], N) :- positive_lit(T, N), !.

%
% ---- Formula validity control
%

is_reserved(A) :- subset([A], [and, or, not, implies, every, exist]).

is_term(A) :- var(A), !.
is_term(A) :- atomic(A), not(is_reserved(A)), !.
is_term(A) :- compound_name_arity(A, _, Arity), Arity > 0,
  A =.. [Name|List], not(is_reserved(Name)),
  foreach(member(L, List), is_term(L)), !.

is_wff(A) :- is_term(A), !.
is_wff(not(A)) :- is_wff(A), !.
is_wff(and(A, B)) :- is_wff(A), is_wff(B), !.
is_wff(or(A, B)) :- is_wff(A), is_wff(B), !.
is_wff(implies(A, B)) :- is_wff(A), is_wff(B), !.
is_wff(exist(A, B)) :- var(A), is_wff(B), !.
is_wff(every(A, B)) :- var(A), is_wff(B), !.

%
% ---- Rewrite rules for conversion of generic FOL formula to CNF
%

%% Implication in terms of or
rew(implies(A, B), Univars, F) :-
 rew(or(not(A), B), Univars, F), !.
