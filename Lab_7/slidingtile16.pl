ids :-
	start(State),
	length(Moves, N),
	dfs([State], Moves, Path), !,
	show([start|Moves], Path),
	format('~nmoves = ~w~n', [N]).
	
dfs([State|States], [], Path) :-
	goal(State), !, 
	reverse([State|States], Path).
	
dfs([State|States], [Move|Moves], Path) :-
	move(State, Next, Move),
	not(memberchk(Next, [State|States])),
	dfs([Next, State|States], Moves, Path).

show([], _).
show([Move|Moves], [State|States]) :-
	State = state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P),
	format('~n~w~n~n', [Move]),
	format('~w ~w ~w ~w~n', [A,B,C,D]),
	format('~w ~w ~w ~w~n', [E,F,G,H]),
	format('~w ~w ~w ~w~n', [I,J,K,L]),
	format('~w ~w ~w ~w~n', [M,N,O,P]),
	show(Moves, States).
	
start( state(1,2,3,4,8,7,6,5,9,10,11,12,15,*,14,13) ).
goal( state(1,2,3,4,8,7,6,5,9,10,11,12,*,15,14,13) ).

move( state(*,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P), state(B,*,C,D,E,F,G,H,I,J,K,L,M,N,O,P), right ).
move( state(*,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P), state(E,B,C,D,*,F,G,H,I,J,K,L,M,N,O,P), down ).

move( state(A,*,C,D,E,F,G,H,I,J,K,L,M,N,O,P), state(*,A,C,D,E,F,G,H,I,J,K,L,M,N,O,P), left ).
move( state(A,*,C,D,E,F,G,H,I,J,K,L,M,N,O,P), state(A,C,*,D,E,F,G,H,I,J,K,L,M,N,O,P), right ).
move( state(A,*,C,D,E,F,G,H,I,J,K,L,M,N,O,P), state(A,F,C,D,E,*,G,H,I,J,K,L,M,N,O,P), down ).

move( state(A,B,*,D,E,F,G,H,I,J,K,L,M,N,O,P), state(A,*,B,D,E,F,G,H,I,J,K,L,M,N,O,P), left ).
move( state(A,B,*,D,E,F,G,H,I,J,K,L,M,N,O,P), state(A,B,D,*,E,F,G,H,I,J,K,L,M,N,O,P), right ).
move( state(A,B,*,D,E,F,G,H,I,J,K,L,M,N,O,P), state(A,B,G,D,E,F,*,H,I,J,K,L,M,N,O,P), down ).

move( state(A,B,C,*,E,F,G,H,I,J,K,L,M,N,O,P), state(A,B,*,C,E,F,G,H,I,J,K,L,M,N,O,P), left ).
move( state(A,B,C,*,E,F,G,H,I,J,K,L,M,N,O,P), state(A,B,C,H,E,F,G,*,I,J,K,L,M,N,O,P), down ).

move( state(A,B,C,D,*,F,G,H,I,J,K,L,M,N,O,P), state(*,B,C,D,A,F,G,H,I,J,K,L,M,N,O,P), up ).
move( state(A,B,C,D,*,F,G,H,I,J,K,L,M,N,O,P), state(A,B,C,D,F,*,G,H,I,J,K,L,M,N,O,P), right ).
move( state(A,B,C,D,*,F,G,H,I,J,K,L,M,N,O,P), state(A,B,C,D,I,F,G,H,*,J,K,L,M,N,O,P), down ).

move( state(A,B,C,D,E,*,G,H,I,J,K,L,M,N,O,P), state(A,*,C,D,E,B,G,H,I,J,K,L,M,N,O,P), up ).
move( state(A,B,C,D,E,*,G,H,I,J,K,L,M,N,O,P), state(A,B,C,D,*,E,G,H,I,J,K,L,M,N,O,P), left ).
move( state(A,B,C,D,E,*,G,H,I,J,K,L,M,N,O,P), state(A,B,C,D,E,J,G,H,I,*,K,L,M,N,O,P), down ).
move( state(A,B,C,D,E,*,G,H,I,J,K,L,M,N,O,P), state(A,B,C,D,E,G,*,H,I,J,K,L,M,N,O,P), right ).

move( state(A,B,C,D,E,F,*,H,I,J,K,L,M,N,O,P), state(A,B,*,D,E,F,C,H,I,J,K,L,M,N,O,P), up ).
move( state(A,B,C,D,E,F,*,H,I,J,K,L,M,N,O,P), state(A,B,C,D,E,*,F,H,I,J,K,L,M,N,O,P), left ).
move( state(A,B,C,D,E,F,*,H,I,J,K,L,M,N,O,P), state(A,B,C,D,E,F,K,H,I,J,*,L,M,N,O,P), down ).
move( state(A,B,C,D,E,F,*,H,I,J,K,L,M,N,O,P), state(A,B,C,D,E,F,H,*,I,J,K,L,M,N,O,P), right ).

move( state(A,B,C,D,E,F,G,*,I,J,K,L,M,N,O,P), state(A,B,C,*,E,F,G,D,I,J,K,L,M,N,O,P), up ).
move( state(A,B,C,D,E,F,G,*,I,J,K,L,M,N,O,P), state(A,B,C,D,E,F,*,G,I,J,K,L,M,N,O,P), left ).
move( state(A,B,C,D,E,F,G,*,I,J,K,L,M,N,O,P), state(A,B,C,D,E,F,G,L,I,J,K,*,M,N,O,P), down ).

move( state(A,B,C,D,E,F,G,H,*,J,K,L,M,N,O,P), state(A,B,C,D,*,F,G,H,E,J,K,L,M,N,O,P), up ).
move( state(A,B,C,D,E,F,G,H,*,J,K,L,M,N,O,P), state(A,B,C,D,E,F,G,H,J,*,K,L,M,N,O,P), right ).
move( state(A,B,C,D,E,F,G,H,*,J,K,L,M,N,O,P), state(A,B,C,D,E,F,G,H,M,J,K,L,*,N,O,P), down ).

move( state(A,B,C,D,E,F,G,H,I,*,K,L,M,N,O,P), state(A,B,C,D,E,*,G,H,I,F,K,L,M,N,O,P), up ).
move( state(A,B,C,D,E,F,G,H,I,*,K,L,M,N,O,P), state(A,B,C,D,E,F,G,H,*,I,K,L,M,N,O,P), left ).
move( state(A,B,C,D,E,F,G,H,I,*,K,L,M,N,O,P), state(A,B,C,D,E,F,G,H,I,N,K,L,M,*,O,P), down ).
move( state(A,B,C,D,E,F,G,H,I,*,K,L,M,N,O,P), state(A,B,C,D,E,F,G,H,*,I,K,L,M,N,O,P), right ).

move( state(A,B,C,D,E,F,G,H,I,J,*,L,M,N,O,P), state(A,B,C,D,E,F,*,H,I,J,G,L,M,N,O,P), up ).
move( state(A,B,C,D,E,F,G,H,I,J,*,L,M,N,O,P), state(A,B,C,D,E,F,G,H,I,*,J,L,M,N,O,P), left ).
move( state(A,B,C,D,E,F,G,H,I,J,*,L,M,N,O,P), state(A,B,C,D,E,F,G,H,I,J,O,L,M,N,*,P), down ).
move( state(A,B,C,D,E,F,G,H,I,J,*,L,M,N,O,P), state(A,B,C,D,E,F,G,H,I,J,L,*,M,N,O,P), right ).

move( state(A,B,C,D,E,F,G,H,I,J,K,*,M,N,O,P), state(A,B,C,D,E,F,G,*,I,J,K,H,M,N,O,P), up ).
move( state(A,B,C,D,E,F,G,H,I,J,K,*,M,N,O,P), state(A,B,C,D,E,F,G,H,I,J,*,K,M,N,O,P), left ).
move( state(A,B,C,D,E,F,G,H,I,J,K,*,M,N,O,P), state(A,B,C,D,E,F,G,H,I,J,K,P,M,N,O,*), down ).

move( state(A,B,C,D,E,F,G,H,I,J,K,L,*,N,O,P), state(A,B,C,D,E,F,G,H,*,J,K,L,I,N,O,P), up ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,*,N,O,P), state(A,B,C,D,E,F,G,H,I,J,K,L,N,*,O,P), right ).

move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,*,O,P), state(A,B,C,D,E,F,G,H,I,*,K,L,M,J,O,P), up ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,*,O,P), state(A,B,C,D,E,F,G,H,I,J,K,L,*,M,O,P), left ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,*,O,P), state(A,B,C,D,E,F,G,H,I,J,K,L,M,O,*,P), right ).

move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,*,P), state(A,B,C,D,E,F,G,H,I,J,*,L,M,N,K,P), up ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,*,P), state(A,B,C,D,E,F,G,H,I,J,K,L,M,*,N,P), left ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,*,P), state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P,*), right ).

move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,*), state(A,B,C,D,E,F,G,H,I,J,K,*,M,N,O,L), up ).
move( state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,*), state(A,B,C,D,E,F,G,H,I,J,K,L,M,N,*,O), left ).





