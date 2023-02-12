distribute((X /\ Y) \/ Z, (X \/ Z) /\ (Y \/ Z), true) :- !.
distribute(X \/ (Y /\ Z), (X \/ Y) /\ (X \/ Z), true) :- !.
distribute(X,X,fail).


cnf((X /\ Y), (A /\ B)) :-
 !,
 cnf(X,A),
 cnf(Y,B).


cnf((X \/ Y), Z) :-
  !,
  cnf(X,A),
  cnf(Y,B),
  distribute((A \/ B), Res, Flag),
  (Flag 
  -> cnf(Res, Z) 
  ; Z = Res
  ).



cnf(not(X /\ Y), R) :-
 !,
 cnf(not(X) \/ not(Y), R).



cnf(not(X \/ Y), R) :-
 !,
 cnf(not(X) /\ not(Y), R).


cnf(not(not(X)), R) :- 
 !,
 cnf(X, R).                 



cnf(A, A).

append([],L2,L2).
append([F1|T1],L2,[F1|L3]) :-
  append(T1, L2, L3).


extract_or(A \/ B, Out) :-
  !,
  extract_or(A, X),
  extract_or(B, Y),
  append(X, Y, Out).
extract_or(not(A), [not(A)]).
extract_or(A,[A]).



extract_clauses(A /\ B, Out) :-
  !,
  extract_clauses(A, Out1),
  extract_clauses(B, Out2),
  append(Out1, Out2, Out). 

extract_clauses(A, Out) :-
   atom(A),
   Out = [[A]].

extract_clauses(not(A), Out) :-
   atom(A),
   Out = [[not(A)]].


extract_clauses(A \/ B, Out) :-
  !,                
  extract_or(A, Out1),
  extract_or(B, Out2),
  append(Out1, Out2, Inter),
  Out = [Inter].



prop_clause(A, X) :-
  cnf(A, Res),
  extract_clauses(Res, X),
  !.




member(Element,[Element|_List]).
member(Element,[_First|Tail]) :- member(Element,Tail).

delete(X,[Fi|Li],Lo) :-
  Fi = X,
  Li = Lo.
delete(X,[Fi|Li],[Fo|Lo]) :-
  Fi = Fo,
  Fi \= X,
  delete(X,Li,Lo).



sortClauses([], []).
sortClauses([H|List], [H1|Out]) :-
  sort(H,H1),
  sortClauses(List, Out).                                          


resolve(List) :-
  sortClauses(List, L),              
  do_resolve(L).


do_resolve(List) :-                       
  once(get_resolvent(List, Resolvent)),
  (Resolvent = []
  -> true
  ;resolve([Resolvent|List])
  ).



get_resolvent(List, Resolvent) :-
  member(A, List),
  member(B, List),
  A \= B,
  res(A, B, T),
  (T = false
  -> false
  ;(member(T, List)
  -> false
  ; Resolvent = T)
  ).


res(A, B, T) :-
  member(A1, A),
  (A1 = X
  -> B1 = not(X)
  ; not(B1) = A1),
  (member(B1, B)
  -> delete(A1, A, TempA),
     delete(B1, B, TempB),
     append(TempA, TempB, Ans),
     sort(Ans, T)
  ; false
  ).       


resolve_pr(List) :-
  sortClauses(List, L),              
  do_resolve_pr(L).

do_resolve_pr(List) :-                       
  once(get_resolvent_pr(List, Resolvent)),
  (Resolvent = []
  -> true
  ; resolve_pr([Resolvent|List])
  ).



get_resolvent_pr(List, Resolvent) :-
  member(A, List),
  member(B, List),
  A \= B,
  res(A, B, T),
  (T = false
  -> false
  ;(member(T, List)
  -> false
  ;
  Resolvent = T),
  write('Clause A : '),writeln(A),
  write('Clause B : '),writeln(B), 
  write('Resolving it gives : '),writeln(Resolvent),writeln('')
  ).

/* Test run
resolve_pr([[p, r], [q, not(r)], [not(p)], [not(q)]]).
Source 1 : [p,r]
Source 2 : [q,not r]
Resolvent : [p,q]
Source 1 : [p,q]
Source 2 : [not p]
Resolvent : [q]
Source 1 : [q]
Source 2 : [not q]
Resolvent : []
*/

/* 2c. An interesting Example */

/* Lets give some meaning to our propositional symbols.
     s = Surya is sleeping
     hw = Surya is doing logic hw
     f = Surya is done with logic hw
  Lets consider the following clauses
   1. [Surya is sleeping, Surya is doing logic hw]
      [s,hw]
   2. [Surya is not doing logic hw, Surya is done with logic hw] 
      [not(hw), f]
   3. [Surya is not done with logic hw]
      [not(f)]
   4. [Surya is not sleeping]
      [not(s)]
      Test Run:
      resolve_pr([[s,hw],[not(hw),f],[not(f)],[not(s)]]).
      Source 1 : [hw,s]
      Source 2 : [f,not hw]
      Resolvent : [f,s]
      Source 1 : [f,s]
      Source 2 : [not f]
      Resolvent : [s]
      Source 1 : [s]
      Source 2 : [not s]
      Resolvent : []
      Lets Analyse,
           First clause says, either Surya is sleeping or He is doing logic hw.
           Second one says, either Surya is not doing logic hw or he is done with it.
           So when we resolve these two, We get a clause which says either Surya is either done with hw or he is sleeping [f, s].
           
           We resolve [f,s] with "Surya is not done with logic hw" and we get "Surya is sleeping".
           Resolving "Surya is sleeping" with the clause which says "Surya is not sleeping" give us an empty list [].
In short:
   From the 1st and 2nd clauses, either I will be happily sleeping or I burn the midnight oil to get done with the homework. 
   But in the 3rd and 4th clauses the claim that "neither I'm sleeping nor I'm done with the homework" makes the whole input unsatisfiable. :) 
*/
