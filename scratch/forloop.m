function y = forloop(x)
%FORLOOP reference function for what for loops' mtrees look like
y = 0;
for i = 1:x
    z = y + 1;
    y = z;
end
end

