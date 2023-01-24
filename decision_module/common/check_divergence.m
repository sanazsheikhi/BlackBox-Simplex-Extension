function [is_converging, r, c] = check_divergence(pos, vel)
 r = 0;
 c = 0;
 rel_speed = relative_speed(pos, vel);
 is_converging = false;
 condition = rel_speed < 0;
 if any(any(condition))
    is_converging = true;
    [r,c] = find(condition);
 end
end

