function [p, l, a_h] = BB_local_draw_sequence(a_sequence, n_pos, n_vel, params, show_vel, show_acc, colr)
%%
% Input:
%   - a_sequence   % n x 2 x h - sequence of h actions of n agents
%   - pos          % 2 x n - state of the flock
%   - vel          % 2 x n - state of the flock
%   - params       % parameters

% Output:
%   - a            % 2 x n - The sequence of control action over the horizon
%   - fit_val      % cost for the optimal sequence of accelerations.
% Usama Mehmood - Sep 2020
%%

c = repmat([0 0.6 0], params.n, 1);
s = 1200*ones(params.n,1); %Marker Area in points-squared
control_steps = uint8(params.ct / params.dt);


pos = n_pos;
vel = n_vel;
for h = 1:size(a_sequence, 3)
    acc = a_sequence(:,:,h);
    %plotting
    if h == 1
%         c = repmat([0 0 0.8], params.n, 1);
        c = repmat(colr, params.n, 1);
    else
        c = repmat(colr, params.n, 1);
    end
    p(h) = scatter(pos(1,:), pos(2,:), s, c ,'.');
    
    if show_vel
        pos_ = pos + 1 * vel;
        xD = [pos(1,:) ; pos_(1,:)];
        yD = [pos(2,:) ; pos_(2,:)];
        l(:,h) = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
    else
        l = -1;
    end
    
    if show_acc
        pos_ = pos + 1 * acc';
        xD = [pos(1,:) ; pos_(1,:)];
        yD = [pos(2,:) ; pos_(2,:)];
        a_h(:,h) = plot(xD, yD, 'g', 'LineWidth', 1.3); %acc plot
    else
        a_h = -1;
    end
    
    for k = 1:control_steps
        [pos, vel] = dynamics(pos, vel, acc', params);
    end
end
%% plot final state
p(h + 1) = scatter(pos(1,:), pos(2,:), s, c ,'.');
if show_vel
    pos_ = pos + 1 * vel;
    xD = [pos(1,:) ; pos_(1,:)];
    yD = [pos(2,:) ; pos_(2,:)];
    l(:,h + 1) = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
end

%% Repeat the last action fo T steps 
% T = 9;
% for i = 1:T
%     for k = 1:control_steps
%         [pos, vel] = dynamics(pos, vel, zeros(size(pos)), params);
%     end
%     p(h + 1) = scatter(pos(1,:), pos(2,:), s, c ,'.');
%     if show_vel
%         pos_ = pos + 1 * vel;
%         xD = [pos(1,:) ; pos_(1,:)];
%         yD = [pos(2,:) ; pos_(2,:)];
%         l(:,h + 1) = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
%     end
% end

end
