Assignment 2

Run the prolog programs by using the following commands for the respective questions:

Q1.Finding Relationship and Gender

$cd FindRelationGender
$swipl -s Main.pl
?- uncle(kattappa,avantika).
?- halfsis(shivkami,avantika).

Sample testcases :-
?-uncle(kattappa,A).
?-uncle(jatin, avantika).
?-uncle(A, B).
?-halfsis(A, shivkami).
?-halfsis(A, B).

If you are giving a testcase of type uncle(A,B) where A or B are not in the knowledge base then keep pressing ';' to get all the possible values of A and B until false is displayed. For example consider the testcase halfsis(A,B). then you get the following output-

?- halfsis(A,B).
A = shivkami,
B = avantika ;
A = avantika,
B = shivkami ;
false.


Q2.Bus Travel Planner

$ cd BusTravelPlanner
$ swipl -s Main.pl
?-route('A','F').
press Enter to check for another testcase.

Here are some of the sample testcases to check the outputs considering all the cases.

Sample testcases :-
?-route('A','A').
?-route('A','B').
?-route('A','F').
?-route('A','G').
?-route('B','A').
?-route('B','F').
?-route('B','G').
?-route('H','I').

After running the above commands Optimum distance, time and cost paths will be displayed along with the bus numbers and the other details (distance, time and cost).


Q3.Prisoner Escape Problem

$ cd PrisonerEscape
$ swipl -s Main.pl
?-printAllPaths(X). 									(For part 3.1)

After running the above commands all the possible paths will be displayed for the prisoner to escape from the jail.

?-optimal(X).       									(For part 3.2)

Optimal path will be displayed along with the minimum distance that needs to be travelled for the prisoner to escape from the jail.

?-valid([g1,g6,g8,g9,g8,g7,g10,g15,g13,g14,g18,g17]).   (For part 3.3)

Checks whether the path is valid or not in terms of escaping from the jail.

Sample testcases ;-
?- valid([g1]).
?- valid([g2,g5,g1,g6,g8]).
?- valid([g4,g6,g12,g11,g15,g13,g14,g17]).
?- valid([]).
?- valid([g4,g6,g12,g11,g13,g14,g17]).

