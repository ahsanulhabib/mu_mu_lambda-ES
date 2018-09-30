% plot objective function value over funCalls
% For a combination of sigma* and lambda
% 
% save objective function calls data & plot into files
%
% difficulty: 
%            first several iterations lambda objective function calls
%            add one legned when doing a plot
%            use a 4-dim matrix to save the data for different lambda and
%            plot replaced in the first loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = fun_graph_funCall_merged(f,name,NUM_OF_RUNS,sigma_star_array,lambda_array,TRAINING_FACTOR)
%Input:
%    f:                 objective function 
%    name:              a number specify f  
%    NUM_OF_RUNS        # of runs to average
%    sigma_star_array   an array of sigma_star's
%    lambda_array       an array of lambda's
%Return:
%    iteration number for [mmlWithGP,mmlNoGP,1+1WithGP,1+1NoGP]  
  
%TRAINING_SIZE = 4*lambda;

NUM_OF_ITERATIONS = 10000;
n = 10;


[index ,SIGMA_LENGTH] = size(sigma_star_array);
[index ,LAMBDA_LENGTH] = size(lambda_array);
sigma_star_start = sigma_star_array(1);
sigma_star_end = sigma_star_array(SIGMA_LENGTH);
if SIGMA_LENGTH == 1
    sigma_increment = 1;
else 
    sigma_increment = (sigma_star_end-sigma_star_start)/(SIGMA_LENGTH-1);
end
lambda_start = lambda_array(1);
lambda_end = lambda_array(LAMBDA_LENGTH);
if LAMBDA_LENGTH == 1
    lambda_increment = 1;
else
    lambda_increment = (lambda_end - lambda_start)/(LAMBDA_LENGTH-1);
end

t_array = zeros(SIGMA_LENGTH, LAMBDA_LENGTH,NUM_OF_RUNS,1);                 % # of iterations 
T_array = zeros(SIGMA_LENGTH, LAMBDA_LENGTH,NUM_OF_RUNS,1);                 % # of objective function calls
f_x_matrix = zeros(SIGMA_LENGTH, LAMBDA_LENGTH,NUM_OF_RUNS,10000);          % store all fx
T_med = zeros(SIGMA_LENGTH,LAMBDA_LENGTH);
t_med = zeros(SIGMA_LENGTH,LAMBDA_LENGTH);
f_x_med = zeros(SIGMA_LENGTH,LAMBDA_LENGTH,10000);

i = 1;
for sigma_star_temp = sigma_star_start:sigma_increment:sigma_star_end
    j = 1;
    for lambda_temp = lambda_start:lambda_increment:lambda_end
        for k = 1:NUM_OF_RUNS
            mu = ceil(0.27*lambda_temp);
            x0 = randn(n,mu);
            % (mu/mu,lambda)-ES with GP
            a = mml_sigmaStar_GP_TrainSize(f,x0,sigma_star_temp,lambda_temp,NUM_OF_ITERATIONS,TRAINING_FACTOR);
            t_array(i,j,k) = cell2mat(a(1));
            T_array(i,j,k) = cell2mat(a(5));
            f_x_matrix(i,j,k,:) = cell2mat(a(6));
        end
        j = j+1;
    end
    i = i+1;
end

T_med = median(T_array,3);
t_med = median(t_array,3);
t_max = max(t_array,[],3);
t_min = min(t_array,[],3);
f_x_med = median(f_x_matrix,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph

figure(name);
legend('-DynamicLegend'); 
i = 1;
hold on;
for sigma_star_temp = sigma_star_start:sigma_increment:sigma_star_end
    j = 1;
    figure(name);
    hold on;
    for lambda_temp = lambda_start:lambda_increment:lambda_end
        mu = ceil(0.27*lambda_temp);
        % plot first ceil(TRAINING_SIZE/lambda_temp) iterations seperately
        t_range1 = 1:lambda_temp:(lambda_temp+1)*TRAINING_FACTOR+1;
        t_range2 = (lambda_temp+1)*TRAINING_FACTOR+2:t_max+lambda_temp*TRAINING_FACTOR;
        f_x_temp = squeeze(f_x_med(i,j,:));
        f_x_med_range1 = f_x_temp(1:TRAINING_FACTOR+1);
        f_x_med_range2 = f_x_temp(TRAINING_FACTOR+2:t_max);
        % add legend    
        d =sprintf('(%d/%d,%d) %d,%d',mu,mu,lambda_temp,sigma_star_temp,TRAINING_FACTOR);
        plot([t_range1 t_range2], [f_x_med_range1' f_x_med_range2'],'DisplayName',d);hold on;
        j = j+1;
    end
    i = i+1;
end
    legend('-DynamicLegend'); 
    legend('show');
    leg = legend();
    title(leg,'(\mu/\mu,\lambda) \sigma^*,F');
    hold off;
    
    xlabel('number of function evaluations','fontsize',15);
    ylabel('objective function value f(x)','fontsize',15);
    set(gca,'yscale','log','fontsize',15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot title seperately and save fig
if name == 6
    title('linear sphere: convergence plot ','fontsize',20);
    saveas(gcf,'linear_sphere.fig');
elseif name == 7
    title('quadratic sphere: convergence plot ','fontsize',20);
    saveas(gcf,'quadratic_sphere.fig');
elseif name == 8
    title('cubic sphere: convergence plot ','fontsize',20);
    saveas(gcf,'cubic_sphere.fig');
elseif name == 9
    title('schwefel function: convergence plot ','fontsize',20);
    saveas(gcf,'schwefel_function.fig');
elseif name == 10
    title('quartic function: convergence plot ','fontsize',20);
    saveas(gcf,'quartic_function.fig');
end
    
%     if name == 6
%        save('T_linear_sphere.mat','sigma_star_start','lambda_increment','lambda_end','TRAINING_SIZE','t_max','t_med','f_x_med','name');
%        saveas(gcf,'linear_sphere.fig');
%     elseif name == 7
%        save('T_quadratic_sphere.mat','sigma_star_start','lambda_increment','lambda_end','TRAINING_SIZE','t_max','t_med','f_x_med','name');
%        saveas(gcf,'quadratic_sphere.fig');
%     elseif name == 8
%        save('T_cubic_sphere.mat','sigma_star_start','lambda_increment','lambda_end','TRAINING_SIZE','t_max','t_med','f_x_med','name');
%        saveas(gcf,'cubic_sphere.fig');
%     elseif name == 9
%        save('T_schwefel_function.mat','sigma_star_start','lambda_increment','lambda_end','TRAINING_SIZE','t_max','t_med','f_x_med','name');
%        saveas(gcf,'schwefel_function.fig');
%     elseif name == 10
%        save('T_quartic_function.mat','sigma_star_start','lambda_increment','lambda_end','TRAINING_SIZE','t_max','t_med','f_x_med','name');
%        saveas(gcf,'quartic_function.fig');
%     end
    
    
    val = T_med;

    
end