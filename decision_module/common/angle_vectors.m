function [theta_deg] = angle_vectors(u,v)
%% angle_vectors - angle in radians between vectors u,v. 
% Input:
%    u    - row or col vector
%    v    - row or col vector
% Output
%    theta_deg    - 1 x 1 angle in radians.
% Usama Mehmood - Oct 2019
%%
    theta_deg = 0;
    if all(u==0) || all(v==0)
        return;
    end
    CosTheta = dot(u,v)/(norm(u)*norm(v));
    if abs(CosTheta) > 1 %floating point precision cannot represent number accurately.
        CosTheta = sign(CosTheta)*1;
    end
    theta_deg = acosd(CosTheta);
end
