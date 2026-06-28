function dy = rhsRobertsonDAE(~,y,p)

dy = zeros(3, 1);

dy(1) = -0.04*y(1) + 1e4*y(2)*y(3)*(1 + abs(p-y(1)));
dy(2) = 0.04*y(1) - 1e4*y(2)*y(3) - 3e7*y(2)^2;
dy(3) = y(1) + y(2) + y(3) - 1;

end