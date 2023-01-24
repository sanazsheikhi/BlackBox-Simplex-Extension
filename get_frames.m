clc
clear all
close all

%% Some on/off options
BB_plot_sequence = 1;
BB_show_vel = 1;
BB_show_acc = 0;

show_traj = 1;
traj_policy = 0;
traj_color = [0.5 0.5 0.5];

%% add paths
addpath(genpath('common'));

%% Data source
traj_num = 1;
success = 'traj_bb [2020-10-17]_4';
fail_bc = 'traj_bb [2020-10-19]_2';
reverse_switch = 'traj_bb [2020-10-24]_3';
traj_path = ['/Users/Usama/UmehmoodGoogle/Work/Code/BB-Simplex/traj/' fail_bc] ;

[newStr, matches] = split(traj_path, '/');
traj_name = [cell2mat(newStr(end)), '.mat'];

save_to = [traj_path '/frames/'];
mkdir(save_to);
destPath = save_to;

%% Load trajectory Data - from matlab code, save files, passes on: x, y, vx, vy, accx, accy, policy
load([traj_path '/' traj_name]);
x = traj(traj_num).x;
y = traj(traj_num).y;
vx = traj(traj_num).vx;
vy = traj(traj_num).vy;
accx = traj(traj_num).ax;
accy = traj(traj_num).ay;
params = traj(traj_num).params;
mpc_cost = traj.mpc_cost;
exit_flag = traj.exit_flag;
a_sequence = traj.a_sequence;
% a_ac = traj.a_ac;
controller_step = uint8(params.ct/params.dt);

cur_date = datestr(datetime,'(yyyy-mm-dd, hh-MM)');
dirName = [cur_date ' ' num2str(params.n) '_' num2str(params.steps) '_' num2str(traj_num)];
mkdir([save_to dirName]);

trail_len = params.steps; 

%%
% frames = [1, 28,  params.switch_step, 97];

frames = 97;
traj_frames = [97];

% frames = [1, 19, 31, 52, 67, 109];
% frames = 109;
% traj_frames = 109;

for frame_no = frames
    f(1) = figure;
    %% Arena
    scatter(params.tgt(1,:), params.tgt(2,:), 'x', 'MarkerEdgeColor', 'b', 'SizeData', 800);
    hold on
    
    %% pos, vel, acc
    
    acc = [accx(frame_no+1,:); accy(frame_no+1,:)];
    vel = [vx(frame_no,:) ;vy(frame_no,:)];
    pos = [x(frame_no,:) ;y(frame_no,:)];
    
    c = repmat([1 0 0], params.n, 1);
    
%     c(4,:) = [0.2, 1, 0.2];
%     c(6,:) = [0.2, 1, 0.2];
    
    s = 3600*ones(params.n,1); %Marker Area in points-squared
%     s(4) = 7200;
%     s(6) = 7200;
    p = scatter(pos(1,:), pos(2,:), s, c ,'.');
    
    pos_ = pos + 1 * vel;
    xD = [pos(1,:) ; pos_(1,:)];
    yD = [pos(2,:) ; pos_(2,:)];
    l = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
    
    xA = [pos(1,:) ; pos(1,:) + 1 * acc(1,:)];
    yA = [pos(2,:) ; pos(2,:) + 1 * acc(2,:)];
%     ac = plot(xA,yA,'g', 'LineWidth', 1); %acc plot
    
    %% state sequence
%     if BB_plot_sequence && frame_no > 1
%         [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,frame_no+1), params);
%         if frame_no == params.switch_step
%             agent_color = [1,0.6,0];
%             [str] = result_message(traj.result, params.dt);
%             disp(str);
%         else
%             agent_color = [0,0.6,0];
%         end
%         [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(frame_no+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, agent_color);
%     end
    
    if BB_plot_sequence && frame_no > 1
        if frame_no < params.switch_step
%             a_ac = traj.a_ac(:,:,frame_no+1);
            a_ac = acc;
            [next_pos, next_vel] = next_state(pos, vel, a_ac, params);
            agent_color = [1,0.6,0];
            [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(frame_no+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0.6,0]);
        elseif frame_no == params.switch_step
            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,frame_no+1), params);
            [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(frame_no+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0,1]);
            disp(result_message(traj.result, params.dt));
        else
            vel = [vx(params.switch_step - controller_step,:) ;vy(params.switch_step - controller_step,:)];
            pos = [x(params.switch_step - controller_step,:) ;y(params.switch_step - controller_step,:)];
            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,params.switch_step+1-controller_step), params);
            [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(params.switch_step+1-controller_step,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0.6,0]);
        end
    end
    %% show trajectroy
     if any(frame_no == traj_frames)
         if traj_policy
             colors = [0.6,0.6,0.6;0,0,1];
             display_traj_policy(x, y, traj.policy, params.steps, colors);
         else
            for idx = 1:params.n
            x_trail = x(max(frame_no-trail_len,1):frame_no,idx);
            y_trail = y(max(frame_no-trail_len,1):frame_no,idx);
            trail(idx) = plot(x_trail, y_trail, '-', 'Color', traj_color, 'LineWidth', 2);
            end
         end
     end
    %% set postions
    p1 = [580 8 1065 977];
    p2 = [580 196 905 789];
    p3 = [580 316 790 669];
    set(gcf, 'Position', p2);
    axis equal
    
    mx = max(get(gca, 'XTick'));
    ticks = [flip(-4:-4:-mx) 0:4:mx];
    tick_labels = arrayfun(@num2str, ticks, 'uni',0);
    
    set(gca, 'XTick', ticks);
    set(gca, 'XTickLabel', tick_labels);
    
    set(gca, 'YTick', ticks);
    set(gca, 'YTickLabel', tick_labels);
    
    set(gca, 'FontSize', 28)
        
    %% save figure
    figName = num2str(frame_no);
    savefig(gcf, [[save_to dirName '/'] figName '.fig']);
    saveas(gcf, [[save_to dirName '/'] figName '.png']);
    saveas(gcf, [[save_to dirName '/'] figName '.eps'],'epsc');
end

%% print failure messages
for ii = 1:numel(traj.result)
    disp(result_message(traj.result(ii), params.dt));
end




















