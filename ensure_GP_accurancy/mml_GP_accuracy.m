% Goal:               Find ideal performance of the strategy
% GP update:          http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.448.9371&rep=rep1&type=pdf
% Add new trainijng point if GP is not consistant by adding new pt.
% GP estimate can be very much precise
% Use sigma* to model step size
% Use Gaussian distributed random noise to model GP estimate replace objective 
% function evaluation for lambda offsprings with GP estimate 
% In each iteration only the centroid is evaluated
% NOTE:               lambda must > 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = mml_GP_accuracy(f,x0,sigma_star,lambda,NUM_OF_ITERATIONS)
% initialization
% f:                  objective function value
% x0:                 mu initial point size [n, mu]
% sigma0:             initial step size
% sigma_star:         normalized step size, decrease proportional to dist 
% lambda:             # of offsprings genenerated in each itertaion  
% mu:                 parent size
% sigma0:             initial muttaion strength
% NUM_OF_ITERATIONS:  number of maximum iterations

% Return 
% 1.t:                  # of objective function calls                    
% 2.centroid:           last parent x(centroid)
% 3.f_centroid:         last objective function value
% 4.sigma_array:        simage arrary over # of objective function calls  
% 5.centroid_array:     parent set(centroids)
% 6.fcentroid_array:    objective function values for parents(centroids)
% 7.convergence_rate:   rate of convergence
% 8.GP_error:           f_centroid(t)-fep_centroid(t))/(f_centroid(t)-f_centroid(t-1)
%                       effective SIZE = t-6
% 9.sigma_star_array:   normalized step size


% OPTIMAL:            global optima
% example input:      f = @(x) x' * x
%                     mml(f,randn(n,mu),1,0,10,1,4000)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n, mu] = size(x0);

TRAINING_SIZE = 40;
xTrain = zeros(n,10000);            % training data for GP size 4*mu
fTrain = zeros(1,10000);


centroid_array = zeros(n,10000);
fcentroid_array = zeros(1,10000);
sigma_array = zeros(1,10000);
s_array = zeros(1,10000);
fep_centroid = zeros(1,10000);
theta_array = zeros(1,10000);
sigma_star_array = zeros(1,10000);                      % store normalized step size


y = zeros(n,lambda);                                    % lambda offspring solution with dim n
z = zeros(n,lambda);                                    % random directions added for lambda offsprings dim n
fy = zeros(lambda,1);                                   % objective function value of y                                              
centroid = mean(x0, 2);                                 % centroid of parent set, size = [n, 1]
f_centroid = f(centroid);                               % fx of centroid
fyep = zeros(lambda,1);                                 % GP estimate for offsprings
GP_error = zeros(1,10000);                              % relative error of GP 

n_init = lambda;
nb = max(1, floor(lambda/10));
n_init = max(nb,n_init-nb);
%offspring                                              % mu offspring chosen (evaluated)
fep_offspring = zeros(mu,1);                            % GP estimate of offsprings              

convergence_rate = 0;
success_count = 0;

t = 1;                                                  % number of iterations
T = 1;                                                  % number of objective function calls


centroid_array(:,t) = centroid;
fcentroid_array(t) = f_centroid;

length_scale_factor = 8;


while((t < NUM_OF_ITERATIONS) && f_centroid > 10^(-8))
    dist = norm(centroid);                              % distance to optimal
    sigma = sigma_star/n*dist;                          % mutation strength/step size(temp) 
    theta = sigma*length_scale_factor*sqrt(n);          % length scale for GP
    
    % (mu/mu, lambda)-ES 4 times to obtain GP traning set
    if (T<40)
        % offspring genneration 
        for i = 1:1:lambda
            % offspring = mean(parent) + stepsize*z
            z(:,i) = randn(n,1);
            y(:,i) = centroid + sigma*z(:,i);
            fy(i) = f(y(:,i)); 
        end
        xTrain(:,T:T+lambda-1) = y;
        fTrain(T:T+lambda-1) = fy;
        T = T + lambda;
            
    % (mu/mu, lambda)-ES use GP estiate 
    else  
        

        % offspring_generation (lambda offspring) 
        for i = 1:1:lambda
            % offspring = mean(parent) + stepsize*z
            z(:,i) = randn(n,1);
            y(:,i) = centroid + sigma*z(:,i);
            fyep(i) = gp(xTrain(:,T-40:T-1), fTrain(T-40:T-1), y(:,i), theta);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Build accurate GP model
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % sort fyep (small first)
        [index, initial_sorted_order] = sort(fyep);
        y = y(:,initial_sorted_order);                   % y with smaller fyep first
        % update training set (mu best offsprings according to GP estimate)
        offspring = y(:,1:mu);
        xTrain(:,T:T+mu-1) = offspring;
        for i = 1:1:mu
            fTrain(T) = f(offspring(:,i));
            T = T + 1;
        end
        % reallocate unevaluated candidate solutions
        candidate_unevaluated =  y(:,mu+1:lambda);
        initial_mu_offspring = offspring;                % store the first evaluated mu offsprings
        for i=1:1:(lambda-n_init)/nb
        % Reevaluate offsprings using newly-built GP
            fep_mu_offspring = zeros(mu,1);
            for j=1:1:mu
                fep_mu_offspring(j) = gp(xTrain(:,T-40:T-1), fTrain(T-40:T-1), initial_mu_offspring(:,j), theta);
            end
            [index, sorted_fep] = sort(fep_mu_offspring);
            % order of mu candidate solutions unchanged i.e. GP accurate 
            if (sum(sorted_fep(1:mu) == 1:1:mu)==mu)
                break;
            % ranking changed (i.e. GP inaccurate)
            else
                % add mu best unevaluated pts to training set by new model
                fep_temp = zeros(-mu-nb*(i-1),1);         % size change
                for j=1:1:lambda-mu-nb*(i-1)
                    fep_temp(j) = gp(xTrain(:,T-40:T-1), fTrain(T-40:T-1), candidate_unevaluated(:,j), theta);
                end 
                % rank unevaluated points
                [index, sorted_fep] = sort(fep_temp);
                candidate_unevaluated = candidate_unevaluated(:,sorted_fep);
                % add next nb best unevaluated points to GP training set 
                [index, len_unevaluated] = size(candidate_unevaluated); 
                if(len_unevaluated-1 < nb)
                    break;
                end
                offspring = candidate_unevaluated(:,1:nb);
                xTrain(:,T:T+nb-1) = offspring;
                for j=1:1:nb
                    fTrain(T) = f(xTrain(:,T));
                    T = T + 1;
                end
%                 % update length of unevaluated solution array
%                 [index, len_unevaluated] = size(candidate_unevaluated); 
%                 % no more points to add for GP training set
%                 if(len_unevaluated-1 < nb)
%                     break;
%                 end
                candidate_unevaluated = candidate_unevaluated(:,nb+1:len_unevaluated);
                
            end
            if (i>2)
                n_init = min(n_init,lambda-nb);
            elseif (i<2)
                n_init = max(nb,n_init-nb);
            end 
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Evaluate data spoint again
        fyep = zeros(lambda,1);
        for i = 1:1:lambda
            % offspring = mean(parent) + stepsize*z
            fyep(i) = gp(xTrain(:,T-40:T-1), fTrain(T-40:T-1), centroid + sigma*z(:,i), theta);
        end
        
        % for simple calculation 
        fy = fyep;
    end

    % sort fyep (smaller first)
    [index, sorted_order] = sort(fy);
    z = z(:,sorted_order);
    % choose the best mu candidate solutions as parent
    z = mean(z(:,1:mu),2);
    disp(t);
%     d = sprintf('%d: T = %d,',t,T)
    centroid = centroid + sigma*z;
    if(t>4)
        fep_centroid(t) = gp(xTrain(:,T-40:T-1), fTrain(T-40:T-1), centroid, theta);
    end 
    f_centroid = f(centroid);
    xTrain(:, T) = centroid;                
    fTrain(T) = f_centroid;
    T = T + 1;
    
     
    
    
    centroid_array(:,t) = centroid;
    fcentroid_array(t) = f_centroid;
    
    
    theta_array(t) = theta;
    
    sigma_array(t) = sigma;
    
    

    
    t = t + 1;
    
    
    
   
    
    
end
    t = t-1;
    % convergence rate
    convergence_rate = -n/2*sum(log(fcentroid_array(2:t)./fcentroid_array(1:t-1)))/(t-1);
    % relative error for GP |f(y)-fep(y)|/ |f(y)-f(x)|
    GP_error(1:t-5) = abs(fep_centroid(6:t)-fcentroid_array(6:t))./abs(fcentroid_array(5:t-1)-fcentroid_array(6:t));
    success_rate = sum(fcentroid_array(4:t-1)>fcentroid_array(5:t))/(t-3);
    
    val = {t,centroid,f_centroid,sigma_array, T, fcentroid_array,convergence_rate,GP_error,1,success_rate};

end



function fTest = gp(xTrain, fTrain, xTest, theta)
% input: 
%       xTrain(40 training pts)
%       fTrain(true objective function value)
%       xTest(1 test pt)   
%       theta length scale  
% return: the prediction of input test data

    [n, m] = size(xTrain);                                       % m:  # of training data

    delta = vecnorm(repmat(xTrain, 1, m)-repelem(xTrain, 1, m)); %|x_ij = train_i-train_j| 
    K = reshape(exp(-delta.^2/theta^2/2), m , m);                % K

    deltas = vecnorm(xTrain-repelem(xTest, 1, m));               %|x_ij = train_i-test_j| euclidean distance
    Ks = exp(-(deltas/theta).^2/2)';                             % K_star             

    deltass = vecnorm(repmat(xTest, 1, m)-repelem(xTest, 1, m));
    % Kss = reshape((exp(-deltass.^2/theta^2/2)), m , m);
    
    %Kinv = inv(K);       

    mu = min(fTrain);                                            % estimated mean of GP
    fTest = mu + Ks'*(K\(fTrain'-mu));

end