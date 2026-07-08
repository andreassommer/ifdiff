function dy = rhsTask1a(t, y, p)
dy = zeros(2, 1);

q1 = 50/27*t^2 - 100/3*t + 400/3;
q2 = (1000-y(2)) * (p(1)*(t-19) + p(2));

if y(1) <= 750
    dy(1) = q1;
    dy(2) = 0;
elseif y(1) < 800
    dy(1) = q1 - q2;
    dy(2) = -300;
else
    dy(1) = q1 - q2;
    dy(2) = 0;
end
end
