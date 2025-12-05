function G = jacob(X, x, s)
% Jacobian matrix computation
% --------------------------------
% G = jacobian(X, x)
% G = Jacobian matrix 
% x = 2D position estimate
% X = matrix for receiver positions
%

[dim,L] = size(X); % L is number of receivers; dim is dimension of space
f_TOA1 = sqrt(sum((ones(L,1)*x'-X').^2,2));
f_TOA2 = sqrt(sum((ones(L,1)*x'-s').^2,2));
G = (ones(L,1)*x' - X')./(f_TOA1*ones(1,dim)) - ((ones(L,1)*x' - s'))./(f_TOA2*ones(1,dim));
G = G(2:end,:);
