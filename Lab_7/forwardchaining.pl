male(hari).
male(ram).
male(krish).

female(sita).
female(leela).
female(mala).

father(ram, hari).
father(ram, sita).
father(krish, ram).

mother(leela, hari).
mother(leela, sita).
mother(mala, ram).

sister_of(X, Y) :-
    female(X),
    mother(A,X),
    mother(B,Y),
    A=B,
    father(C,X),
    father(D,Y),
    C=D.


grand_father(X,Y):-
    male(X),
    father(X,Z),
    father(Z,Y).
