function [H] = printMeasure(fname, trajs_array, i, params, c, lStyle)
        
        temp = trajs_array(1,1);
%         steps = size(temp{1}, 1);
        steps = params.steps;
        fprintf('%s\n', fname);
        cur_data = cell2mat(trajs_array(i,:));
        Tfin = params.dt * steps;
        
        nReps = size(cur_data,2);

        mean_data = mean(cur_data,2);
        min_data = min(cur_data');
        
        std_data = std(cur_data,0,2);
        [ci_5,ci_95] = confidenceInterval(mean_data,std_data,nReps,0.95);
        
        
        
        
        x = (0:params.dt:Tfin)';
        x = x(1:end-1);
        hold on
        fill([x; flip(x)], [ci_95; flip(ci_5)],c,'LineStyle','none', 'FaceAlpha', 0.3);
        h1 = plot(x ,mean_data, lStyle, 'LineWidth', 2, 'Color', c);
        h2 = plot(x ,min_data, lStyle, 'LineWidth', 2, 'Color', 'b');
        H = [h1, h2];
        
        xlim([x(1) x(end-2)])
        ylabel(strrep(fname, '_', '\_'), 'FontSize', 20);
        xlabel('Time', 'FontSize', 20);
end

