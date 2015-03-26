clear all
close all
clc
%CODE FOR PROBLEM 1

%PROBLEM 1A
numbers = randn(10000,1);%random set of 10k numbers
h = hist(numbers,50);%creating histogram object w/those numbers and 50 bins
%mean and std dev of num set
numbers_mean = mean(numbers);
stdDev = std(numbers);
disp('Problem 1a');
disp(['The mean of the normally distributed random numbers is: ', num2str(numbers_mean)]);
disp(['The standard deviation of the normally distributed random numbers is: ', num2str(stdDev)]);
%PROBLEM 1B
%creating empty value for the number 1, 2, 3 std dev's from mean
stdDevOne = 0;
stdDevTwo = 0;
stdDevThree = 0; 
%values for 1, 2, 3 std dev's from mean
%1 dev from mean
oneDevLower = numbers_mean - stdDev;
oneDevUpper = numbers_mean + stdDev;
%2 dev from mean
twoDevLower = numbers_mean - 2*stdDev;
twoDevUpper = numbers_mean + 2*stdDev;
%3 dev from mean
threeDevLower = numbers_mean - 3*stdDev;
threeDevUpper = numbers_mean + 3*stdDev;
%for all all numbers
for i = 1:10000
    %if number in btw 1 std dev of mean, increment value
    if (oneDevLower < numbers(i,1)) && (oneDevUpper > numbers(i,1))
        stdDevOne = stdDevOne + 1;
    %else if number in btw 2 std dev of mean, increment value
    elseif (twoDevLower < numbers(i,1)) && (twoDevUpper > numbers(i,1))
        stdDevTwo = stdDevTwo + 1;
    %else if number in btw 3 std dev of mean, increment value HAVE to
    %include this since some numbers in array are outside 3 std devs from
    %mean
    elseif (threeDevLower < numbers(i,1)) && (threeDevUpper > numbers(i,1))
        stdDevThree = stdDevThree + 1;
    end
end
%display percentages of values 1,2,3 std devs from mean
oneMean = 100*(stdDevOne/10000);
disp('Problem 1b');
disp(['The percentage of numbers within 1 std dev of mean: ', num2str(oneMean)]);
twoMean = 100*((stdDevOne+stdDevTwo)/10000);
disp(['The percentage of numbers within 2 std devs of mean: ', num2str(twoMean)]);
threeMean = 100*((stdDevOne+stdDevTwo+stdDevThree)/10000);
disp(['The percentage of numbers within 3 std devs of mean: ', num2str(threeMean)]);
%PROBLEM 1C
%creating x and y values for std dev lines
x_oneLow = [oneDevLower oneDevLower];
x_oneUp = [oneDevUpper oneDevUpper];
x_twoLow = [twoDevLower twoDevLower];
x_twoUp = [twoDevUpper twoDevUpper];
x_threeLow = [threeDevLower threeDevLower];
x_threeUp = [threeDevUpper threeDevUpper];
y_val = [0 max(h)];
%plotting data
figure(1);
histogram(numbers,50);
hold on;
plot_1c = plot(x_oneLow,y_val,'g',x_oneUp,y_val,'g',x_twoLow,y_val,'r',x_twoUp,y_val,'r',x_threeLow,y_val,'b',x_threeUp,y_val,'b');
legend(plot_1c([1 3 5]),'+/- 1 std dev from mean','+/- 2 std dev from mean','+/- 3 std dev from mean')
title('1a and 1c: 10k Normally Distributed Random Numbers Historgram and Std Dev Graph')
hold off;

%CODE FOR PROBLEM 2

%Problem 2A
nums = rand(10000,1);
nums_mean = mean(nums);
nums_stdDev = std(nums);
disp('Problem 2a');
disp(['The mean of the 10k uniformly distributed random numbers: ', num2str(nums_mean)]);
disp(['The std dev of the 10k uniformly distributed random numbers: ', num2str(nums_stdDev)]);
figure(2);
histogram(nums,50);
title('2a: 10k Uniformly Distributed Randon Numbers Histogram')
%PROBLEM 2B
%creating empty array and then adding 10000 randomly sample means
%for n = 5
fiveSampleMeans = zeros(10000,1);
for i = 1:10000
    fiveSampleMeans(i,1) = mean(rand(5,1));
end
fiveSamplesMean = mean(fiveSampleMeans);
fiveSamplesStdDev = std(fiveSampleMeans);
disp('Problem 2b');
disp(['The mean of n=5 randomly sampled array: ', num2str(fiveSamplesMean)]);
disp(['The std dev of n=5 randomly sampled array: ', num2str(fiveSamplesStdDev)]);
%plot histogram
figure(3);
histogram(fiveSampleMeans,50);
title('2b: n=5 10k Rand Mean Histogram')
%creating empty array and then adding 10000 randomly sample means
%for n = 30
thirtySampleMeans = zeros(10000,1);
for i = 1:10000
    thirtySampleMeans(i,1) = mean(rand(30,1));
end
thirtySamplesMean = mean(thirtySampleMeans);
thirtySamplesStdDev = std(thirtySampleMeans);
disp('Problem 2c');
disp(['The mean of n=30 randomly sampled array: ', num2str(thirtySamplesMean)]);
disp(['The std dev of n=30 randomly sampled array: ', num2str(thirtySamplesStdDev)]);
%plot histogram
figure(4);
histogram(thirtySampleMeans,50);
title('2c: n=30 10k Rand Mean Histogram')
%creating empty array and then adding 10000 randomly sample means
%for n = 60
sixtySampleMeans = zeros(10000,1);
for i = 1:10000
    sixtySampleMeans(i,1) = mean(rand(60,1));
end
sixtySamplesMean = mean(sixtySampleMeans);
sixtySamplesStdDev = std(sixtySampleMeans);
disp(['The mean of n=60 randomly sampled array: ', num2str(sixtySamplesMean)]);
disp(['The std dev of n=60 randomly sampled array: ', num2str(sixtySamplesStdDev)]);
%plot histogram
figure(5);
histogram(sixtySampleMeans,50);
title('2c: n=60 10k Rand Mean Histogram')
%sorted means for n=5,n=30,n=60 pdfs - required for proper calc/graph pdf
x5 = sort(fiveSampleMeans);
x30 = sort(thirtySampleMeans);
x60 = sort(sixtySampleMeans);
%norm pdf for n=5,n=30,n=60 
y5 = normpdf(x5,fiveSamplesMean,fiveSamplesStdDev);
y30 = normpdf(x30,thirtySamplesMean,thirtySamplesStdDev);
y60 = normpdf(x60,sixtySamplesMean,sixtySamplesStdDev);
figure(6);
plot(x5,y5,x30,y30,'r',x60,y60,'g')
title('2c: n=5,n=30,n=60 Normal PDFs')
legend('n=5','n=30','n=60')
