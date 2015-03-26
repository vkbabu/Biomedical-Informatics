clc
clear
close all

%PROBLEM 1A

input1 = 'CCCCCAAAGTCTATGGCACCTCCCTCCCTCTCAACCACTTGAGCAAACTCCAAGACACCTTCTACCCCAACACCAGCAATTATGCCAAGGGCCATTAGGC';
input2 = 'TTCCTCCAAGTCGATGGCACCTCCCTCCCTCTCAACCACTTGAGCAAACTCCAAGACATCTTCTACCCCAACACCAGCAATTGTGCCAAGGGCCATTAGGCTCT';
%Scoring matrix. i - rows, j - columns: 1 - A, 2 - C, 3 - G, 4 - T
scoringMatrix = [5 -4 -4 -4;-4 5 -4 -4;-4 -4 5 -4;-4 -4 -4 5];
%linear gap penalty...should be -8???
d = -8;
F = zeros(length(input1)+1,length(input2)+1);
for i=1:length(input1)
    F(i+1,1) = d*i;
end
for j=1:length(input2)
    F(1,j+1) = d*j;
end
for i=2:length(input1)+1
    for j=2:length(input2)+1
        letter1 = input1(i-1);
        letter2 = input2(j-1);
        %check to see if letter1 is A C T of G, set the scoring row index
        if letter1=='A' 
            a = 1;
        elseif letter1=='C'
            a = 2;
        elseif letter1=='G'
            a = 3;
        else
            a = 4;
        end
        %check to see if letter1 is A C T of G, set the scoring row index
        if letter2=='A' 
            b = 1;
        elseif letter2=='C'
            b = 2;
        elseif letter2=='G'
            b = 3;
        else
            b = 4;
        end
        %calculated match, delete, and insert
        match = F(i-1,j-1) + scoringMatrix(a,b);
        delete = F(i-1,j) + d;
        insert = F(i,j-1) + d;
        values = [match,delete,insert];
        sort_values = sort(values);
        %save max value
        F(i,j) = sort_values(3);
    end
end
AlignmentA_1a = '';
AlignmentB_1a = '';
i = length(input1)+1;
j = length(input2)+1;
while i > 2 || j > 2
    %get the correct indeces for the scoring matrix
    letterA = input1(i-1);
    letterB = input2(j-1);
    %check to see if letter1 is A C T of G, set the scoring row index
    if letterA=='A' 
        a = 1;
    elseif letterA=='C'
        a = 2;
    elseif letterA=='G'
        a = 3;
    else
        a = 4;
    end
    %check to see if letter1 is A C T of G, set the scoring row index
    if letterB=='A' 
        b = 1;
    elseif letterB=='C'
        b = 2;
    elseif letterB=='G'
        b = 3;
    else
        b = 4;
    end
    %match
    if i > 2 && j > 2 && F(i,j) == F(i-1,j-1) + scoringMatrix(a,b)
        AlignmentA_1a = strcat(AlignmentA_1a,letterA);
        AlignmentB_1a = strcat(AlignmentB_1a,letterB);
        i = i-1;
        j = j-1;
    %delete
    elseif i>2 && F(i,j) == F(i-1,j)+d
        AlignmentA_1a = strcat(AlignmentA_1a,letterA);
        AlignmentB_1a = strcat(AlignmentB_1a,'-');
        i=i-1;
    %insert
    elseif j>2 && F(i,j) == F(i,j-1)+d
        AlignmentA_1a = strcat(AlignmentA_1a,'-');
        AlignmentB_1a = strcat(AlignmentB_1a,letterB);
        j=j-1;
    end
end
AlignmentA_1a
AlignmentB_1a
%implement trace matrix? it will show where the bottom left value came
%from. 3 means from diagonal, 2 from left, 1 from above

%PROBLEM 1B

%use same scoring matrix and gap penalty
H = zeros(length(input1)+1,length(input2)+1);
for i=1:length(input1)
    H(i+1,1) = 0;
end
for j=1:length(input2)
    H(1,j+1) = 0;
end
for i=2:length(input1)+1
    for j=2:length(input2)+1
        letter1 = input1(i-1);
        letter2 = input2(j-1);
        %check to see if letter1 is A C T of G, set the scoring row index
        if letter1=='A' 
            a = 1;
        elseif letter1=='C'
            a = 2;
        elseif letter1=='G'
            a = 3;
        else
            a = 4;
        end
        %check to see if letter1 is A C T of G, set the scoring row index
        if letter2=='A' 
            b = 1;
        elseif letter2=='C'
            b = 2;
        elseif letter2=='G'
            b = 3;
        else
            b = 4;
        end
        %calculated match, delete, and insert
        match = H(i-1,j-1) + scoringMatrix(a,b);
        delete = H(i-1,j) + d;
        insert = H(i,j-1) + d;
        %find the max btw 3 calc values and 0
        values = [match,delete,insert,0];
        sort_values = sort(values);
        %save max value
        H(i,j) = sort_values(4);
    end
end
%find the max number from matrix H
%trace back based on max value is the same as needleman wunsch
%stop trace back when H(i,j) = 0
AlignmentA_1b = '';
AlignmentB_1b = '';
[i, j] = find(H==max(H(:)));
while H(i,j) ~= 0 
    %get the correct indeces for the scoring matrix
    letterA = input1(i-1);
    letterB = input2(j-1);
    %match = diagonal
    diag = H(i-1,j-1);
    %delete = left
    left = H(i-1,j);
    %insert = top
    top = H(i,j-1);
    %find max of these three
    values = [diag,left,top];
    sort_values = sort(values);
    %check for cases where theres a tie! take diagonal
    %save max value
    max_val = sort_values(3);
    %match
    if H(i,j) ~= 0 && i > 2 && j > 2 && max_val == diag
        AlignmentA_1b = strcat(AlignmentA_1b,letterA);
        AlignmentB_1b = strcat(AlignmentB_1b,letterB);
        i = i-1;
        j = j-1;
    %delete
    elseif H(i,j) ~= 0 && i>2 && max_val == left
        AlignmentA_1b = strcat(AlignmentA_1b,letterA);
        AlignmentB_1b = strcat(AlignmentB_1b,'-');
        i=i-1;
    %insert
    elseif H(i,j) ~= 0 && j>2 && max_val == top
        AlignmentA_1b = strcat(AlignmentA_1b,'-');
        AlignmentB_1b = strcat(AlignmentB_1b,letterB);
        j=j-1;
    end
end
AlignmentA_1b
AlignmentB_1b

%PROBLEM 1C

%find the max number from matrix H
%trace back based on max value is the same as needleman wunsch
%stop trace back when H(i,j) = 0
H2 = H;
AlignmentA_1c = '';
AlignmentB_1c = '';
%start point
[i, j] = find(H2==max(H2(:)));
%algorithm to create band width 
%indicies of first diagonal
diagRow = i;
diagCol = j;
%while there is a next diagonal
while diagRow-1 >= 1 && diagCol-1 >= 1
    leftBound = diagCol-5;
    rightBound = diagCol+5;
    %while there are indicies past bandwith
    while rightBound+1 <= length(H2)
        rightBound = rightBound+1;
        H2(diagRow,rightBound) = 0;
    end
    while leftBound-1 >= 1
        leftBound = leftBound - 1;
        H2(diagRow,leftBound) = 0;
    end
    diagRow = diagRow - 1;
    diagCol = diagCol - 1;
end
while H2(i,j) ~= 0 
    %get the correct indeces for the scoring matrix
    letterA = input1(i-1);
    letterB = input2(j-1);
    %match = diagonal
    diag = H2(i-1,j-1);
    %delete = left
    left = H2(i-1,j);
    %insert = top
    top = H2(i,j-1);
    %find max of these three
    values = [diag,left,top];
    sort_values = sort(values);
    %check for cases where theres a tie! take diagonal
    %save max value
    max_val = sort_values(3);
    %match
    if H2(i,j) ~= 0 && i > 2 && j > 2 && max_val == diag
        AlignmentA_1c = strcat(AlignmentA_1c,letterA);
        AlignmentB_1c = strcat(AlignmentB_1c,letterB);
        i = i-1;
        j = j-1;
    %place bandwhith code when you go left or up (delete or insert)
    %delete
    elseif H2(i,j) ~= 0 && i>2 && max_val == left
        AlignmentA_1c = strcat(AlignmentA_1c,letterA);
        AlignmentB_1c = strcat(AlignmentB_1c,'-');
        i=i-1;
        %algorithm to create band width 
        %indicies of first diagonal
        diagRow = i;
        diagCol = j;
        while diagRow-1 >= 1 && diagCol-1 >= 1
        leftBound = diagCol-5;
        rightBound = diagCol+5;
        %while there are indicies past bandwith
        while rightBound+1 <= length(H2)
            rightBound = rightBound+1;
            H2(diagRow,rightBound) = 0;
        end
        while leftBound-1 >= 1
            leftBound = leftBound - 1;
            H2(diagRow,leftBound) = 0;
        end
        diagRow = diagRow - 1;
        diagCol = diagCol - 1;
        end
    %insert
    elseif H2(i,j) ~= 0 && j>2 && max_val == top
        AlignmentA_1c = strcat(AlignmentA_1c,'-');
        AlignmentB_1c = strcat(AlignmentB_1c,letterB);
        j=j-1;
        %algorithm to create band width 
        %indicies of first diagonal
        diagRow = i;
        diagCol = j;
        while diagRow-1 >= 1 && diagCol-1 >= 1
        leftBound = diagCol-5;
        rightBound = diagCol+5;
        %while there are indicies past bandwith
        while rightBound+1 <= length(H2)
            rightBound = rightBound+1;
            H2(diagRow,rightBound) = 0;
        end
        while leftBound-1 >= 1
            leftBound = leftBound - 1;
            H2(diagRow,leftBound) = 0;
        end
        diagRow = diagRow - 1;
        diagCol = diagCol - 1;
        end
    end
end
AlignmentA_1c
AlignmentB_1c

%PROBLEM 1D
%1A (Needleman-Wunsch
%Algorithm) differs from 1B and 1C (Smith-Waterman Algorithm). Output
%alignments from 1B and 1C are the same. The output lengths of all outputs
%are 103 base pairs, the answer outputs proves this statement.
length(AlignmentA_1c)
length(AlignmentB_1c)
length(AlignmentA_1b)
length(AlignmentB_1b)
length(AlignmentA_1a)
length(AlignmentB_1a) 