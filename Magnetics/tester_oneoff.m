clear all
clc

%  Q= input('Grid data? [Y/N]...  ','s');
% if isempty(Q)
%     Q= 'Y';
%    elseif Q== 'Y'
%    disp('gridded')
% end
T=[];
for N = (1:input('Number of datasets?   '))
    [A]= matrixadder_tester(input('Enter C value. '));
    T= vertcat(T,A);
end 