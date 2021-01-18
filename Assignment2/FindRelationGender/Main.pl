% knowledge base
% Relationship between two persons and also their gender
parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).
male(kattappa).
male(jolly).
male(bahubali).
female(shivkami).
female(avantika).

% Finding whether X is uncle of Y.
uncle(X,Y):-
	% X should be male and there should exist a person say Z such that Y is the grand child of Z and Z is the parent of X.
	male(X),parent(Z,X),parent(Z,W),parent(W,Y).

% Finding whether X is half sister of Y.
halfsis(X,Y):-
	% X should be female and there should exist a person Z such that Z is the parent of both X and Y but the other parent of X and Y must be dfferent. 
	female(X),parent(Z,X),parent(Z,Y),parent(W,X),parent(V,Y),
	X \= Y,W \= V,Z \= W,Z \= V.
	