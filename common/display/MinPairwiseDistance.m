% x and y are row vectors
% res is a number i.e. the maximum pairwise distance
function [ res] = MinPairwiseDistance( x, y )
Num = numel(x);
curMin = inf;
for i = 1:Num
    for j = i+1:Num
        tempD = norm( [x(i) - x(j), y(i) - y(j)] );
        if tempD < curMin
            curMin = tempD;
        end
    end
end

res = curMin;
end