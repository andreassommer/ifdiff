function [KF, k, KS, FR, m1, m2, L, R] = getParams()

p = getParamsAsStruct();

KF = p.KF;
k  = p.k;
KS = p.KS;
FR = p.FR;
m1 = p.m1;
m2 = p.m2;
L  = p.L;
R  = p.R;

end