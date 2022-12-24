% Beam Search in N queen problem
sumList([], [], []).
sumList([X | Xrest], [Y | Yrest], [Sum | Sumrest]):-
    Sum is X + Y,
    sumList(Xrest, Yrest, Sumrest).

diffList([], [], []).
diffList([X | Xrest], [Y | Yrest], [Diff | Diffrest]):-
    Diff is X - Y,
    diffList(Xrest, Yrest, Diffrest).

allAreUnique([]).
allAreUnique([X | Y]):-
    \+member(X, Y),
    allAreUnique(Y).

joinXandY([], [], []).
joinXandY([X | Xrest], [Y | Yrest], [J | Jrest]):-
    J = [X, Y],
    joinXandY(Xrest, Yrest, Jrest).

solve:-
    solve8Queens(X, Y),
 
    joinXandY(X, Y, Points),
    
    write('Points are: '),
    write(Points), nl.
    
solve8Queens(X, Y):-
    permutation([1, 2, 3, 4, 5, 6, 7, 8], X),
    permutation([1, 2, 3, 4, 5, 6, 7, 8], Y),q

    % sorting it in decreasing order of heuristic value
    sumList(X, Y, Sum),
    diffList(X, Y, Diff),

    % check if elements in Sum and Diff are unique
    allAreUnique(Sum),
    allAreUnique(Diff).

