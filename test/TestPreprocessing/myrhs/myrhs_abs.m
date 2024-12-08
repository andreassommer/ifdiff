function dx = myrhs_abs(t,x,p)
    dx2 = abs(x);
    dx = abs(dx2)*abs(x);

end