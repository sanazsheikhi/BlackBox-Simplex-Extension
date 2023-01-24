function [] = displayTraj( x, y ,vx, vy, switches)
    displayInitState( x, y, vx, vy, 1, [0,1,0])
    xlim([-21 21])
    ylim([-21 21])
    plot(x, y, 'LineWidth', 1.0, 'Color', [0.5 0.5 0.5])
    displayInitState( x, y, vx, vy, size(x, 1), [1,0,0])

    display_reverse_switch( x, y, vx, vy, switches, [0.5 0.5 0.5])


    axis equal
    %set(gcf, 'Position', get(0, 'Screensize'))
    set(gcf, 'Position', [400 400 400 400])
end

