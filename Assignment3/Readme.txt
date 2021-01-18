Assignment 3

Run the haskell programs by using the following commands for the respective questions:

Q1.Implement Haskell Functions for Basic Set Operations

$cd HaskellFunctions
$ghci
Prelude> :load "Main.hs"
*Main> ifEmpty s1 
*Main> unionSets s1 s2 
*Main> intersectSets s1 s2 
*Main> subtractSets s1 s2 
*Main> addSets [1,2,3] [4] //Give two lists of numbers 
(For quitting)
*Main> :q

Here s1 s2 are the sets created in the Main.hs file and there are also other sets s3,s4,s5,s6 and s7 which can be tried upon to check whether a set is empty or not, union of two sets, intersection of two sets, subtraction of two sets and the addition of two sets. Use the above commands to do all the operations.


Q2.IITG Football League

$cd IITGFootballLeague
$ghci
Prelude> :load "Main.hs"
*Main> fixture "all" 
*Main> fixture "BS" 
*Main> nextMatch 1 "13:25"
*Main> :q

Use the above commands to display the entire fixture, match details about any particular team and the next match details respectively. 

Q3.House Planner

$cd HousePlanner
$ghci
Prelude> :load "Main.hs"
*Main> design a b h

Here 'a' is the total area and 'b' is the number of bedrooms and 'h' is the number of halls. Dimensions of all the components will be displayed if the design exists else "No design possible for the given
constraints" will be displayed.

															