function [k,MI ] = GPS2MagMatch(Gtime,Mtime)
%arrivals2origin match matches all the arrivals in the waveform object to
%its respective origin time for later exploration of the origin catalog
%
%   Outputs the indices of the origin time matrix that matches the arrival
%   times within the waveform object.
%     Gmatch = zeros(1,length(Gtime));
%     
%     for i = 1:length(Gtime)
%         for n = 1:length(Mtime)
%             if Gtime(i)==Mtime(n)
%                 Gmatch(i,n) = Gtime(i);
%             else Gmatch(i,n) =0;
%                 
%             end
%         end
%     end
%     
%     r = Gmatch~=0;
%     match = Gmatch(r);
%     
%     MI = zeros(1,length(match));
%     
%     for n = 1:length(match)
%         MI(n) = find(Mtime==match(n));
%     end
% MI = find(MI~=0);
%      k = zeros(1,length(match));
%     for t = 1:length(match);
%         k(t) = find(Gtime==match(t));
%     end
%     
    
% simpler matching algorithm?
    [k,LM] = ismember(Gtime,Mtime);
    
    M = setdiff(LM,0);
    
    Time = Gtime(k);
    if numel(M)==numel(Time);
        MI=setdiff(LM,0);
    else
        [LG,MI] = ismember(Mtime,Time);
        MI = setdiff(MI,0);
    end

end

