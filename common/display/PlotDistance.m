function [H] = PlotDistance(x, y, Steps, params )
    Num = params.n;
    plot([1, Steps], [params.dmin params.dmin], 'g--', 'LineWidth', 1.5);
    hold on
    H = gobjects(1,1);
    min1 = plotMinPWdist(x, y, params);
    max1 = PlotMaxPWDist(x, y, params);
    title(['Minimum pairwise distance vs time Graph for ' num2str(Num) ' birds.'],'FontSize', 19);

    axis([0 Steps, 0, 10]);

    H(1) = min1;
    H(2) = max1;
end