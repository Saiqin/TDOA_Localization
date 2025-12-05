function [Value,locs] = Peaks_add(Y,num)
[Value,locs] = findpeaks(abs(Y));
[Value,Index] = sort(Value,'descend');
locs = locs(Index(1:num));
end
