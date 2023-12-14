m = mtree('rhs_test.m', '-file', '-comments');
%m.dumptree()
c = strings(m);
a = m.mtfind('String', '% IFDIFF:ignore');
Parent(a)