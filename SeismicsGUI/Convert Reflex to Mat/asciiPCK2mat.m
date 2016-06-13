% reads ascii .PCK file, writes out .mat pick file that can be read with
% load command

D = dlmread('307_____.PCK');
x = D(:,1);
t = D(:,3);

save('picks307.mat','x','t');