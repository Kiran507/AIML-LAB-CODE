left(a,b).
left(b,d).
left(c,f).
left(d,-1).
left(e,7).
left(f,2).
left(g,1).

right(a,c).
right(b,e).
right(c,g).
right(d,5).
right(e,3).
right(f,9).
right(g,6).

child(Node,Left,Right):-
         left(Node,Left),
         right(Node,Right).
min(LeftValue,RightValue,Value):-
         LeftValue>RightValue,
         Value is RightValue.

min(LeftValue,RightValue,Value):-
         LeftValue<RightValue,
         Value is LeftValue.

max(LeftValue,RightValue,Value):-
         LeftValue>RightValue,
         Value is LeftValue.

max(LeftValue,RightValue,Value):-
         LeftValue<RightValue,
         Value is RightValue.

mini(Node,Depth,Node):-
         Depth =:= 0.

%Chancelayer
mini(Node,Depth,Avg):-
        Depth=:=1,
        child(Node,Leftnode,Rightnode),
        Sum is Leftnode+Rightnode,
        Avg is Sum/2.

mini(Node,Depth,Value):-
         child(Node,Leftnode,Rightnode),
         Newdepth is Depth-1,
         maxi(Leftnode,Newdepth,LeftValue),
         maxi(Rightnode,Newdepth,RightValue),
         min(LeftValue,RightValue,Value).

 maxi(Node,Depth,Node):-
         Depth =:= 0.

%Chancelayer
maxi(Node,Depth,Avg):-
        Depth=:=1,
        child(Node,Leftnode,Rightnode),
        Sum is Leftnode+Rightnode,
        Avg is Sum/2.

 maxi(Node,Depth,Value):-
         child(Node,Leftnode,Rightnode),
         Newdepth is Depth-1,
         mini(Leftnode,Newdepth,LeftValue),
         mini(Rightnode,Newdepth,RightValue),
         max(LeftValue,RightValue,Value).