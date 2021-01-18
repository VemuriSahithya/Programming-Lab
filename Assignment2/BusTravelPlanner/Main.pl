% knowledge base 
% Bus details contains bus number, source, destination, arrival and departure time, distance between the source and destination and bus fair
bus(123,'A','B',14,14.5,77,7).
bus(123,'B','C',14.5,15,77,7).
bus(123,'C','D',15,15.5,77,7).
bus(123,'D','G',15.5,16,77,7).
bus(123,'E','F',16.5,17,77,7).

bus(456,'A','B',14.3,14.6,7,77).
bus(456,'A','E',14.2,14.6,7,77).
bus(456,'E','C',14.6,15.0,7,77).
bus(456,'C','F',15.0,15.1,7,77).
bus(456,'F','G',15.1,15.2,7,77).

bus(789,'A','C',14,14.2,77,77).
bus(789,'C','G',14.2,14.5,77,77).

% Find all possible paths between the cities and get the optimum path based on distance
% If the given source and destination are same then the path will be just the city and the distance, time and cost will be 0

getOptDisPath(X,X,[X],0,[],0,0):- !.
getOptDisPath(X,Y,DP,Dmin,BD,TD,CD):-
    % Find all possible paths in terms of tuples [distance, path, bus, time, cost]
    findall([D,P,B,T,C],path(X,Y,P,_,D,T,C,B),SD),
    % Sort the list of tuples by distance
    sort(SD,SortedDP),
    % Get the first tuple which is the optimal distance path which has the least travelling distance to destination
    SortedDP = [[Dmin,DP,BD,TD,CD]|_].

% Find all possible paths between the cities and get the optimum path based on time
% If the given source and destination are same then the path will be just the city and the distance, time and cost will be 0

getOptTimePath(X,X,[X],0,[],0,0):- !.
getOptTimePath(X,Y,TP,Tmin,BT,DT,CT):-
    % Find all possible paths in terms of tuples [time, path, bus, distance, cost]
    findall([T,P,B,D,C],path(X,Y,P,_,D,T,C,B),ST),
    % Sort the list of tuples by time
    sort(ST,SortedTP),
    % Get the first tuple which is the optimal time path which takes least time to reach the destination 
    SortedTP = [[Tmin,TP,BT,DT,CT]|_].

% Find all possible paths between the cities and get the optimum path based on cost
% If the given source and destination are same then the path will be just the city and the distance, time and cost will be 0

getOptCostPath(X,X,[X],0,[],0,0):- !.
getOptCostPath(X,Y,CP,Cmin,BC,TC,DC):-
    % Find all possible paths in terms of tuples [cost, path, bus, distance, time]
    findall([C,P,B,D,T],path(X,Y,P,_,D,T,C,B),SC),
    sort(SC,SortedCP),
    % Get the first tuple which is the optimal cost path which costs minimum to reach the destination
    SortedCP = [[Cmin,CP,BC,DC,TC]|_].

% Find path between two cities, correspoding distance, time and cost, and the bus numbers
path(X,Y,[X,Y],Temp,D,T,C,[B]):-  
    % Find bus number, distance, time and cost to travel between X and Y places when the variable Temp i.e. arrival time is not instantiated
    \+(\+(Temp=0)),
    \+(\+(Temp=1)), 
    bus(B,X,Y,Dep,Arr,D,C),
    T is Arr-Dep;
    % Find bus number, distance, time and cost to travel between X and Y places when arrival time is instantiated 
    \+(\+(\+(Temp=0))),
    \+(\+(\+(Temp=1))),
    bus(B,X,Y,Dep,Arr,D,C),
    T is Arr-Dep,
    Dep >= Temp.

% Check all possible intermediate cities till to find the path between two cities which are not directly connected until the destination is not reached 
path(X,Y,[X|W],_,D,T,C,[B1|Bus]):- 
    bus(B1,X,Z,Dep1,Arr1,D1,C1),
    T1 is Arr1-Dep1,
    % Recursive call to get all possible intermediate cities
    path(Z,Y,W,Arr1,D2,T2,C2,Bus), 
    % Calculate the distance, time, cost along the path
    D is D1 + D2,
    T is T1 + T2,
    C is C1 + C2.

% Find all optimum paths and print the paths along with the correspoding bus numbers, distance, time and cost
route(From,To):-
    % Get optimal route based on distance
    getOptDisPath(From,To,DisPath,Distance,Bd,Td,Cd),
    % Print the optimal path based on ditance
    write("Optimum Distance:"),nl,
    writef('Optimum path is %w with buses travelling through the path = %w\n', [DisPath, Bd]),
    writef('Distance: %w, Time: %w, Cost: %w\n',[Distance,Td,Cd]),nl,
    % Get optimal route based on time 
    getOptTimePath(From,To,TimePath,Time,Bt,Dt,Ct),
    % Print the optimal path based on time
    write("Optimum Time:"),nl,
    writef('Optimum path is %w with buses travelling through the path = %w\n', [TimePath, Bt]),
    writef('Distance: %w, Time: %w, Cost: %w\n',[Dt,Time,Ct]),nl,
    % Get optimal route based on cost
    getOptCostPath(From,To,CostPath,Cost,Bc,Tc,Dc),
    % Print the optimal path based on cost
    write("Optimum Cost:"),nl,
    writef('Optimum path is %w with buses travelling through the path = %w\n', [CostPath, Bc]),
    writef('Distance: %w, Time: %w, Cost: %w\n',[Dc,Tc,Cost]),nl;
    writef('There is no path from %w to %w\n', [From, To]).

