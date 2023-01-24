function min1 = plotMinPWdist(x, y, params)
    Num = params.n;
    minPW = zeros(params.steps, 1);
    for index = 1:params.steps
            xc = x(index,:);
            yc = y(index,:);
        minPW(index) = MinPairwiseDistance(xc, yc);
    end

    min1 = plot(minPW , 'LineWidth', 1.5);
    hold on;
    title(['Min pairwise distance vs time Graph for ' num2str(Num) ' birds.'],'FontSize', 19);
    xlabel('Time Steps','FontSize', 18);
    ylabel('Distance','FontSize', 18);
    ax = gca;
    ax.FontSize = 15;
end