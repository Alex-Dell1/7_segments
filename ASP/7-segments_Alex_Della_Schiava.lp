segment(1..7).
stick(isU; isD; isC; isL).
digit(0..9).

% Calculating the number of displays based on the assumption described in the report
display(1..((n+1)/3)*((n/2)+(n\2))).

%%%% Generate %%%%

% Each segment of each display can either be lit or not.
0 { isLit(D,S) } 1 :- display(D), segment(S).

isLit(D,S) :- isLit(D,S,_), display(D), segment(S).

1 { isLit(D,S,ST) : stick(ST) } 1 :- isLit(D,S), display(D), segment(S).

%%%% Define %%%%

hasDigit(D,0) :-
	isLit(D,1),
	isLit(D,2),
	isLit(D,3),
	not isLit(D,4),
	isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,1) :-
	not isLit(D,1),
	not isLit(D,2),
	isLit(D,3),
	not isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	not isLit(D,7),
	display(D).

hasDigit(D,2) :-
	isLit(D,1),
	not isLit(D,2),
	isLit(D,3),
	isLit(D,4),
	isLit(D,5),
	not isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,3) :-
	isLit(D,1),
	not isLit(D,2),
	isLit(D,3),
	isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,4) :-
	not isLit(D,1),
	isLit(D,2),
	isLit(D,3),
	isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	not isLit(D,7),
	display(D).

hasDigit(D,5) :-
	isLit(D,1),
	isLit(D,2),
	not isLit(D,3),
	isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,6) :-
	isLit(D,1),
	isLit(D,2),
	not isLit(D,3),
	isLit(D,4),
	isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,7) :-
	isLit(D,1),
	not isLit(D,2),
	isLit(D,3),
	not isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	not isLit(D,7),
	display(D).

hasDigit(D,8) :-
	isLit(D,1),
	isLit(D,2),
	isLit(D,3),
	isLit(D,4),
	isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

hasDigit(D,9) :-
	isLit(D,1),
	isLit(D,2),
	isLit(D,3),
	isLit(D,4),
	not isLit(D,5),
	isLit(D,6),
	isLit(D,7),
	display(D).

%%%% TEST %%%%

% Constraining number of sticks for each shape
0 { isLit(D,S,isU) : display(D), segment(S) } u.
0 { isLit(D,S,isD) : display(D), segment(S) } d*2.
0 { isLit(D,S,isC) : display(D), segment(S) } c*2.
0 { isLit(D,S,isL) : display(D), segment(S) } l*3.

% Constraining D-shaped sticks
:- isLit(D,2,isD), not isLit(D,5,isD), display(D).
:- isLit(D,5,isD), not isLit(D,2,isD), display(D).
:- isLit(D,3,isD), not isLit(D,6,isD), display(D).
:- isLit(D,6,isD), not isLit(D,3,isD), display(D).

:- isLit(D,1,isD), display(D).
:- isLit(D,4,isD), display(D).
:- isLit(D,7,isD), display(D).

% Constraining C-shaped sticks
% If a stick is of type C, there has to be another one with which it forms a corner
:- isLit(D,1,isC), not isLit(D,2,isC), not isLit(D,3,isC), display(D).
:- isLit(D,2,isC), not isLit(D,1,isC), not isLit(D,4,isC), display(D).
:- isLit(D,3,isC), not isLit(D,1,isC), not isLit(D,4,isC), display(D).
:- isLit(D,4,isC), not isLit(D,2,isC), not isLit(D,3,isC), not isLit(D,5,isC), not isLit(D,6,isC), display(D).
:- isLit(D,5,isC), not isLit(D,4,isC), not isLit(D,7,isC), display(D).
:- isLit(D,6,isC), not isLit(D,4,isC), not isLit(D,7,isC), display(D).
:- isLit(D,7,isC), not isLit(D,5,isC), not isLit(D,6,isC), display(D).

% Removing overlaps of 2 C-shapes with three sticks
number_c(D,C) :- C = #count{ S : isLit(D,S,isC), display(D) }, display(D).
:- number_c(D,C), C\2!=0, display(D).

isLit(D,1,isC) :- isLit(D,2,isC), isLit(D,3,isC).
isLit(D,4,isC) :- isLit(D,2,isC), isLit(D,3,isC).
isLit(D,4,isC) :- isLit(D,5,isC), isLit(D,6,isC).
isLit(D,7,isC) :- isLit(D,5,isC), isLit(D,6,isC).

% Constraining L-shaped sticks
:- isLit(D,2,isL), not isLit(D,5,isL), display(D).
:- isLit(D,5,isL), not isLit(D,2,isL), display(D).
:- isLit(D,3,isL), not isLit(D,6,isL), display(D).
:- isLit(D,6,isL), not isLit(D,3,isL), display(D).

:- isLit(D,2,isL), isLit(D,5,isL), not isLit(D,1,isL), not isLit(D,7,isL), display(D).
:- isLit(D,3,isL), isLit(D,6,isL), not isLit(D,1,isL), not isLit(D,7,isL), display(D).

:- isLit(D,1,isL), not isLit(D,2,isL), not isLit(D,5,isL), not isLit(D,3,isL), not isLit(D,6,isL), display(D).
:- isLit(D,7,isL), not isLit(D,2,isL), not isLit(D,5,isL), not isLit(D,3,isL), not isLit(D,6,isL), display(D).

:- isLit(D,2,isL), isLit(D,5,isL), isLit(D,3,isL), isLit(D,6,isL), not isLit(D,1,isL), not isLit(D,7,isL), display(D).

:- isLit(D,4,isL), display(D).

% Symmetry breaking
:- hasDigit(D1,G1), hasDigit(D2,G2), G1 < G2, D1 < D2, display(D1), display(D2), digit(G1), digit(G2).

:- display(D1), display(D2), not hasDigit(D1, _), hasDigit(D2,G), digit(G), D1 < D2.

:- hasDigit(D,2), display(D).

digitsNum(N) :- N = #count{ I, D : hasDigit(D,I), display(D), digit(I) }.
digitsSum(S) :- S = #sum{ I, D : hasDigit(D,I), display(D), digit(I) }.
#maximize{ N * (((n+1)/3)*((n/2)+(n\2)) * 9) + S : digitsNum(N), digitsSum(S) }.

% Display
#show hasDigit/2. #show digitsNum/1. #show digitsSum/1. #show isLit/2. #show isLit/3.