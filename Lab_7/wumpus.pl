printerFunction:-
     nl,\+ goldPath(_), format('No paths ', []).

printerFunction:-
     goldPath(_), !, format('The following are paths to gold ', []),nl,
     forall(goldPath(X), writeln(X)).

check:-
      futureVisit(PausedCell, LeadingPath),
      retract(futureVisit(PausedCell, LeadingPath)),
      search(PausedCell, LeadingPath),check; printerFunction, printStatus.

:- dynamic([
     sizeOfworld/1,
     position/2,
     wumpusThere/1,
     noPit/1,
     noWumpus/1,
     futureVisit/2,
     goldPath/1
    ]).

start:-
     retractall(wumpusThere(_)),
     retractall(noPit(_)),
     retractall(noWumpus(_)),
     retractall(futureVisit(,)),
     retractall(goldPath(_)),
     retractall(position(_, _)),

     retractall(sizeOfworld(_)),
     assertz(sizeOfworld([4, 4])),

     assertz(position(gold, [4, 2])),

     assertz(position(pit, [4, 1])),
     assertz(position(pit, [4, 3])),
     assertz(position(pit, [4, 4])),

     assertz(noPit([1,1])),
     assertz(position(agent, [1, 1])),
     assertz(position(wumpusThere, [1, 4])),
     assertz(noWumpus([1, 1])),

     search([1, 1], []).

stenchHere([X, Y]):-
     position(wumpusThere, Z), \+ noWumpus(Z),
     adjacent([X, Y], Z).

breezeHere([X, Y]):- adjacent([X, Y], Z), position(pit, Z).

glitteringGold([X, Y]):- position(gold, Z), Z==[X, Y].

moreThanOneWumpus:-
     wumpusThere(X), wumpusThere(Y), X\=Y.

killWump(AgentCell):-
     wumpusThere([Xw, Yw]), \+ moreThanOneWumpus,
     AgentCell=[Xa, Ya],
     (Xw==Xa; Yw==Ya),
     assertz(noWumpus([Xw, Yw])),
     format('~nAgent confirmed Wumpus cell to be ~w and shot an arrow from cell ~w.~nThe WUMPUS has been killed!~n', [[Xw, Yw], AgentCell]),
     retractall(wumpusThere(_)).

valid_position([X, Y]):- X>0, Y>0, sizeOfworld([P, Q]), X@=<P, Y@=<Q.

    adjacent([X, Y], Z):- Left is X-1, valid_position([Left, Y]), Z=[Left, Y].
    adjacent([X, Y], Z):- Right is X+1, valid_position([Right, Y]), Z=[Right, Y].
    adjacent([X, Y], Z):- Above is Y+1, valid_position([X, Above]), Z=[X, Above].
    adjacent([X, Y], Z):- Below is Y-1, valid_position([X, Below]), Z=[X, Below].

search(Cell, LeadingPath):-
     nl,format('Current Cell ', []),
     write(Cell), nl,
     glitteringGold(Cell),
     append(LeadingPath, [Cell], CurrentPath),
     \+ goldPath(CurrentPath), assertz(goldPath(CurrentPath)).

    search(Cell, _):-
     breezeHere(Cell),
     format('BREEZE detected!~n'),
     false.

    search(Cell, _):-
     \+ breezeHere(Cell),
     format('NO breeze detected!~n'),
     forall(
      adjacent(Cell, X),
      (
       \+ noPit(X) -> assertz(noPit(X));write('')
      )
     ),
     false.

    search(Cell, _):-
     stenchHere(Cell),
     format('SMELL detected!~n'),
     forall(adjacent(Cell, X),
      (
       \+ noWumpus(X) -> assertz(wumpusThere(X)); write('')
      )
     ),
     false.

    search(Cell, _):-
     \+ stenchHere(Cell),
     format('NO SMELL detected!~n'),
     forall(adjacent(Cell, X),
      (
       \+ noWumpus(X) -> assertz(noWumpus(X)); write('')
      )
     ),
     false.

    search(CurrentCell, LeadingPath):-
     (killWump(CurrentCell); format('')),
     append(LeadingPath, [CurrentCell], CurrentPath),
     \+ glitteringGold(CurrentCell),
     adjacent(CurrentCell, X), \+ member(X, LeadingPath),
     (
      ( noWumpus(X), noPit(X)) -> write('');
      (\+ futureVisit(CurrentCell, _) -> assertz(futureVisit(CurrentCell, LeadingPath)); write(''))
     ),
     noWumpus(X), noPit(X),
     search(X, CurrentPath).

    printStatus:-
     format('~n-----------------------~n~n').

:-
     start,
     check, halt.
