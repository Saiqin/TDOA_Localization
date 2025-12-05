function H = hessian_nls_TDOA(X,x,r,s)
% NLS Hessian matrix computation
% --------------------------------
% H = hessian_nls(X,x,r);
% H = Hessian matrix 
% X = matrix for receiver positions
% x = 2D position estimate
% r = TDOA measurement vector
% saiqin xu padova 2024.3.24
L = size(X,2); % number of receivers
t1 = 0;
t2 = 0;
t3 =0;
ds = sum((x*ones(1,L)-X).^2,1);
ds = ds';
D = sum((x-s).^2,1);
for i=2:L
    t1 = t1 + ( -(x(1)-X(1,i))/sqrt(ds(i)) + (x(1)-s(1))/sqrt(D) )^2 +...
        ( -(x(2)-X(2,i))^2/(ds(i)^(1.5))  + (x(2)-s(2))^2/(D^(1.5)) )* ( r(i)-ds(i)^(0.5)+D^(0.5) );
    t2 = t2 + ( -(x(1)-X(1,i))/sqrt(ds(i)) + (x(1)-s(1))/sqrt(D) )*( -(x(2)-X(2,i))/sqrt(ds(i)) + (x(2)-s(2))/sqrt(D) ) +...
        ( (x(1)-X(1,i))*(x(2)-X(2,i))/(ds(i)^(1.5)) - (x(1)-s(1))*(x(2)-s(2))/(D^(1.5)) )* ( r(i)-ds(i)^(0.5)+D^(0.5) );
    t3 = t3 + ( -(x(2)-X(2,i))/sqrt(ds(i)) + (x(2)-s(2))/sqrt(D) )^2 + ...
        ( -(x(1)-X(1,i))^2/(ds(i)^(1.5))  + (x(1)-s(1))^2/(D^(1.5)) )* ( r(i)-ds(i)^(0.5)+D^(0.5) );
end
H=2.*[t1 t2;
      t2 t3];
