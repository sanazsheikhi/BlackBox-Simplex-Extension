function [posi, veli, tgt] = gen_init_bb(params)
%% gen_init_bb - Generate initial positions for the multiagent systems.
% Initial positions are on a circle with equal separation between the
% agents.

%%
n = params.n;
theta = 0:360/n:360*(n-1)/n;
posi = [params.diameter * cosd(theta); params.diameter * sind(theta)];
R = [cosd(180) -sind(180); sind(180) cosd(180)];
tgt = R * posi;

veli = zeros(2, params.n);

end

