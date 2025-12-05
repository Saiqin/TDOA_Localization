function [TDOA_result] = TDOA(r,X,isplot,sigma2)
iter = 20;
L = size(X,2);
Z = X - X(:,1);
Z = Z(:,2:end);
x1 = X(:,1)';
% == NLS Newton-Raphson algorithm == %
x = lls_TDOA(Z,r(2:end),X(1,1),X(2,1));
for i=1:iter
    H=hessian_nls_TDOA(X,x,r,x1');
    g=grad_nls_TDOA(X,x,r,x1');
    x=x-pinv(H)*g;
    x_nr(i,:)=x;
end
% == NLS Gauss-Newton algorithm == %
x = lls_TDOA(Z,r(2:end),X(1,1),X(2,1));
for i = 1:iter
    G = jacob_TDOA(X, x, x1');
    f_TOA1 = sqrt(sum((ones(L,1)*x'-X').^2,2));
    f_TOA2 = sqrt(sum((ones(L,1)*x'-x1).^2,2));
    x = x+pinv(G'*G)*G'*(r(2:end,:)-f_TOA1(2:end,:)+f_TOA2(2:end,:)); %% r - r1 -r2
    x_gn(i,:)=x;
end
% == NLS steepest descent algorithm == %
x = lls_TDOA(Z,r(2:end),X(1,1),X(2,1));
mu= 0.001;
for i=1:iter
    g=grad_nls_TDOA(X,x,r,x1');
    x=x-mu*g;
    x_sd(i,:)=x;
end
%% ML
x = wlls_TDOA(Z,r(2:end),X(1,1),X(2,1),sigma2(2:end));
% == NLS Newton-Raphson algorithm == %
for i=1:iter
    H=hessian_ml_TDOA(X,x,r,x1',sigma2);
    g=grad_ml_TDOA(X,x,r,x1',sigma2);
    x=x-pinv(H)*g;
    x_nr_ml(i,:)=x;
end
% == NLS Gauss-Newton algorithm == %
x = wlls_TDOA(Z,r(2:end),X(1,1),X(2,1),sigma2(2:end));
for i = 1:iter
    G = jacob_TDOA(X, x, x1');
    f_TOA1 = sqrt(sum((ones(L,1)*x'-X').^2,2));
    f_TOA2 = sqrt(sum((ones(L,1)*x'-x1).^2,2));
    C_inv = diag(1./sigma2(2:end));
    x = x+pinv(G'*C_inv*G)*G'*(r(2:end,:)-f_TOA1(2:end,:)+f_TOA2(2:end,:)); %% r - r1 -r2
    x_gn_ml(i,:)=x;
end
% == ML steepest descent algorithm == %
x = wlls_TDOA(Z,r(2:end),X(1,1),X(2,1),sigma2(2:end));
mu= 0.00001;
for i=1:iter
    g=grad_ml_TDOA(X,x,r,x1',sigma2);
    x=x-mu*g;
    x_sd_ml(i,:)=x;
end
TDOA_result = [x_nr(end,:)',x_gn(end,:)',x_sd(end,:)',x_nr_ml(end,:)',x_gn_ml(end,:)',x_sd_ml(end,:)'];
iter_no = 1:iter;
if isplot
figure; 
subplot(2,2,1);plot(iter_no, x_nr(:,1), 'k.', iter_no, x_gn(:,1), 'ko', iter_no, x_sd(:,1), 'k+');
legend('Newton-Raphson','Gauss-Netwon','steepest descent');
ylabel('estimate of x')
xlabel('number of iterations')
subplot(2,2,2);plot(iter_no, x_nr(:,2), 'k.', iter_no, x_gn(:,2), 'ko', iter_no, x_sd(:,2), 'k+');
legend('Newton-Raphson','Gauss-Netwon','steepest descent');
ylabel('estimate of y')
xlabel('number of iterations')

subplot(2,2,3);plot(iter_no, x_nr_ml(:,1), 'k.', iter_no, x_gn_ml(:,1), 'ko', iter_no, x_sd_ml(:,1), 'k+');
legend('Newton-Raphson-ml','Gauss-Netwon-ml','steepest descent-ml');
ylabel('estimate of x')
xlabel('number of iterations')
%axis([1 30 1.9 2.7])

subplot(2,2,4);plot(iter_no, x_nr_ml(:,2), 'k.', iter_no, x_gn_ml(:,2), 'ko', iter_no, x_sd_ml(:,2), 'k+');
legend('Newton-Raphson-ml','Gauss-Netwon-ml','steepest descent-ml');
ylabel('estimate of y')
xlabel('number of iterations')
% axis([1 30 2.1 2.8])
end