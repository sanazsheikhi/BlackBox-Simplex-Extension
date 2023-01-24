function [ pos, vel ] = dynamics( pos, vel, acc, params )
%% dynamics() - cmpc
vel = vel + params.dt*acc;
%% Extended BBS
% actives = params.actvie_agents;

for j = 1:params.n
%     if actives(j) == 1
        if params.predator && j == params.n
           if norm(vel(:,j)) > params.pFactor * params.vmax
                vel(:,j) = (params.pFactor * params.vmax / norm( vel(:,j) )) * vel(:,j);
           end
           continue;
        end
        if norm(vel(:,j)) > params.vmax
            vel(:,j) = (params.vmax/norm( vel(:,j) )) * vel(:,j);
        end
%     end
end

%% Extended BBS
for i=1:params.n
%     if actives(i) == 1
        pos(:, i) = pos(:, i) + params.dt*vel(:, i);
%     end
end

end

