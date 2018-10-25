% runner for mml_GP_CSA
% plot the objective function value, step size, relative error
%function val = mml(f,x0,sigma_star,sigma_ep_star,lambda,sigma0,NUM_OF_ITERATIONS)
% initialization
% f:                  objective function value
% x0:                 mu initial point
% mu:                 population size
% sigma0:             initial muttaion strength
% NUM_OF_ITERATIONS:  number of maximum iterations



% OPTIMAL:            global optima
% TARGET_DISTANCE:    target distance to global optima
% example input:      fun = @(x) x' * x
%                     noGP(fun, randn(10,1),1,1000) 

% Test functions
f1 = @(x) (x'*x)^(1/2);  % linear sphere
f2 = @(x) (x'*x);        % quadratic sphere
f3 = @(x) (x'*x)^(3/2);  % cubic sphere


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = 3;
n = 10;

lambda = 40;
mu = ceil(lambda/4);
sigma0 = 1;
NUM_OF_ITERATIONS = 2000;
TRAINING_SIZE = 40;
LENGTH_SCALE = 4;
% x0 = randn(n,mu);
% 64 worked for quadratic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = mml_GP_CSA_niko_paper(f,x0,sigma0,lambda,NUM_OF_ITERATIONS,TRAINING_SIZE,LENGTH_SCALE);
t = cell2mat(a(1));
centroid = cell2mat(a(2));
f_centroid = cell2mat(a(3));
sigma_array = cell2mat(a(4));
T = cell2mat(a(5));
fcentroid_array = cell2mat(a(6));
convergence_rate = cell2mat(a(7));
error_array = cell2mat(a(8));
sigma_satr_array = cell2mat(a(9));
success_rate = cell2mat(a(10));
delta_array = cell2mat(a(11));
% p_array = cell2mat(a(12));
% b = mml(f1,x0,sigma0,lambda,NUM_OF_ITERATIONS);
% 
% t1 = cell2mat(b(1));
% centroid1 = cell2mat(b(2));
% f_centroid1 = cell2mat(b(3));
% sigma_array1 = cell2mat(b(4));
% fcentroid_array1 = cell2mat(b(6));
% convergence_rate1 = cell2mat(b(7));
% fep_centroid_array1 = cell2mat(b(8));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("number of iterations");
disp(t);
% disp(t1);

disp("convergence rate");
disp(convergence_rate);

disp("success rate");
disp(success_rate);

disp("number of objective function calls");
disp(T);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot sigma, f(x), sigmaStar
figure(10);
% f(x)
subplot(2,3,1)          
semilogy(1:t, fcentroid_array(1:t));hold on;           % mml with GP
xlabel('number of iterations','fontsize',15);
ylabel('log(f(x))','fontsize',15);
set(gca,'yscale','log')
title('f(centroid)','fontsize',20);
% sigma    
subplot(2,3,3)
semilogy(1:t, sigma_array(1:t));hold on;               % mml with GP
xlabel('number of iterations','fontsize',15);
ylabel('log(\sigma)','fontsize',15);
set(gca,'yscale','log')
title('step size \sigma','fontsize',20);
% sigmaStar
subplot(2,3,4)
plot(1:t,sigma_satr_array(1:t));
xlabel('number of iterations','fontsize',15);hold on;
ylabel('normalized step size \sigma*','fontsize',15);
set(gca,'yscale','log')
title('normalized step size \sigma*','fontsize',20);
xlabel('number of iterations','fontsize',15);
% GP error    
subplot(2,3,5)
plot(1:t,error_array(1:t));hold on;
xlabel('number of iterations','fontsize',15);
ylabel('relative error','fontsize',15);
set(gca,'yscale','log')
title('relative error','fontsize',20);
xlabel('number of iterations','fontsize',15);
% delta(fitness gain/iteration) pmf     
subplot(2,3,6)
histogram(delta_array(1:t),'Normalization','probability');hold on;
xlabel('number of iterations','fontsize',15);
ylabel('prob','fontsize',15);
% set(gca,'yscale','log')
title('pdf of delta ','fontsize',20);
% xlabel('number of iterations','fontsize',15);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Schwefel?s Problem 1.2
function val = f4(x)
    val = 0;
    for i = 1:1:length(x)
        val = val + sum(x(1:i))^2;
    end
end
% quartic function
function val = f5(x)
    beta = 1;
    val = 0;
    for i = 1:1:n-1
        val = val + beta*(x(i+1)-x(i).^2)^2+(1-x(i))^2;
    end
end
