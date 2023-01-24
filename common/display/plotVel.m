function [] = plotVel( vx, vy )
xLabel = 'Time';
yLabel = 'velocity';
Num = size(vx,2);
for i = 1:Num
    A = sqrt(vx(:,i).^2 + vy(:,i).^2);
    plotCurve(A, xLabel, yLabel, 1.3, Num);
    hold on
end
hold off
end

