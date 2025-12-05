function x = wlls_TDOA(X,r,x1,y1,sigma2)
% LLS algorithm
% --------------------------------
% x = lls(X,r);
% x = 2D position estimate
% X = receiver position matrix
% r = TOA measurement vector
% 
L = size(X,2); % number of receivers
A = [-2*X' -r];
b = r.^2-sum(X'.^2,2);
W = 1/4*diag(1./(sigma2.*r.^2));
p = pinv(A'*W*A)*A'*W*b;
x= [p(1)+x1 ; p(2)+y1];