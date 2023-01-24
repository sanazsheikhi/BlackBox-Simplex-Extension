function [] = plotAcc(accx, accy, params )
xLabel = 'Time';
yLabel = 'Acceleration';
Num = size(accx, 2);
% Revese Computation.
% A = (1/params.dt) * sqrt((vy(2:end,i) - vy(1:end-1,i)).^2 + (vx(2:end,i) - vx(1:end-1,i)).^2);
A = sqrt(accx.^2 + accy.^2); 
plotCurve(A, xLabel, yLabel, 1.5, Num);
%set(l, 'Color', 'b', 'LineStyle', '--');
end

