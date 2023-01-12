function [dg] = rhsIND(t, g, p, datahandle, sol)

y = deval(sol,t);
h = 1.0e-08*max(abs(y),1);
n = size(y,1);
gMat = reshape(g,n,n);

ydist = repmat(y,[1,n]) + diag(h);

rhsnom = preprocessedRhs(t,y,p,datahandle);
jacmat = zeros(n,n);

for i=1:n
    jacmat(:,i) = (preprocessedRhs(t,ydist(:,i),p,datahandle) - rhsnom)/h(i);
end

dgMat = jacmat * gMat;
dg = reshape(dgMat,n*n,1);

