function [h] = draw_circle(centre, radius)
h = rectangle('position', [centre - radius 2 * [radius radius]], 'curvature', [1,1]);
end

