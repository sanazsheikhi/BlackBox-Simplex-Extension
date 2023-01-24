function [] = display_traj_policy(x, y, policy, steps, colors)
    for i = 1:steps - 1
        st = (i);
        ed = (i+1);
        if policy(i) == 2
            lw = 3.0;
        else
            lw = 1.5;
        end
        plot([x(st,:); x(ed,:)], [y(st,:); y(ed,:)],'LineWidth', lw, 'Color', colors(policy(i),:))
        hold on
    end
end
