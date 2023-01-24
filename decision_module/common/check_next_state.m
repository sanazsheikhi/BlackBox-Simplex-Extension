function [is_collision, next_pos, next_vel, r, c, dist] = check_next_state(cur_pos, cur_vel, cur_acc, params)
r = 0;
c = 0;
dist = 0;

is_collision = false;
control_steps = uint8(params.ct / params.dt);

for k = 1:control_steps
    [cur_pos, cur_vel] = dynamics(cur_pos, cur_vel, cur_acc, params);
end

next_pos = cur_pos;
next_vel = cur_vel;

d = inter_agent_distance(next_pos);
condition = d < params.dmin & eye(params.n) == 0;
if any(any(condition))
    is_collision = true;
    [r,c] = find(condition);
    r = r(1);
    c = c(1);
    dist = d(r,c);
end
end

