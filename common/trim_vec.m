function [v] = trim_vec(v, mag)
% Usama Mehmood - Oct 2019

    if norm(v) > mag
        v = v * (mag/norm(v));
    end
end

