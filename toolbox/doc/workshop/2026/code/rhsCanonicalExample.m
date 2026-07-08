function dy = rhsCanonicalExample(t, y, p)
dy = zeros(2,1);
dy(1) = 0.01*t.^2 + y(2).^3;

if y(1) < p(1)
    dy(2) = 0;
elseif y(1) < p(1) + 0.5
    dy(2) = 5;
else
    dy(2) = 0;
end
end
