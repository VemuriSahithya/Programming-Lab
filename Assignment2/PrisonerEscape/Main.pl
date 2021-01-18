% knowledge base
% List of all gates in the prison. Here gates are considered to be vertices of the graph for my solution
gates([g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,g15,g16,g17,g18]).

% List of all starting points i.e. gates (source) which are open towards first corridor
start([g1,g2,g3,g4]).

% List of all ending points i.e. gates (destination) which are open towards outside
end(g17).

% List of all restricted points i.e. gates which leads to blocked roads
restrict([g7,g9,g18]).

% List containing vertices of edges and weights assigned to it where vertices are the gates and weights are the distances between gates
% Since they are undirected edges there are two entries per edge
dist(g1,g5,4).
dist(g5,g1,4).
dist(g2,g5,6).
dist(g5,g2,6).
dist(g3,g5,8).
dist(g5,g3,8).
dist(g4,g5,9).
dist(g5,g4,9).
dist(g1,g6,10).
dist(g6,g1,10).
dist(g2,g6,9).
dist(g6,g2,9).
dist(g3,g6,3).
dist(g6,g3,3).
dist(g4,g6,5).
dist(g6,g4,5).
dist(g5,g7,3).
dist(g7,g5,3).
dist(g5,g10,4).
dist(g10,g5,4).
dist(g5,g11,6).
dist(g11,g5,6).
dist(g5,g12,7).
dist(g12,g5,7).
dist(g5,g6,7).
dist(g6,g5,7).
dist(g5,g8,9).
dist(g8,g5,9).
dist(g6,g8,2).
dist(g8,g6,2).
dist(g6,g12,3).
dist(g12,g6,3).
dist(g6,g11,5).
dist(g11,g6,5).
dist(g6,g10,9).
dist(g10,g6,9).
dist(g6,g7,10).
dist(g7,g6,10).
dist(g7,g10,2).
dist(g10,g7,2).
dist(g7,g11,5).
dist(g11,g7,5).
dist(g7,g12,7).
dist(g12,g7,7).
dist(g7,g8,10).
dist(g8,g7,10).
dist(g8,g9,3).
dist(g9,g8,3).
dist(g8,g12,3).
dist(g12,g8,3).
dist(g8,g11,4).
dist(g11,g8,4).
dist(g8,g10,8).
dist(g10,g8,8).
dist(g10,g15,5).
dist(g15,g10,5).
dist(g10,g11,2).
dist(g11,g10,2).
dist(g10,g12,5).
dist(g12,g10,5).
dist(g11,g15,4).
dist(g15,g11,4).
dist(g11,g13,5).
dist(g13,g11,5).
dist(g11,g12,4).
dist(g12,g11,4).
dist(g12,g13,7).
dist(g13,g12,7).
dist(g12,g14,8).
dist(g14,g12,8).
dist(g15,g13,3).
dist(g13,g15,3).
dist(g13,g14,4).
dist(g14,g13,4).
dist(g14,g17,5).
dist(g17,g14,5).
dist(g14,g18,4).
dist(g18,g14,4).
dist(g17,g18,8).
dist(g18,g17,8).

% Finding all paths for a prisoner to escape from the jail (3.A)

% Depth First Search algorithm to find all the paths 
dfs([],_,_).
dfs([Edge|_],List):- 
	% If the value of edge is not "false" then it implies that the edge exists
	Edge \='false',
	% check if the gate is already visited or not in the path.
	not(member(Edge,List)),
	% If not visited then add it to the path
	append(List,[Edge],Pathlist),
	% Get all the adjacent gates and do dfs for all of those gates
	gates(Gates),
	edges(Edge,Gates,EdgeList),
	dfs(EdgeList,Pathlist);
	% If the value of edge is not "false" then it implies that the edge exists
	Edge \='false',
	% check if the gate is already visited or not in the path.
	not(member(Edge,List)),
	% If not visited then add it to the path
	append(List,[Edge],Pathlist),
	% If it is the end point then just print the path and return
	end(Edge),
	writef("Path: %w",[Pathlist]),nl,!.

% Do dfs for the remaining gates
dfs([_|Left],List):- 
	dfs(Left,List).

%  If edge exists then store name of the gate in the list
edge_exists(Gate1,Gate2,Ret):- 
	dist(Gate1,Gate2,_),
	Ret=Gate2.
% If the edge doesnot exist then just store "false" in the list
edge_exists(_,_,Ret):- 
	Ret='false'.

% Get the list of all gates that connected directly to Gate.
edges(_,[],[]).
edges(Gate,[Gate1|Left],List):- 
	% Check whether the edge exists between the two gates.
	edge_exists(Gate,Gate1,Value),
	% Check for the remaining edges by calling the edges function recursively
	edges(Gate,Left,Tail),
	% List stores the gates names if they are connected or else it will store "false" for gates which are not connected to
	List=[Value|Tail],!.

% Print the path if the end point is reached or else traverse through the gates and get the paths using DFS algorithm
path([Gate|_]):- 
	% If not a end point get the adjacent points that is gates and then do dfs on all these points to get the paths 
	gates(Gates),
	edges(Gate,Gates,EdgeList),
	dfs(EdgeList,[Gate]);
	% If end point print path and return
	end(Gate),
	writef("Path: %w",[List]),nl,!.	

% Travers through remaining gates
path([_|Left]):- path(Left).

% Search for the path from each and every start point i.e. gate
search([],_,_,_).

search([Edge|_],List,Gate,Dist):- 
	% If the value of edge is not "false" then it implies that the edge exists
	Edge \='false',
	% check if the gate is already visited or not in the path.
	not(member(Edge,List)),
	% If not visited then add it to the path
	append(List,[Edge],Pathlist),
	% Calculate distance and then find the optimal path
	dist(Gate,Edge,Val),
	Value is Dist + Val,
	getmaxPath(Edge,Pathlist,Value).

% Do dfs for the remaining gates
search([_|Left],List,Gate,Dist):- 
	search(Left,List,Gate,Dist).

getMax([]):-
	fail.
getMax([Gate|_]):-
	getmaxPath(Gate,[Gate],0),fail.
getMax([_|Left]):-
	getMax(Left),fail.

% Getting the maximum distance path along with the distance
getmaxPath(Gate,List,Dist):-
	% If the gate is restricted then just go back and check for other paths
	restrict(Gate),!;
	% Get all the adjacent gates and do dfs iteratively over all of them 
	gates(Gates),
	edges(Gate,Gates,EdgeList),
	search(EdgeList,List,Gate,Dist);
	% If the end gate is reached then just update the distance and path accordingly to get the maximum distance path 
	end(Gate),
	nb_getval(maxD, Max),
	Dist > Max, 
	nb_setval(maxD, Dist), 
	nb_setval(maxP,List),!.

% Find the maximum distance path along with the maximum distance that needs to be travelled by the prisoner to escape
maxPath(_):-  
	% Set the path to empty List
	nb_setval(maxP,[]),
	% Set the maximum distance value to 0
	nb_setval(maxD,0),
	start(Start),
	\+ getMax(Start),
	% Get the path and maximum distance calculated
	nb_getval(maxP,Path),
	nb_getval(maxD,Dist),
	% Print the optimal path and distance
	writef("Maximum distance path: %w ",[Path]),nl,
	writef("Maximum distance: %w",[Dist]),
	nl.

% Print all possible paths by traversing from all starting gates for a prisoner to escape from the jail
printAllPaths(_):-
	write("All possible paths:"),nl, 
	% start traversing from each and evry starting point to get the paths
	start(Start),
	% Get the number of all possible paths and store it in Count
	aggregate_all(count,path(Start),Count),
	writef("Total number of possible paths for a prisoner to escape from the jail is %w ",[Count]),nl,
	write("Among all the paths, given below are the most optimal and least optimal paths: "),nl,
	optimal(_),nl,
	maxPath(_),
	nl.

% Finding the optimal path for the prisoner to escape. (3.B)

% Using DFS algorithm to find the optimal path with least distance
dfs([],_,_,_).

dfs([Edge|_],List,Gate,Dist):- 
	% If the value of edge is not "false" then it implies that the edge exists
	Edge \='false',
	% check if the gate is already visited or not in the path.
	not(member(Edge,List)),
	% If not visited then add it to the path
	append(List,[Edge],Pathlist),
	% Calculate distance and then find the optimal path
	dist(Gate,Edge,Val),
	Value is Dist + Val,
	optPath(Edge,Pathlist,Value).

% Do dfs for the remaining gates
dfs([_|Left],List,Gate,Dist):- 
	dfs(Left,List,Gate,Dist).

% Search for the optimal path from each and every start point i.e. gate
getOpt([]):-
	fail.
getOpt([Gate|_]):-
	optPath(Gate,[Gate],0),fail.
getOpt([_|Left]):-
	getOpt(Left),fail.

% Getting the optimal path along with the distance
optPath(Gate,List,Dist):-
	% If the gate is restricted then just go back and check for other paths
	restrict(Gate),!;
	% Get all the adjacent gates and do dfs iteratively over all of them 
	gates(Gates),
	edges(Gate,Gates,EdgeList),
	dfs(EdgeList,List,Gate,Dist);
	% If the end gate is reached then just update the distance and path accordingly to get the optimal one
	end(Gate),
	nb_getval(minD, Min),
	Dist < Min, 
	nb_setval(minD, Dist), 
	nb_setval(minP,List),!.

% Find the optimal path along with the minimum distance that needs to be travelled by the prisoner to escape
optimal(_):-  
	% Set the minimum path to empty List
	nb_setval(minP,[]),
	% Set the minimum distance value to 1000000007
	nb_setval(minD,1000000007),
	% Start traversing through all start points and find the optimal path
	start(Start),
	\+ getOpt(Start),
	% Get the optimal path and minimum distance calculated
	nb_getval(minP,Path),
	nb_getval(minD,Dist),
	% Print the optimal path and distance
	writef("Optimal path: %w",[Path]),nl,
	writef("Optimal distance: %w",[Dist]),nl.
	

% Finding if the path is valid or not in terms of escaping the jail (3.C)

% Check whether the given path is valid or not
valid([Gate1,Gate2|Left]):- 
	% Check whether first gate given in the list is a starting point or not
	start(Start),
	member(Gate1,Start),
	dist(Gate1,Gate2,_),
	% Now check from second gate recursively to see whether the path is valid or not
	check([Gate2|Left]).

% Check the path by going through all gates in a sequential manner recursively 
check([Gate1,Gate2|Left]):- 
	% If Gate2 is final and end gate
	% Get the distance from Gate1 to Gate2
	dist(Gate1,Gate2,_),
	% Check whether the remaining list is empty or not in the given path
	\+ \+ Left == [],
	% If there are no more remaining gates then check whether the final gate is an end point or not
	end(Gate2),
	% The path is valid so print the distance to be travelled along the path for a prisoner to escape from the jail
	writef("Yes, the given path is valid");
	% If Gate2 is not final gate then recursively go over through all the remaining gates
	dist(Gate1,Gate2,_),
	% If list is not empty then iterate over the remaining gates in the given path
	\+ Left == [],
	check([Gate2|Left]),!.















