clc
clear all
close all

%% Some on/off options
BB_plot_sequence = 1;
BB_show_vel = 1;
BB_show_acc = 0;

%% add paths
addpath(genpath('common'));

%% Data source
traj_num = 1;
traj_path = '/Users/Usama/UmehmoodGoogle/Work/Code/BB-Simplex/traj/traj_bb [2020-10-23]_11';

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
a_ac = traj.a_ac;
controller_step = uint8(params.ct/params.dt);

cur_date = datestr(datetime,'(yyyy-mm-dd, hh-MM)');
dirName = [cur_date ' ' num2str(params.n) '_' num2str(params.steps) '_' num2str(traj_num)];
mkdir([save_to dirName]);

%%
frame_no = 10;
f(1) = figure;
subplot(1,2,1);
scatter(params.tgt(1,:), params.tgt(2,:), 'x', 'MarkerEdgeColor', 'b', 'SizeData', 800);
hold on

acc = [accx(frame_no+1,:); accy(frame_no+1,:)];
vel = [vx(frame_no,:) ;vy(frame_no,:)];
pos = [x(frame_no,:) ;y(frame_no,:)];

c = repmat([1 0 0], params.n, 1);
s = 3600*ones(params.n,1); %Marker Area in points-squared
p = scatter(pos(1,:), pos(2,:), s, c ,'.');

pos_ = pos + 1 * vel;
xD = [pos(1,:) ; pos_(1,:)];
yD = [pos(2,:) ; pos_(2,:)];
l = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot

xA = [pos(1,:) ; pos(1,:) + 1 * acc(1,:)];
yA = [pos(2,:) ; pos(2,:) + 1 * acc(2,:)];

if BB_plot_sequence && frame_no > 1
    if frame_no < params.switch_step
        [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,frame_no+1), params);
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
%% set postions
p2 = [580 196 905 789];
set(gcf, 'Position', p2);
axis equal
axis auto


mx = max(get(gca, 'XTick'));
ticks = [flip(-4:-4:-mx) 0:4:mx];
tick_labels = arrayfun(@num2str, ticks, 'uni',0);

set(gca, 'XTick', ticks);
set(gca, 'XTickLabel', tick_labels);

set(gca, 'YTick', ticks);
set(gca, 'YTickLabel', tick_labels);

set(gca, 'FontSize', 28)

%% output
res.pos = pos;
res.vel = vel;
res.params = params;

a_ac = traj.a_ac(:,:,frame_no+1);
b_ac = permute(squeeze(a_sequence(frame_no+1,:,:,:)), [2 1 3]);

lbc = cat(3,a_ac,b_ac);

pos_future = zeros(2, params.n, 13);
vel_future = zeros(2, params.n, 13);

pos_future(:,:,1) = pos;
vel_future(:,:,1) = vel;

for i = 1:size(lbc,3)
    [pos_future(:,:,i+1), vel_future(:,:,i+1)] = dynamics(pos_future(:,:,i), vel_future(:,:,i), lbc(:,:,i), params);
end

% Recalculate acceleration
lbc_new = zeros(size(lbc));

for k = 1:params.h_bc + 1
    lbc_new(:,:,k) = (vel_future(:,:,k+1) - vel_future(:,:,k))/params.dt;
end

%% recheck results
subplot(1,2,2);
scatter(params.tgt(1,:), params.tgt(2,:), 'x', 'MarkerEdgeColor', 'b', 'SizeData', 800);
hold on

acc = [accx(frame_no+1,:); accy(frame_no+1,:)];
vel = [vx(frame_no,:) ;vy(frame_no,:)];
pos = [x(frame_no,:) ;y(frame_no,:)];

c = repmat([1 0 0], params.n, 1);
s = 3600*ones(params.n,1); %Marker Area in points-squared
p = scatter(pos(1,:), pos(2,:), s, c ,'.');

pos_ = pos + 1 * vel;
xD = [pos(1,:) ; pos_(1,:)];
yD = [pos(2,:) ; pos_(2,:)];
l = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot

xA = [pos(1,:) ; pos(1,:) + 1 * acc(1,:)];
yA = [pos(2,:) ; pos(2,:) + 1 * acc(2,:)];

if BB_plot_sequence && frame_no > 1
    if frame_no < params.switch_step
        [next_pos, next_vel] = next_state(pos, vel, lbc_new(:,:,1), params);
        agent_color = [1,0.6,0];
        [p_seq, v_seq, a_seq] = BB_local_draw_sequence(permute(lbc_new(:,:,2:end), [2 1 3]), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0.6,0]);
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

%% set postions
p2 = [580 196 905 789];
set(gcf, 'Position', p2);
axis equal
axis auto

mx = max(get(gca, 'XTick'));
ticks = [flip(-4:-4:-mx) 0:4:mx];
tick_labels = arrayfun(@num2str, ticks, 'uni',0);

set(gca, 'XTick', ticks);
set(gca, 'XTickLabel', tick_labels);

set(gca, 'YTick', ticks);
set(gca, 'YTickLabel', tick_labels);

set(gca, 'FontSize', 28)


%% Save ouput
par.n = params.n;
par.dt = params.dt;
par.amax = params.amax;
par.vmax = params.vmax;
par.tgt = params.tgt;
par.dmin = params.dmin;

rslt.pos = pos;
rslt.vel = vel;
rslt.lbc = lbc_new;
rslt.params = par;

save('rslt.mat', 'rslt');










