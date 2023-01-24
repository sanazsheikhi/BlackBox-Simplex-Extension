% x and y are row vectors
% res is a number i.e. the maximum pairwise distance
function [ res] = MaxPairwiseDistance( x, y )
Num = size(x,2);
curMax = 0;
for i = 1:Num-1
    for j = i+1:Num
        tempD = norm( [x(i) - x(j), y(i) - y(j)] );
        if tempD > curMax
            curMax = tempD;
        end
    end
end

res = curMax;
end