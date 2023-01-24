function max1 = PlotMaxPWDist(x, y, params)
    maxPW = zeros(params.steps, 1);
    for index = 1:params.steps
        xc = x(index,:);
        yc = y(index,:);
        maxPW(index) = MaxPairwiseDistance( xc, yc );
    end
    max1 = plot(maxPW , 'LineWidth', 1.5, 'LineStyle', '-');
    title(['Max pairwise distance vs time Graph for ' num2str(params.n) ' birds.'],'FontSize', 19);
    xlabel('Time Steps','FontSize', 18);
    ylabel('Distance','FontSize', 18);
    ax = gca;
    ax.FontSize = 15;
end