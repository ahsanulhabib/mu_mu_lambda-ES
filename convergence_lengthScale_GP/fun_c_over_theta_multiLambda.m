% convergence rate over theta for fixed sigmaStar and sigma
% plot convergence rate over sigma_star for different lambda (one plot)
% For a combination of sigma* and lambda
% 
% save objective function calls data & convergence plot
%
% difficulty: 
%            first several iterations lambda objective function calls
%            add one legned when doing a plot
%            use a 4-dim matrix to save the data for different lambda and
%            plot replaced in the first loop
%            enable adding new plot using different TRAINING_FACTOR to
%            original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = fun_c_over_theta_multiLambda(f,name,NUM_OF_RUNS,sigma_star_array,lambda_array,theta_array,TRAINING_FACTOR,strategy_name)
%Input:
%    f:                 objective function 
%    name:              a number specify f  
%    NUM_OF_RUNS        # of runs to average
%    sigma_star_array   an array of sigma_star's
%    lambda_array       an array of lambda's
%    TRAINING_FACTOR    number of iterations needed to build the GP model
%    strategy_name      a string name of strategy 
%Return:
%    iteration number for [mmlWithGP,mmlNoGP,1+1WithGP,1+1NoGP]  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TRAINING_FACTOR = 0;
NUM_OF_ITERATIONS = 1500;
n = 10;
[index ,THETA_LENGTH] = size(theta_array);
[index ,SIGMA_LENGTH] = size(sigma_star_array);
[index ,LAMBDA_LENGTH] = size(lambda_array);

c_array = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,NUM_OF_RUNS,1);                 % convergence rate
s_array = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,NUM_OF_RUNS,1);                 % success rate
t_array = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,NUM_OF_RUNS,1);                 % # of iterations 
T_array = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,NUM_OF_RUNS,1);                 % # of objective function calls
f_x_matrix = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,NUM_OF_RUNS,10000);          % store all fx
T_med = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH);
t_med = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH);
f_x_med = zeros(LAMBDA_LENGTH,THETA_LENGTH,SIGMA_LENGTH,10000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open the file to write data 
% if name == 6
%     fileID = fopen('linear_sphere_convergence_sigmaStar.txt','a');
%     d = sprintf('The file is obtained by taking the median of %d runs of mml-ES with GP (dim(data)=%d)\n \n',NUM_OF_RUNS,n);
%     fprintf(fileID,d);
%     fprintf(fileID,'%10s \t','(mu/mu,lambda)'); 
% elseif name == 7
%     fileID = fopen('quadratic_sphere_convergence_sigmaStar.txt','a');
%     d = sprintf('The file is obtained by taking the median of %d runs of mml-ES with GP (dim(data)=%d)\n \n',NUM_OF_RUNS,n);
%     fprintf(fileID,d);
%     fprintf(fileID,'%10s \t','(mu/mu,lambda)'); 
% elseif name == 8
%     fileID = fopen('cubic_sphere_convergence_sigmaStar.txt','a');
%     d = sprintf('The file is obtained by taking the median of %d runs of mml-ES with GP (dim(data)=%d)\n \n',NUM_OF_RUNS,n);
%     fprintf(fileID,d);
%     fprintf(fileID,'%10s \t','(mu/mu,lambda)');
% elseif name == 9
%     fileID = fopen('Schwefel_convergence_sigmaStar.txt','a');
%     d = sprintf('The file is obtained by taking the median of %d runs of mml-ES with GP (dim(data)=%d)\n \n',NUM_OF_RUNS,n);
%     fprintf(fileID,d);
%     fprintf(fileID,'%10s \t','(mu/mu,lambda)');
% elseif name == 10
%     fileID = fopen('quartic_convergence_sigmaStar.txt','a');
%     d = sprintf('The file is obtained by taking the median of %d runs of mml-ES with GP (dim(data)=%d)\n \n',NUM_OF_RUNS,n);
%     fprintf(fileID,d);
%     fprintf(fileID,'%10s \t','(mu/mu,lambda)');
% end
% for i = 1:1:SIGMA_LENGTH
%     d = sprintf('%.2f \t \t',sigma_star_array(i));
%     fprintf(fileID,d);
% end
% d = sprintf('\n---------------------------------------------------------------------------------------------------------------\n');
% fprintf(fileID,d);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute statics and save
for i = 1:1:LAMBDA_LENGTH
    lambda_temp = lambda_array(i);
    for j = 1:1:THETA_LENGTH
        theta_temp = theta_array(j);
        for k = 1:1:SIGMA_LENGTH
            sigma_star_temp = sigma_star_array(k);
            for l = 1:1:NUM_OF_RUNS
                mu = floor(lambda_temp/4);
                x0 = randn(n,mu);
                % (mu/mu,lambda)-ES with GP
                a = mml_sigmaStarGP_centroid_tuneTheta(f,x0,sigma_star_temp,lambda_temp,NUM_OF_ITERATIONS,TRAINING_FACTOR,theta_temp);
                c_array(i,j,k,l) = cell2mat(a(7));                         % convergence rate
                s_array(i,j,k,l) = cell2mat(a(11));                        % success rate
                t_array(i,j,k,l) = cell2mat(a(1));                         % number of iterations
                T_array(i,j,k,l) = cell2mat(a(5));                         % number of objective function calls
                f_x_matrix(i,j,k,l,:) = cell2mat(a(6));                    % objective function values
            end
        end
    end
end

c_med = median(c_array,4);
s_med = median(s_array,4);
T_med = median(T_array,4);
% t_med = median(t_array,3);
% t_max = max(t_array,[],3);
% t_min = min(t_array,[],3);
% f_x_med = median(f_x_matrix,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph

figure(name);
legend('-DynamicLegend'); 
hold on;
for i = 1:1:LAMBDA_LENGTH
    lambda_temp = lambda_array(i);
    mu = floor(lambda_temp/4);
    theta_temp = theta_array(j);
    d1 =sprintf('(%d/%d,%d)  \t,',mu,mu,lambda_temp);
    figure(name);
    hold on;
    d =sprintf('(%d/%d,%d)',mu,mu,lambda_temp);
    disp(size(c_med(i,:,:)));
    c_med_2d = squeeze(c_med(i,:,:));
    disp(size(c_med_2d));
    [xx, yy] = meshgrid(sigma_star_array,theta_array);
    surf(xx,yy,c_med_2d,'DisplayName',d);hold on;
%     surf(theta_array,sigma_star_array,c_med_2d,'DisplayName',d);hold on;
end
    legend('-DynamicLegend'); 
    legend('show');
    leg = legend();
    title(leg,'(\mu/\mu,\lambda) \sigma^*');
    xlabel('\sigma*','fontsize',15);
    xlabel('\theta','fontsize',15);
    zlabel('convergence rate','fontsize',15);
    hold off;
%     set(gca,'yscale','log','fontsize',15);

%     % scatter plots of the graph
%     figure(name);
%     hold on;
% for i = 1:1:LAMBDA_LENGTH
%     scatter(sigma_star_array,c_med(i,:)); hold on;
% end
%     hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close the file to put data
% fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot title seperately and save fig
if name == 6
    p1 = sprintf('linear sphere_convergence rate%s',strategy_name);
    title(p1,'fontsize',20);
    p2 = sprintf('linear_sphere_convergence_sigmaStar%s.fig',strategy_name);
    saveas(gcf,p2);
    save(p1,'c_array','s_array','T_array','c_med','s_med','T_med','sigma_star_array','theta_array','lambda_array','TRAINING_FACTOR','f','strategy_name');
elseif name == 7
    p1 = sprintf('quadratic sphere_convergence rate%s',strategy_name);
    title(p1,'fontsize',20);
    p2 = sprintf('quadratic_sphere_convergence_sigmaStar%s.fig',strategy_name);
    saveas(gcf,p2);
    save(p1,'c_array','s_array','T_array','c_med','s_med','T_med','sigma_star_array','theta_array','lambda_array','TRAINING_FACTOR','f','strategy_name');
elseif name == 8
    p1 = sprintf('cubic sphere_convergence rate%s',strategy_name);
    title(p1,'fontsize',20);
    p2 = sprintf('cubic_sphere_convergence_sigmaStar%s.fig',strategy_name);
    saveas(gcf,p2);
    save(p1,'c_array','s_array','T_array','c_med','s_med','T_med','sigma_star_array','theta_array','lambda_array','TRAINING_FACTOR','f','strategy_name');
elseif name == 9
    p1 = sprintf('schwefel function_convergence rate%s',strategy_name);
    title(p1,'fontsize',20);
    p2 = sprintf('schwefel_function_convergence_sigmaStar%s.fig',strategy_name);
    saveas(gcf,p2);
    save(p1,'c_array','s_array','T_array','c_med','sigma_star_array','lambda_array','TRAINING_FACTOR','f');
elseif name == 10
    p1 = sprintf('quartic function_convergence rate%s',strategy_name);
    title(p1,'fontsize',20);
    p2 = sprintf('quartic_function_convergence_sigmaStar%s.fig',strategy_name);
    saveas(gcf,p2);
    save(p1,'c_array','s_array','T_array','c_med','sigma_star_array','lambda_array','TRAINING_FACTOR','f');
end
    
    val = T_med;

    
end