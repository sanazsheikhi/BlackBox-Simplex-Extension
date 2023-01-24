function [res, avg] = get_distance(init, dest)

res = sqrt((init(1,:) - dest(1,:)).^2 + (init(2,:) - dest(2,:)).^2);
size_ = size(res);
avg = sum(res,"all") / size_(2);
end