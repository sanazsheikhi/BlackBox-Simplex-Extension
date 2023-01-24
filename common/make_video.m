%% Basic Plot
f = figure;
p_seq = -1;
v_seq = -1;
a_seq = -1;
controller_step = uint8(params.ct/params.dt);
fail_no = 1;

%%
iter = simulation_starting_state;

acc = [accx(iter+1,:); accy(iter+1,:)];
vel = [vx(iter,:) ;vy(iter,:)];
pos = [x(iter,:) ;y(iter,:)];

minDist = MinPairwiseDistance( x(iter,:), y(iter,:) );

axis equal
% grid on;
grid off;
ax = gca;
set(ax, 'FontSize', 28)
ax.LineWidth = 0.5;
ax.GridColor = [0.7 0.7 0.7];
ax.GridAlpha = 1;
hold on
set(gcf, 'Position', get(0, 'Screensize'))

if BB_draw_circle
    draw_circle([0,0], params.diameter);
end

%%  initPlot;
redBlue = [1 0 0; 0 0 1];
% policy(1,:) = [1,1,1,1];
if simplex_policy
    c = redBlue(policy(1), :);
else
    c = repmat([1 0 0], params.n, 1);
end
s = 2400*ones(params.n,1); %Marker Area in points-squared

%%
p = scatter(x(iter,:), y(iter,:), s, c ,'.');

if Speed == 1
    pos_ = pos + v_scale * vel;
    xD = [pos(1,:) ; pos_(1,:)];
    yD = [pos(2,:) ; pos_(2,:)];
    l = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
elseif Speed == 2
    pos_ = pos + v_scale * vel;
    xD = [pos(1,speed_agent) ; pos_(1,speed_agent)];
    yD = [pos(2,speed_agent) ; pos_(2,speed_agent)];
    l = plot(xD, yD, 'b', 'LineWidth', 1.3); %velocity plot
end

if showCircles
    for i = 1:params.n
        r(i) = rectangle('position', [pos(:,i)' - params.dmin/2 params.dmin params.dmin], 'curvature', [1 1]);
    end
end
%% Add-ons

%Acceleration
if Acceleration == 1
%     xA = [pos(1,:) ; pos(1,:) + 10*(vx(2,:)-vx(1,:))];
%     yA = [pos(2,:) ; pos(2,:) + 10*(vy(2,:)-vy(1,:))];
%     
    xA = [pos(1,:) ; pos(1,:) + Acc_scale * acc(1,:)];
    yA = [pos(2,:) ; pos(2,:) + Acc_scale * acc(2,:)];
    ac = plot(xA,yA,'g', 'LineWidth', 1); %acc plot
    
elseif Acceleration == 2
    xA = [pos(1,Acc_agent) ; pos(1,Acc_agent) + Acc_scale * acc(1,Acc_agent)];
    yA = [pos(2,Acc_agent) ; pos(2,Acc_agent) + Acc_scale * acc(2,Acc_agent)];
    ac = plot(xA,yA,'g', 'LineWidth', 1); %acc plot
end


if BB_targets_plot
    scatter(params.tgt(1,:), params.tgt(2,:), 'x', 'MarkerEdgeColor', 'b', 'SizeData', 200);
end

%% Set Window
BoxLength =BoxL * MaxPairwiseDistance(pos(1,:), pos(2,:));
limits = BoxLength/2*[-1 +1 -1 +1];
if FullBox
    height_axis = max(5, max(max(y)) - min(min(y)));
%     axis([min(min(x)) max(max(x)) min(min(y))-2.5 min(min(y)) + 1.10 * height_axis]);
    axis([min(min(x)) - 0.2 max(max(x)) + 0.2 min(min(y)) - 0.2 max(max(y)) + 0.2]);
    textposy = min(min(y)) + 1.05 * height_axis;
    textposx = min(min(x)) + 0.5 * ( max(max(x)) - min(min(x)) );
else
    axis(centre'*[1 0;1 0;0 1;0 1]' + limits);
    textpos = (7/8) * mean(abs(limits));
end

if showText
   title([ 'Minimum pairwise distance: ' num2str(round(minDist, 3)) ', Time: ' num2str(round(params.dt*(iter),1)) ' sec'], 'FontSize', 30);
end


%% Plot proximity net
if PlotEdges || pbf
%     for i = 18
    for i = 1:params.n
%         [B, I] = sort(sum((repmat(pos(:,i), 1, Num) - pos).^2,1));
        if PlotEdges == 2 && all(i ~= PlotEdgeId)
            continue;
        end
        for j = 1:params.n
            if (i == j)
                continue;
            end
            if PlotEdges
                edges(i,j) = plot( [pos(1, i), pos(1, j)] , [pos(2, i), pos(2, j)], 'Color',[0 0 0], 'LineWidth', 1.0, 'LineStyle', '-');
%                 set(edges(i,j), 'Visible', 'off');
                
                condition = norm(pos(:,i) - pos(:,j)) > params.rs;
%                 delta_p_ij =  pos(:,i) - pos(:,j);
%                 delta_v_ij =  vel(:,i) - vel(:,j);
%                 condition = barrier_function(delta_p_ij, delta_v_ij, params) > 0;
%                 
                if condition
                    set(edges(i,j), 'Visible', 'off');
                else
                    set(edges(i,j), 'Visible', 'on');
                end
            end
            
            if pbf
                pbf_edges(i,j) = plot( [pos(1, i), pos(1, j)] , [pos(2, i), pos(2, j)], 'Color',[1 0 0], 'LineWidth', 1.5, 'LineStyle', ':');
                pp = [pos(:,i)' ; pos(:,j)'];
                vv = [vel(:,i)' ; vel(:,j)'];
                res = barrierFunction( pp, vv, params.dmin, params.amax );
                disp(['res(' num2str(1) '): ' num2str(res)]);

                if res == 0 || norm(pos(:,i) - pos(:,j)) < params.dmin
                    set(pbf_edges(i,j), 'Visible', 'on'); 
                else
                    set(pbf_edges(i,j), 'Visible', 'off'); 
                end
            end
        end % j
%         if i < I(2)
%             set(edges(i,I(2)), 'Visible', 'on');
%         end
    end % i 
end % if

%% ShowID
if showID
    idtxt = num2cell(1:params.n);
    for i = 1:params.n
        idtxt{i} = num2str(idtxt{i});
    end
%     agentIDs = text(pos(1,:)', pos(2,:)'- 1.5*params.dmin, idtxt);
	agentIDs = text(pos(1,:)', pos(2,:)'- 0.25, idtxt);
end

F = getframe(f);
writeVideo(myVideo,F);
    
%% Simulation.
Flag = true; %Size change can only happen once.
for i = simulation_starting_state + 1:params.steps-1
    currkey=get(gcf,'CurrentKey');
    if currkey == 'return'
        break
    end
    if mod(i-1,skip) ~= 0
        continue;
    end
    
    acc = [accx(i+1,:); accy(i+1,:)];
    vel = [vx(i,:) ;vy(i,:)];
    pos = [x(i,:) ;y(i,:)];
    
    if PlotEdges || pbf
%         for m = 18
        for m = 1:params.n
%            [B, I] = sort(sum((repmat(pos(:,m), 1, params.n) - pos).^2,1));
            if PlotEdges == 2 && all(m ~= PlotEdgeId)
                continue;
            end
            for j = 1:params.n
 
                if (m == j)
                    continue;
                end
                
                if PlotEdges
                    set(edges(m,j), 'XData', [pos(1, m), pos(1, j)], 'YData', [pos(2, m), pos(2, j)]);
%                     set(edges(m,j), 'Visible', 'off');
                    condition = norm(pos(:,m) - pos(:,j)) > params.rs;
%                     delta_p_ij =  pos(:,m) - pos(:,j);
%                     delta_v_ij =  vel(:,m) - vel(:,j);
%                     condition = barrier_function(delta_p_ij, delta_v_ij, params) > 0;
                    if condition
                        set(edges(m,j), 'Visible', 'off');
                    else
                        set(edges(m,j), 'Visible', 'on');
                    end
                end
                
                if pbf
                    set(pbf_edges(m,j), 'Xdata', [pos(1, m), pos(1, j)], 'Ydata', [pos(2, m), pos(2, j)]);
                    pp = [pos(:,m)' ; pos(:,j)'];
                    vv = [vel(:,m)' ; vel(:,j)'];
                    res = barrierFunction( pp, vv, params.dmin, params.amax );
                    disp(['res(' num2str(i) '): ' num2str(res)]);
                    if res == 0 || norm(pos(:,m) - pos(:,j)) < params.dmin
                        set(pbf_edges(m,j), 'Visible', 'on'); 
                    else
                        set(pbf_edges(m,j), 'Visible', 'off'); 
                    end
                    
                    if norm(pos(:,m) - pos(:,j)) < params.dmin
                        set(pbf_edges(m,j), 'Color', 'g');
                    else
                        set(pbf_edges(m,j), 'Color', 'r');
                    end
                end
                

            end % j
%             if m < I(2)
%                 set(edges(m,I(2)), 'Visible', 'on');
%             end
        end % m
    end % if
    
    centre = sum(pos,2)/params.n;
    
    pos_ = pos + v_scale * vel;
    
    if Speed == 1
        pos_ = pos + v_scale * vel;
        xD = [pos(1,:) ; pos_(1,:)];
        yD = [pos(2,:) ; pos_(2,:)];
    elseif Speed == 2
        pos_ = pos + v_scale * vel;
        xD = [pos(1,speed_agent) ; pos_(1,speed_agent)];
        yD = [pos(2,speed_agent) ; pos_(2,speed_agent)];
    end
    
    if Acceleration == 1
        xA = [pos(1,:) ; pos(1,:) + Acc_scale * accx(i+1,:)];
        yA = [pos(2,:) ; pos(2,:) + Acc_scale * accy(i+1,:)];
    elseif Acceleration == 2
        xA = [pos(1,Acc_agent) ; pos(1,Acc_agent) + Acc_scale * accx(i+1,Acc_agent)];
        yA = [pos(2,Acc_agent) ; pos(2,Acc_agent) + Acc_scale * accy(i+1,Acc_agent)];
    end
    
    if Speed == 2
        for indx = 1:numel(speed_agent)
            set(l(indx), 'Xdata', xD(:,indx), 'Ydata', yD(:,indx));
        end
    end
    
    if Acceleration == 2
        for indx = 1:numel(Acc_agent)
            set(ac(indx), 'Xdata', xA(:,indx), 'Ydata', yA(:,indx));
        end
    end
    
    for j = 1:params.n
        if Speed == 1
            set(l(j), 'Xdata', xD(:,j), 'Ydata', yD(:,j));
        end
        if Acceleration == 1
            set(ac(j), 'Xdata', xA(:,j), 'Ydata', yA(:,j));
        end
        if drawTraj == 1
            if traj_color_policy
               if policy(i) == 2
                   traj_color = [0 0 0.8];
               else
                   traj_color = [0.8 0.8 0.8];
%                    traj_color = [0.8 0 0];
               end
            end
            plot([x(i-1,j) x(i,j)] ,[y(i-1,j) y(i,j)], '-', 'Color', traj_color, 'LineWidth', 2);
        elseif drawTraj == 2
            x_trail = x(max(i-trail_len,1):i,j);
            y_trail = y(max(i-trail_len,1):i,j);
            trail(j) = plot(x_trail, y_trail, '-', 'Color', traj_color, 'LineWidth', 2);
        end
        if showID
%             set(agentIDs(j), 'Position', pos(:,j)' - [0, 1.5*params.dmin]);    
            set(agentIDs(j), 'Position', pos(:,j)' - [0, 0.25]);    
        end
        if showCircles
            set(r(j), 'Position', [pos(:,j)' - params.dmin/2 params.dmin params.dmin]);
        end
    end
    
    if simplex_policy
        c = redBlue(policy(i), :);
        set(p, 'Xdata',pos(1,:),'Ydata',pos(2,:), 'CData', c);
    else
        set(p, 'Xdata',pos(1,:),'Ydata',pos(2,:));
    end

    
    BoxLength = BoxL * MaxPairwiseDistance(pos(1,:), pos(2,:));
    dif = max(BoxLength, max(max(pos') - min(pos')));
    limits = [-dif/2 dif/2 -dif/2 dif/2];
    if ~FullBox
        if true || (MaxPairwiseDistance(pos(1,:), pos(2,:))/BoxLength <= 0.50 || i > 130) && Flag
            BoxLength = BoxL * MaxPairwiseDistance(pos(1,:), pos(2,:));
            limits = BoxLength/2*[-1 +1 -1 +1];
        end
        axis(centre'*[1 0;1 0;0 1;0 1]' + limits);
        textpos = (7/8) * mean(abs(limits));
    end

    if showText
       minDist = MinPairwiseDistance( x(i,:), y(i,:) );
       title([ 'Minimum pairwise distance: ' num2str(round(minDist, 3)) ', Time: ' num2str(round(params.dt*(i),1)) ' sec'], 'FontSize', 30);
    end
    
    if numel(traj.result) == 1
        if BB_plot_sequence && mod(i-1, controller_step) == 0 && i < params.switch_step 
            if ishandle(p_seq)
                delete(p_seq);
            end
            if ishandle(v_seq)
                delete(v_seq);
            end
            if ishandle(a_seq)
                delete(a_seq);
            end

%             [next_pos, next_vel] = next_state(pos, vel, acc, params);
            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,i+1), params);
            [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(i+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0.6,0]);
        end

        if BB_show_failed_seq && i == params.switch_step && i < params.steps - 1
            hidem(p_seq);
            if ishandle(v_seq), hidem(v_seq(:)); end
            if ishandle(a_seq), hidem(a_seq(:)); end
            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,i+1), params);
            [p_seq_1, v_seq_1, a_seq_1] = BB_local_draw_sequence(squeeze(a_sequence(i+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0,1]);
            for jj = 1:BB_fail_pause_duration
                uistack(l, 'top');
                uistack(p, 'top');
                F = getframe(f);
                writeVideo(myVideo,F);
            end
            delete(p_seq_1); 
            if ishandle(v_seq_1), delete(v_seq_1); end
            if ishandle(a_seq_1), delete(a_seq_1); end

            showm(p_seq);
            if ishandle(v_seq), showm(v_seq(:)); end
            if ishandle(a_seq), showm(a_seq(:)); end

            [str] = result_message(traj.result, params.dt);
            disp(str);
        end
    else
       if BB_plot_sequence && mod(i-1, controller_step) == 0 && traj.policy(i) == 1
            if ishandle(p_seq)
                delete(p_seq);
            end
            if ishandle(v_seq)
                delete(v_seq);
            end
            if ishandle(a_seq)
                delete(a_seq);
            end

            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,i+1), params);
            [p_seq, v_seq, a_seq] = BB_local_draw_sequence(squeeze(a_sequence(i+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0.6,0]);
        end

        if BB_show_failed_seq && any(i == [traj.result.switch_step]) && i < params.steps - 1
            hidem(p_seq);
            if ishandle(v_seq), hidem(v_seq(:)); end
            if ishandle(a_seq), hidem(a_seq(:)); end
            [next_pos, next_vel] = next_state(pos, vel, traj.a_ac(:,:,i+1), params);
            [p_seq_1, v_seq_1, a_seq_1] = BB_local_draw_sequence(squeeze(a_sequence(i+1,:,:,:)), next_pos, next_vel, params, BB_show_vel, BB_show_acc, [0,0,1]);
            for jj = 1:BB_fail_pause_duration
                uistack(l, 'top');
                uistack(p, 'top');
                F = getframe(f);
                writeVideo(myVideo,F);
            end
            delete(p_seq_1); 
            if ishandle(v_seq_1), delete(v_seq_1); end
            if ishandle(a_seq_1), delete(a_seq_1); end

            showm(p_seq);
            if ishandle(v_seq), showm(v_seq(:)); end
            if ishandle(a_seq), showm(a_seq(:)); end
                
            [str] = result_message(traj.result(fail_no), params.dt);
            disp(str);
            fail_no = fail_no + 1;
        end
    end

    uistack(l, 'top');
    uistack(p, 'top');
    F = getframe(f);
    writeVideo(myVideo,F);
    if drawTraj == 2 
        delete(trail);
    end
end

