function [is_converging, i, j] = check_divergence_simple(pos, vel)
n = size(pos, 2);
is_converging = false;
for i = 1:n
    for j = i+1:n
        p_ij = pos(:,i) - pos(:,j);
        p_ji = -p_ij;
        v_i = vel(:,i);
        v_j = vel(:,j);
        
        theta_j = angle_vectors(p_ij,v_j);
        theta_i = angle_vectors(p_ji,v_i);
        
        if theta_j + theta_i < 180
            is_converging = true;
            return;
        end
    end
end
end

