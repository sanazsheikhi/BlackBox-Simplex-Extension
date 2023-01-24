function [] = displayInitState( x, y, vx, vy, iter, color)
    Num = size(x, 2);
    c = repmat(color, Num, 1);
    s = 200*ones(Num,1); %Marker Area in points-squared
    
    vel = [vx(iter,:) ;vy(iter,:)];
    pos = [x(iter,:) ;y(iter,:)];

    pos_ = pos + vel;
    xD = [pos(1,:) ; pos_(1,:)];
    yD = [pos(2,:) ; pos_(2,:)];


    p = scatter(x(iter,:), y(iter,:), s, c ,'.');
    hold on
%     l = plot(xD, yD, 'b', 'LineWidth', 1); %velocity plot
end