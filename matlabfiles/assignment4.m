%% Example from Text: Markov Chain for Normal Distribution
clear;
mu=0;
sigma=2^0.5;
lambda=3;
n=7;
zlow=mu-lambda*sigma;
zhigh=mu+lambda*sigma;
z=linspace(zlow,zhigh,n);
p=zeros(n,1);
m=zeros(1,n-1);
for i=1:n-1
    m(i)=(z(i)+z(i+1))/2;
end
p(1)=normcdf(m(1),mu,sigma);
p(n)=1-normcdf(m(n-1),mu,sigma);
for i=2:n-1
    p(i)=normcdf(m(i),mu,sigma)-normcdf(m(i-1),mu,sigma);
end
mean_z=z*p;
var_z=z.^2*p;
disp('Parameters: lambda n')
disp([lambda n])
disp('Mean:')
disp(mean_z)
disp('Variance')
disp(var_z)
%% Example from Text: Markov Chain for AR(1) Process
% y_t=rho*y_t-1+epsilon_t, epsilon_t~N(0,0.01)
clear;
lambda=3;
mu=0;
n=9;
rho=0.9;
sigma_e=0.01^0.5;
sigma=sigma_e/(1-rho^2)^0.5;
zlow=mu-sigma*lambda;
zhigh=mu+sigma*lambda;

z=linspace(zlow,zhigh,n);
P=zeros(n);
m=(z(1:length(z)-1)+z(2:length(z)))/2;

for i=1:n
    for j =2:n-1
        P(i,j)=normcdf((m(j)-(1-rho)*mu-rho*z(i))/sigma_e)-normcdf((m(j-1)-(1-rho)*mu-rho*z(i))/sigma_e);
    end
    P(i,1)=normcdf((m(1)-(1-rho)*mu-rho*z(i))/sigma_e);
    P(i,n)=1-normcdf((m(n-1)-(1-rho)*mu-rho*z(i))/sigma_e);
end
 X = [P' - eye(n); ones(1,n)];
 Y = X'*[zeros(n,1);1];
 R = chol(X'*X);
 sd1 = (R\(R'\Y))';


[Q,D]=eig(P);
Pl=Q*D^100*Q^-1;
[Ql,Dl]=eig(Pl');
sd=Ql(:,1)';

sm = sd*z'; % Mean
ssd = sqrt((z-sm).^2*sd'); % Standard Deviation
sac = sum(sum((z-sm)'*(z-sm).*(diag(sd)*P)))/ssd^2;

sm1 = sd1*z'; % Mean
ssd1 = sqrt((z-sm1).^2*sd1'); % Standard Deviation
sac1 = sum(sum((z-sm1)'*(z-sm1).*(diag(sd1)*P)))/ssd1^2;

disp('Parameters: n rho');
disp([n rho]);
disp('Mean Std.dev Autocorrelation');
disp([sm ssd sac sm1 ssd1 sac1]);

%% Assignment 4
clear;
P=[0.8 0.1 0.1
0 0.2 0.8
0.7 0.3 0];
A=P^100;
z=[0.65,0.15,0.2];
for i=1:20
    z=z*P;
end















































