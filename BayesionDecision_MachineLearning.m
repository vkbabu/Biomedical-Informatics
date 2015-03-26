clear all
clc
close all

%PROBLEM 1

%Problem 1a

%define the groups. gene 1 expression in row 1, gene 2 expression in row 2
g1 = [10.95 6.58 5.49 7.23 8.06 7.8 9.98 10.15 10.41 9.72 9.22 10.04;9.88 10.66 10.76 10.37 10.26 10.23 9.79 10.04 9.83 9.82 10.2 9.78];
g2 = [10.76 9.37 8.84 9.22 9.23 10.8 10.85 10.05 10.52 10.12 9.38 11.48;10.34 10.31 10.56 10.37 10.18 10.04 9.83 10.18 10.34 9.86 10.17 9.76];
%grab g1 and g2 lengths
n1=length(g1);
n2=length(g2);
%calc sum of g1 and g2 rows
sum_g1 = sum(g1,2);
sum_g2 = sum(g2,2);
%calc means of g1 and g2
disp('Problem 1a')
disp('The following means and covariences for g1 and g2:') 
mean_g1 = (1/12)*sum_g1
mean_g2 = (1/12)*sum_g2
%calc covariance for g1
sum_c11 = 0;
sum_c12 = 0;
sum_c22 = 0;
%calc the elements of the g1 covarianc array
for i = 1:length(g1)
    x1 = g1(1,i);
    m1 = mean_g1(1,1);
    x2 = g1(2,i);
    m2 = mean_g1(2,1);
    sum_c11 = sum_c11 + (x1-m1)^2;
    sum_c12 = sum_c12 + ((x1-m1)*(x2-m2));
    sum_c22 = sum_c22 + (x2-m2)^2;
end
%technically don't need this, can use sum_c12 but to make steps clear kept
%this in
sum_c21 = sum_c12;
C1 = [(1/n1)*sum_c11 (1/n1)*sum_c12; (1/n1)*sum_c21 (1/n1)*sum_c22]
%C1_check = cov(g1(1,:),g1(2,:))
%calc covariance for g2
sum_c11 = 0;
sum_c12 = 0;
sum_c22 = 0;
%calc the elements of the g2 covariance array
for i = 1:length(g2)
    %i;
    x1 = g2(1,i);
    m1 = mean_g2(1,1);
    x2 = g2(2,i);
    m2 = mean_g2(2,1);
    sum_c11 = sum_c11 + (x1-m1)^2;
    sum_c12 = sum_c12 + ((x1-m1)*(x2-m2));
    sum_c22 = sum_c22 + (x2-m2)^2;
end
%technically don't need this, can use sum_c12 but to make steps clear kept
%this in
sum_c21 = sum_c12;
C2 = [(1/n2)*sum_c11 (1/n2)*sum_c12; (1/n2)*sum_c21 (1/n2)*sum_c22]
%C2_check = cov(g2(1,:),g2(2,:))

%Problem 1b

%plot 2D PDFs
%grabbing min/max values from g1 gene 1 and gene 2 expressions
g1minx=min(g1(1,:));g1maxx=max(g1(1,:));
g1miny=min(g1(2,:));g1maxy=max(g1(2,:));
%creating set of numbers with min/max values for meshgrid
g1X1 = linspace(g1minx,g1maxx);g1X2 = linspace(g1miny,g1maxy);
[gene1,gene2] = meshgrid(g1X1,g1X2);
g1_pdf = mvnpdf([gene1(:) gene2(:)],mean_g1',C1);
g1_pdf = reshape(g1_pdf,length(g1X2),length(g1X1));
%plot g1 and g2 PDFs
figure(1);
surf(g1X1,g1X2,g1_pdf);
title('Problem 1b: Group 1 & 2 2D PDF')
xlabel('Gene 1 Expression'); 
ylabel('Gene 2 Expression'); 
zlabel('Probability Density');
hold on;
%setting x and y planes for g2 2D PDF
%grabbing min/max values from gene 1 and gene 2
g2minx=min(g2(1,:));g2maxx=max(g2(1,:));
g2miny=min(g2(2,:));g2maxy=max(g2(2,:));
%creating set of numbers with min/max values for meshgrid
g2X1 = linspace(g2minx,g2maxx);g2X2 = linspace(g2miny,g2maxy);
[gene1,gene2] = meshgrid(g2X1,g2X2);
g2_pdf = mvnpdf([gene1(:) gene2(:)],mean_g2',C2);
g2_pdf = reshape(g2_pdf,length(g2X2),length(g2X1));
surf(g2X1,g2X2,g2_pdf);
hold off;

%Problem 1c

%plot scatter plots for g1 and g2
figure(2);
scatter(g1(1,:),g1(2,:),'k','x')
hold on;
scatter(g2(1,:),g2(2,:),'b','o')
%making 24x2 matrix for classify fct
training_data = [g1';g2'];
g1_ones = ones(12,1);g2_zeros = zeros(12,1);labels = [g1_ones;g2_zeros];
%Solving for the coefficients of the Bayesian
[C, err, P, logp, coeff] = classify(training_data,training_data,labels,'quadratic');
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = @(x,y) K + [x y]*L + sum(([x y]*Q).*[x y],2);
%grabbing the min and max values of training and testing data since you
%want the bayesian line to go thru all data
h2 = ezplot(f,[5.41 11.66 9.5 11.31]);

%PROBLEM 2

%Problem 2a

%define groups
test_g1 = [10.3 8.41 9.72 5.41 9.45 9.26 10.16 10.92 10.83 9.26;10.05 10.03 10.66 11.31 10.74 9.64 9.83 9.75 10.17 9.81];
test_g2 = [11.3 10.9 10.28 10.52 10.82 11.7 11 11.3 11.04 11.66;9.56 10.48 9.88 10.08 10.29 10.43 9.63 9.5 9.72 9.91];
%arrays holding decision values for test groups 1 and 2
dec_test_g1 = zeros(1,10);
dec_test_g2 = zeros(1,10);
%values initialized for Se and Sp
TP = 0;
FN = 0;
FP = 0;
TN = 0;
%initializing arrays for classified and misclassified test g1 and g2 gene
%expression values
test_g1x1_right = [];
test_g1x2_right = [];

test_g1x1_wrong = [];
test_g1x2_wrong = [];

test_g2x1_right = [];
test_g2x2_right = [];

test_g2x1_wrong = [];
test_g2x2_wrong = [];
%loop that iterates thru ground 1 and 2 test data sorts determines
%classifications
for i = 1:length(test_g1)
    %setting decision values for test data g1 and g2
    dec_test_g1(1,i) = -.5*(test_g1(:,i))'*(inv(C1))*(test_g1(:,i))+(test_g1(:,i))'*(inv(C1))*(mean_g1)-.5*(mean_g1)'*(inv(C1))*(mean_g1)+.5*(test_g1(:,i))'*(inv(C2))*(test_g1(:,i))-(test_g1(:,i))'*(inv(C2))*(mean_g2)+.5*(mean_g2)'*(inv(C2))*(mean_g2)-.5*(log(det(C1)))+.5*(log(det(C2)));
    dec_test_g2(1,i) = -.5*(test_g2(:,i)')*(inv(C1))*(test_g2(:,i))+(test_g2(:,i)')*(inv(C1))*(mean_g1)-.5*(mean_g1')*(inv(C1))*(mean_g1)+.5*(test_g2(:,i)')*(inv(C2))*(test_g2(:,i))-(test_g2(:,i)')*(inv(C2))*(mean_g2)+.5*(mean_g2')*(inv(C2))*(mean_g2)-.5*(log(det(C1)))+.5*(log(det(C2)));
    %Group 1 decision values should be positive. If it is, then data points are
    %correctly classified, increment TP
    if dec_test_g1(1,i) > 0
        test_g1x1_right = [test_g1x1_right test_g1(1,i)];
        test_g1x2_right = [test_g1x2_right test_g1(2,i)];
        TP = TP + 1;
    %If group 1 decision value negative, missclassified. increment FN
    else
        test_g1x1_wrong = [test_g1x1_wrong test_g1(1,i)];
        test_g1x2_wrong = [test_g1x2_wrong test_g1(2,i)];
        FN = FN + 1;
    end
    %Group 2 decision values should be negative. If it is, then data points are
    %correctly classified, increment TN
    if dec_test_g2(1,i) < 0
        test_g2x1_right = [test_g2x1_right test_g2(1,i)];
        test_g2x2_right = [test_g2x2_right test_g2(2,i)];
        TN = TN + 1;
    %If group 2 decision value positive, misclassified. increment FP
    else
        test_g2x1_wrong = [test_g2x1_wrong test_g2(1,i)];
        test_g2x2_wrong = [test_g2x2_wrong test_g2(2,i)];
        FP = FP + 1;
    
    end
end
%take correct/misclassified x1 and x2 values and place into
%correct/misclassified arrays for scatter plot
test_g1_right = [test_g1x1_right;test_g1x2_right];
test_g2_right = [test_g2x1_right;test_g2x2_right];

test_g1_wrong = [test_g1x1_wrong;test_g1x2_wrong];
test_g2_wrong = [test_g2x1_wrong;test_g2x2_wrong];
%Se and Sp values based on TP, FP, TN, FN
disp('Problem 2a')
disp('The following are the test data classification accuracy, sensitivity, and specificity:') 
testg1_Acc = length(test_g1_right)/length(test_g1)
testg2_Acc = length(test_g2_right)/length(test_g2)
Se = TP/(TP+FN)
Sp = 1-(FP/(FP+TN))

%Problem 2b

I_fct = 0;
%Need to check each individual decision value in g1 with every decision value
%in g2. Need nested for loop
for i = 1:length(dec_test_g1)
    for j = 1:length(dec_test_g2)
        I_fct = I_fct + (dec_test_g1(1,i) > dec_test_g2(1,j)) + (dec_test_g1(1,i) == dec_test_g2(1,j));
    end
end
disp('Problem 2b')
disp('The Area Under the Receiver-Operator Characteristic Curve:') 
AUC = (1/(length(dec_test_g1)*length(dec_test_g2)))*(I_fct)

%Problem 2c

%Plot the classified/misclassified values of test g1 and g2. Labeling the
%correctly classified values green and misclassified red.
scatter(test_g1_right(1,:),test_g1_right(2,:),'g','x')
scatter(test_g1_wrong(1,:),test_g1_wrong(2,:),'r','x')
scatter(test_g2_right(1,:),test_g2_right(2,:),'g','o')
scatter(test_g2_wrong(1,:),test_g2_wrong(2,:),'r','o')
title('Problem 1c & 2c: Gene Expression Training & Test Data Scatterplot and Decision Boundary');
xlabel('Gene 1 Expression'); 
ylabel('Gene 2 Expression');
legend('Training Group 1','Training Group 2','Decision Line','Test Group 1 Correct','Test Group 1 Incorrect','Test Group 2 Correct','Test Group 2 Incorrect');
hold off;