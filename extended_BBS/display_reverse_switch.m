function [] = display_reverse_switch( x, y, vx, vy, switches, color)
    Num = size(x, 2);
    c = repmat(color, Num, 1);
    s = 50*ones(Num,1); %Marker Area in points-squared
    X_ = [];
    Y_ = [];

    disp('display_reverse_switch')
    
    for a=1:size(switches,1) % iterate over num of agents n
        for iter=1:size(switches,2)
            if switches(a, iter) == 1
                X_ = [X_, x(iter, a)];
                Y_ = [Y_, y(iter, a)];
            end
        end
    end
    s = 25;
    scatter(X_, Y_, s, [0.9290 0.6940 0.1250] ,'.');
end