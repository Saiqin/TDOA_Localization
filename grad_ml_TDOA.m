function g = grad_ml_TDOA(X,x,r,s,sigma2)
% NLS gradient computation
% --------------------------------
% g = grad_nls(X,x,r);
% g = gradient vector 
% X = matrix for receiver positions
% x = 2D position estimate
% r = TOA measurement vector
%
L = size(X,2); % number of receivers
t1 = 0;
t2 = 0;
ds = sum((x*ones(1,L)-X).^2,1);
ds = ds';
D = sum((x-s).^2,1);
for i=2:L
    t1 = t1 + (1/sigma2(i))* (( -(x(1)-X(1,i))/sqrt(ds(i)) + (x(1)-s(1))/sqrt(D) ) * ( r(i)-ds(i)^(0.5)+D^(0.5) ));
    t2 = t2 + (1/sigma2(i))* (( -(x(2)-X(2,i))/sqrt(ds(i)) + (x(2)-s(2))/sqrt(D) ) * ( r(i)-ds(i)^(0.5)+D^(0.5) ));
end
g=2.*[t1; t2];

