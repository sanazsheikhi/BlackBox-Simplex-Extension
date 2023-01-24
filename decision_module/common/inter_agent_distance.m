function [res] = inter_agent_distance(pos)
res = sqrt((pos(1,:) - pos(1,:)').^2 + (pos(2,:) - pos(2,:)').^2);
end

