function [activation_out] = active_agent_identifier(current, dest, activation_list)

threshold_min = 2; % distance of current pos from destination for success rate
activation_out = activation_list;
[distances, avg] = get_distance(current, dest);

for i=1:size(distances, 2)
    if distances(i) <= threshold_min  
        activation_out(i) = 0;
    end
end
