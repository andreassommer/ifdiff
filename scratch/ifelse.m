function result = ifelse(x)
%IFELSE Reference function for what if/else nodes' mtrees look like
if x < 0
    z = -1;
    y = z;
elseif x == 0
    z = 0;
    y = z;
else
    z = 1;
    y = z;
end
result = y;
end

