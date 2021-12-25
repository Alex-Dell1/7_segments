include "globals.mzn";

int: n;
int: rows = floor((n + 1) / 3);
int: cols = ceil(n / 2);
int: blocksNumber = rows * cols;

enum sticks = { isL, isD, isC, isU, NO_STICK };

sticks: s1 = isC;
sticks: s2 = isU;

bool: prova = isC < isU;

array[1..blocksNumber, 1..7] of var sticks: isStick;

int: u;
int: d;
int: c;
int: l;

% Sum with all the 7-segments displays showing a '9'.
int: maxSum = blocksNumber * 9;

var int: digitsNum;
var int: digitsSum;

%%%%% Defining the 7-segment representations of the ten digits %%%%%

predicate isOne(int: block) =
  isStick[block, 1] = NO_STICK /\
  isStick[block, 2] = NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] = NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] = NO_STICK;
  
predicate isTwo(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] = NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] != NO_STICK /\
  isStick[block, 6] = NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isThree(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] = NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isFour(int: block) =
  isStick[block, 1] = NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] = NO_STICK;
  
predicate isFive(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] = NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isSix(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] = NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] != NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isSeven(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] = NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] = NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] = NO_STICK;
  
predicate isEight(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] != NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isNine(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] != NO_STICK /\
  isStick[block, 5] = NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;
  
predicate isZero(int: block) =
  isStick[block, 1] != NO_STICK /\
  isStick[block, 2] != NO_STICK /\
  isStick[block, 3] != NO_STICK /\
  isStick[block, 4] = NO_STICK /\
  isStick[block, 5] != NO_STICK /\
  isStick[block, 6] != NO_STICK /\
  isStick[block, 7] != NO_STICK;

predicate isNumber(int: block) =
  isOne(block) = 1 \/
  isTwo(block) = 1 \/
  isThree(block) = 1 \/
  isFour(block) = 1 \/
  isFive(block) = 1 \/
  isSix(block) = 1 \/
  isSeven(block) = 1 \/
  isEight(block) = 1 \/
  isNine(block) = 1 \/
  isZero(block) = 1;


%%%%% 'values' is an array containing the integer values of all the %%%%%
%%%%% digits shown in the 7-segments displays. It is used to order  %%%%%
%%%%% the digits and, consequently, breaking symmetries.            %%%%%

array[1..blocksNumber] of var 0..10: values;

values = [if isOne(i) then 2
  elseif isTwo(i) then 3
  elseif isThree(i) then 4
  elseif isFour(i) then 5
  elseif isFive(i) then 6
  elseif isSix(i) then 7
  elseif isSeven(i) then 8
  elseif isEight(i) then 9
  elseif isNine(i) then 10
  elseif isZero(i) then 1 
  else 0 endif | i in 1..blocksNumber];
  
constraint symmetry_breaking_constraint(decreasing(values));

%%%%% This constraint is used in order to get rid of any shapes %%%%%
%%%%% with no meaning in the displays.                          %%%%%

constraint forall(i in 1..blocksNumber)(
  isNumber(i) = 0 -> forall(j in 1..7)(isStick[i, j] = NO_STICK));
  
%%%%% Constraining sticks of type u. %%%%%
  
constraint count(i in 1..blocksNumber, j in 1..7)(isStick[i, j] ==  isU) <= u;


%%%%% Constraining sticks of type d. %%%%%

constraint forall(i in 1..blocksNumber)(
  (isStick[i, 2] = isD <-> isStick[i, 5] = isD) /\
  (isStick[i, 3] = isD <-> isStick[i, 6] = isD));
  
constraint forall(i in 1..blocksNumber)(
  isStick[i, 1] != isD /\ isStick[i, 7] != isD /\ isStick[i, 4] != isD);

% There can be at most d d-shaped sticks in the whole grid.
constraint count(i in 1..blocksNumber, j in {2, 3})(
  isStick[i, j] = isD) <= d; 

%%%%% Constraining sticks of type c %%%%%

% Defining all possible c-shaped sticks in a display.
constraint forall(i in 1..blocksNumber)(
  (isStick[i, 1] = isC -> isStick[i, 2] = isC \/ isStick[i, 3] = isC) /\
  (isStick[i, 2] = isC -> isStick[i, 1] = isC \/ isStick[i, 4] = isC) /\
  (isStick[i, 3] = isC -> isStick[i, 1] = isC \/ isStick[i, 4] = isC) /\
  (isStick[i, 4] = isC -> isStick[i, 2] = isC \/ isStick[i, 3] = isC \/ isStick[i, 5] = isC \/ isStick[i, 6] = isC) /\
  (isStick[i, 5] = isC -> isStick[i, 4] = isC \/ isStick[i, 7] = isC) /\
  (isStick[i, 6] = isC -> isStick[i, 4] = isC \/ isStick[i, 7] = isC) /\
  (isStick[i, 7] = isC -> isStick[i, 5] = isC \/ isStick[i, 6] = isC));
% Removing overlaps of c-shaped sticks
constraint forall(i in 1..blocksNumber)(
  (isStick[i, 2] = isC /\ isStick[i, 3] = isC) -> (isStick[i, 1] = isC /\ isStick[i, 4] = isC));
  
constraint forall(i in 1..blocksNumber)(
  (isStick[i, 5] = isC /\ isStick[i, 6] = isC) -> (isStick[i, 4] = isC /\ isStick[i, 7] = isC));     

constraint forall(i in 1..blocksNumber)(
  count(j in 1..7)(isStick[i, j] = isC) mod 2 = 0);  

constraint forall(i in 1..blocksNumber)(count(j in 1..7)(isStick[i, j] == isC) <= 6);      
                  
constraint count(i in 1..blocksNumber, j in 1..7)(isStick[i, j] == isC) <= 2 * c;

%%%%% Constraining l-shaped blocks. %%%%%

% Defining all possible l-shaped sticks in a display.
constraint forall(i in 1..blocksNumber)(
  (isStick[i, 2] = isL <-> isStick[i, 5] = isL) /\
  (isStick[i, 3] = isL <-> isStick[i, 6] = isL) /\
  (isStick[i, 1] = isL -> (isStick[i, 2] = isL) \/ (isStick[i, 3] = isL)) /\
  (isStick[i, 7] = isL -> (isStick[i, 2] = isL) \/ (isStick[i, 3] = isL)) /\
  ((isStick[i, 2] = isL /\ isStick[i, 3] = isL) -> (isStick[i, 1] = isL /\ isStick[i, 7] = isL)) /\
  ((isStick[i, 2] = isL /\ isStick[i, 5] = isL) -> (isStick[i, 1] = isL \/ isStick[i, 7] = isL)) /\
  ((isStick[i, 3] = isL /\ isStick[i, 6] = isL) -> (isStick[i, 1] = isL \/ isStick[i, 7] = isL)));

constraint forall(i in 1..blocksNumber)(isStick[i, 4] != isL);
  
constraint count(i in 1..blocksNumber, j in 1..7)(isStick[i, j] == isL) <= 3 * l;

constraint forall(i in 1..blocksNumber)(
  count(j in 1..7)(isStick[i, j] == isL) <= 6);

digitsNum = count(i in 1..blocksNumber)(isNumber(i));

digitsSum = sum(i in 1..blocksNumber)(
  if isOne(i) then 1
  elseif isTwo(i) then 2
  elseif isThree(i) then 3
  elseif isFour(i) then 4
  elseif isFive(i) then 5
  elseif isSix(i) then 6
  elseif isSeven(i) then 7
  elseif isEight(i) then 8
  elseif isNine(i) then 9
  else 0 endif);

% input_order is the fastest, I think it is because of the way I am breaking the symmetries.
solve :: int_search(isStick, input_order, indomain_median)
  maximize digitsNum * maxSum + digitsSum;

% solve :: seq_search([
%              int_search(values, input_order, indomain_median),
%              int_search(isStick, input_order, indomain_median)])
%              maximize digitsNum * maxSum + digitsSum;

% solve maximize digitsNum * maxSum + digitsSum;

% More Symmetry Breaking

% constraint symmetry_breaking_constraint(forall(i in 2..blocksNumber)(
%   count(j in 1..7)(isStick[i, j] == isU) <= count(k in 1..7)(isStick[i - 1, k] == isU)));

% constraint symmetry_breaking_constraint(forall(i in 2..blocksNumber)(
%   count(j in 1..7)(isStick[i, j] = isC) > 0 ->
%   countUCornersC(i-1) = 0));
  
% constraint symmetry_breaking_constraint(forall(i in 2..blocksNumber)(
%   count(j in 1..7)(isStick[i, j] = isL) > 0 ->
%   countUCornersL(i-1) = 0));
  
% constraint symmetry_breaking_constraint(forall(i in 2..blocksNumber)(
%   count(j in 1..7)(isStick[i, j] = isD) > 0 ->
%   countUCornersD(i-1) = 0));
  
% function var int: countUCornersC(int: display) =
%   bool2int(isStick[display, 1] = isU /\ isStick[display,2] = isU) + 
%   bool2int(isStick[display, 3] = isU /\ isStick[display,4] = isU) + 
%   bool2int(isStick[display, 7] = isU /\ isStick[display,6] = isU);
  
% function var int: countUCornersL(int: display) =
%   bool2int(isStick[display, 1] = isU /\ isStick[display,2] = isU /\ isStick[display,5] = isU) + 
%   bool2int(isStick[display, 3] = isU /\ isStick[display,6] = isU /\ isStick[display,7] = isU);

% function var int: countUCornersD(int: display) =
%   bool2int(isStick[display, 3] = isU /\ isStick[display,6] = isU) + 
%   bool2int(isStick[display, 2] = isU /\ isStick[display,5] = isU);
  
%%%% OUTPUT %%%%

output[show(n) ++ "x" ++ show(n) ++ " GRID"] ++
["\nA " ++ show(n) ++ "x" ++ show(n) ++ "grid can contain at most " ++ show(blocksNumber) ++ " different 7-segment display(s)."] ++ 
[
  if k = 1 /\ x = 0 then "\n" else "" endif ++
  if k = 1 /\ x = 0 /\ j = 1 then "\n" else "" endif ++
  
  % If an horizontal segment is lit
  if (j = 1 \/ j = 4 \/ j = 7) /\ fix(isStick[(i * cols) + k, j]) != NO_STICK /\ x = 0 then "### "
  
  % If an horizontal segment is not lit consider the vertical segments below
  elseif (j = 1 \/ j = 4) /\ fix(isStick[(i * cols) + k, j]) = NO_STICK /\ x = 0 /\
    fix(isStick[(i * cols) + k, j + 1]) = NO_STICK /\ fix(isStick[(i * cols) + k, j + 2]) = NO_STICK then "... "
  elseif (j = 1 \/ j = 4) /\ fix(isStick[(i * cols) + k, j]) = NO_STICK /\ x = 0 /\
    fix(isStick[(i * cols) + k, j + 1]) != NO_STICK /\ fix(isStick[(i * cols) + k, j + 2]) = NO_STICK then "#.. "
  elseif (j = 1 \/ j = 4) /\ fix(isStick[(i * cols) + k, j]) = NO_STICK /\ x = 0 /\
    fix(isStick[(i * cols) + k, j + 1]) = NO_STICK /\ fix(isStick[(i * cols) + k, j + 2]) != NO_STICK then "..# "
  elseif (j = 1 \/ j = 4) /\ fix(isStick[(i * cols) + k, j]) = NO_STICK /\ x = 0 /\
    fix(isStick[(i * cols) + k, j + 1]) != NO_STICK /\ fix(isStick[(i * cols) + k, j + 2]) != NO_STICK then "#.# "
  
  % If a horizontal segment is not lit consider the vertical segments right above
  elseif (j = 4 \/ j = 7) /\ fix(isStick[(i * cols) + k, j - 1]) != NO_STICK /\ fix(isStick[(i * cols) + k, j - 2]) != NO_STICK /\ x = 0 then "#.# "
  elseif (j = 4 \/ j = 7) /\ fix(isStick[(i * cols) + k, j - 1]) != NO_STICK /\ fix(isStick[(i * cols) + k, j - 2]) = NO_STICK /\ x = 0 then "..# "
  elseif (j = 4 \/ j = 7) /\ fix(isStick[(i * cols) + k, j - 1]) = NO_STICK /\ fix(isStick[(i * cols) + k, j - 2]) != NO_STICK /\ x = 0 then "#.. "
  elseif (j = 4 \/ j = 7) /\ fix(isStick[(i * cols) + k, j - 1]) = NO_STICK /\ fix(isStick[(i * cols) + k, j - 2]) = NO_STICK /\ x = 0 then "... "
  
  % If a vertical segment is lit (or not)
  elseif (j = 2 \/ j = 5) /\ fix(isStick[(i * cols) + k, j + x]) != NO_STICK /\ x = 0 then "#."
  elseif (j = 2 \/ j = 5) /\ fix(isStick[(i * cols) + k, j + x]) = NO_STICK /\ x = 0 then ".."
  elseif (j = 2 \/ j = 5) /\ fix(isStick[(i * cols) + k, j + x]) != NO_STICK /\ x = 1 then "# "
  elseif (j = 2 \/ j = 5) /\ fix(isStick[(i * cols) + k, j + x]) = NO_STICK /\ x = 1 then ". "
  else "" endif | i in 0..rows - 1, j in {1, 2, 4, 5, 7}, k in 1..cols, x in 0..1
] ++
[ "\n" ] ++
[
  if j = 1 then "\nDisplay[" ++ show(i) ++ "]:" else "" endif ++
  " " ++ show(isStick[i, j])  | i in 1..blocksNumber, j in 1..7
] ++
[ "\n\nNumber of digits: " ++ show(digitsNum)] ++
[ "\nSum of the digits: " ++ show(digitsSum)]