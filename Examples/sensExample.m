function dy = sensExample(t, y, p)
dy = ones(2,1);

if y(1) < p(1)
    dy(2) = 0.0;
else
    dy(2) = y(1)*y(2);
end
