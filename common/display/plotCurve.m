function [h] = plotCurve(A, xLabel, yLabel, lw, Num)
h = plot(A, 'LineWidth', lw);
title([yLabel ' vs ' xLabel ' for ' num2str(Num) ' birds.'],'FontSize', 18);
xlabel(xLabel,'FontSize', 17);
ylabel(yLabel,'FontSize', 17);
ax = gca;
ax.FontSize = 15;
set(gcf, 'Position', get(0, 'Screensize'))
end

