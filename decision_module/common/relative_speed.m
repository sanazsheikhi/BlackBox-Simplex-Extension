function [res] = relative_speed(pos, vel)
res = (vel(1,:) - vel(1,:)').*(pos(1,:) - pos(1,:)') + (vel(2,:) - vel(2,:)').*(pos(2,:) - pos(2,:)');
end

