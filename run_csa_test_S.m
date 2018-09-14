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
f = @(x) (x'*x);
n = 10;
mu = 3;
lambda = 10;

END_SIGMA_STAR = 8;
%x0 = randn(n,mu);
sigma_star = 4;
v = 2;
sigma_ep_star = v*sigma_star;
tolerance = 1;
NUM_OF_ITERATIONS = 5000;
a = mml_noise_testS(f,x0,sigma_star,tolerance,sigma_ep_star,lambda,NUM_OF_ITERATIONS);
t = cell2mat(a(1));
disp("number of iterations");
disp(t);

centroid = cell2mat(a(5));
fcentroid = cell2mat(a(6));
sigma_array = cell2mat(a(4));
convergence_rate = cell2mat(a(7));
t_gp = cell2mat(a(8));
t = cell2mat(a(1));
temp_array = cell2mat(a(9));

% t_array = zeros(END_SIGMA_STAR,1);
% temp_matrix = zeros(END_SIGMA_STAR,10000);
% 
% for i=1:1:END_SIGMA_STAR
%     sigma_star = i;
%     sigma_ep_star = v*sigma_star;
%     tolerance = 1;
%     NUM_OF_ITERATIONS = 5000;
%     a = mml_noise_testS(f,x0,sigma_star,tolerance,sigma_ep_star,lambda,NUM_OF_ITERATIONS);
%     t_array(i) = cell2mat(a(1));
%     temp_matrix(i,:) = cell2mat(a(9));
%     
% end


% plot the graph 
figure(1)
subplot(1,2,1)
% for i=1:1:END_SIGMA_STAR
%     hold on
%     plot(1:1:t_array(i)-1, temp_matrix(1:t_array(i)-1));
% end
plot(1:1:t-1, temp_array(1:t-1));
hold on
ylabel('||s||^2 -n');
xlabel('iteration number');
%set(gca, 'YScale', 'log');
d = sprintf("sigma* = %d, sigma_{ep}* = %d", sigma_star, sigma_ep_star);
title(d);

subplot(1,2,2)
plot(1:1:t-1, exp(temp_array(1:t-1)./(2*sqrt(n))));
hold on
ylabel('exp((||s||^2 -n)/(2DN)');
xlabel('iteration number');
%set(gca, 'YScale', 'log');
d = sprintf("sigma* = %d sigma_ep* = %d", sigma_star, sigma_ep_star);
title(d);

disp("convergence rate");
disp(convergence_rate);
