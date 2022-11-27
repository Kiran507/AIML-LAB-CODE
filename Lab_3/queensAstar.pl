% sum individual element of the array
sumList([], [], []).
sumList([X | Xrest], [Y | Yrest], [Sum | Sumrest]):-
    Sum is X + Y,
    sumList(Xrest, Yrest, Sumrest).

% difference of individual element of the array
diffList([], [], []).
diffList([X | Xrest], [Y | Yrest], [Diff | Diffrest]):-
    Diff is X - Y,
    diffList(Xrest, Yrest, Diffrest).

% true if all the elements are unique
% otherwise false
allAreUnique([]).
allAreUnique([X | Y]):-
    % X should not be member of rest of the array
    \+member(X, Y),
    allAreUnique(Y).

% join the co-ordinate
joinXandY([], [], []).
joinXandY([X | Xrest], [Y | Yrest], [J | Jrest]):-
    J = [X, Y],
    joinXandY(Xrest, Yrest, Jrest).

solve:-
    % fill the X and Y value
    solve8Queens(X, Y),
 
    % zip the X and Y   
    joinXandY(X, Y, Points),
    
    write('Points are: '),
    write(Points), nl.
    
solve8Queens(X, Y):-
    % permutation will make sure if all the
    % row and columns are occupied
    % and there is no queen share same colum or rows
    permutation([1, 2, 3, 4, 5, 6, 7, 8], X),
    permutation([1, 2, 3, 4, 5, 6, 7, 8], Y),

    % for diagonal we have to generate sum of x and y
    % and difference of x and y
    % and check if they are unique since
    % duplicate will mean that they are on same diagonal

    sumList(X, Y, Sum),
    diffList(X, Y, Diff),

    % check if elements in Sum and Diff are unique
    allAreUnique(Sum),
    allAreUnique(Diff).

