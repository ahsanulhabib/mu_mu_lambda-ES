
sigma_star = 0.01:0.01:8.01;
sigma_star_trans = transpose(sigma_star);
% Z for E[\Delta] integral
z_start = 0;
z_step = 0.001; 
z_end = 20;
z = (z_start:z_step:z_end)+sigma_star_trans./2;                             % Put into a matrix strating sigma*/2
z_LENGTH = length(z_start:z_step:z_end);

% Range to find opt. v
v_array = exp(-2.302585092994046: 0.0461:2.302585092994046+0.01);
v_length = length(v_array);
opt_eta_array = zeros(v_length,1);
opt_sigma_star_array = zeros(v_length,1);

% Iterate over noise-to-signal ratio, each over a range of sigmaStar
for i = 1:1:v_length
    v = v_array(i);
    p_eval = normcdf(-sigma_star_trans./2./sqrt(1+v.^2));
    fz = (repmat(sigma_star_trans,1,z_LENGTH).*z-...
        repmat(sigma_star_trans,1,z_LENGTH).^2/2).*exp(-z.^2/2).*...
        normcdf(1./v.*(z-repmat(sigma_star_trans./2,1,z_LENGTH)));
    expected_delta = 1/sqrt(2*pi)*sum(fz,2).*z_step;
    eta = expected_delta./p_eval;

    % Find opt. eta & step size 
    opt_index = find(eta == max(eta));
    opt_eta_array(i) = eta(opt_index);
    opt_sigma_star_array(i) = sigma_star(opt_index);
end

figure(1);
subplot(1,2,1);
plot(v_array,opt_eta_array)
ylabel('opt. expected fitness gain \eta','FontSize',15);
xlabel('noise-to-signal-ratio \upsilon','FontSize',15); 
set(gca, 'XScale', 'log');
set(gca,'FontSize',15);


subplot(1,2,2);
plot(v_array,opt_sigma_star_array)
xlabel('noise-to-signal ratio \upsilon','FontSize',15);%
ylabel('opt. normalized step size \sigma^*','FontSize',15); 
set(gca, 'XScale', 'log');
set(gca,'FontSize',15);


% Plot the experimental result (crosses and circles)
exp_v_array = v_array(1:10:101);
sigma_star_trans = transpose(opt_sigma_star_array);
z = (z_start:z_step:z_end)+sigma_star_trans./2;                             % Put into a matrix strating from opt. sigma*/2
z_LENGTH = length(z);
p_eval = normcdf(-opt_sigma_star_array_trans./2./sqrt(1+exp_v_array.^2));
fz = (repmat(sigma_star_trans,1,z_LENGTH).*z-...
        repmat(sigma_star_trans,1,z_LENGTH).^2/2).*exp(-z.^2/2).*...
        normcdf(1./v.*(z-repmat(sigma_star_trans./2,1,z_LENGTH)));
expected_delta = 1/sqrt(2*pi)*sum(fz,2).*z_step;
% For n=10 opt. FitGain
n=10;
c_n_10 = -n/2*log(1-2*expected_delta/n)./p_eval;
% For n=100 opt. FitGain
n=100;
c_n_100 = -n/2*log(1-2*expected_delta/n)./p_eval;

figure(1);
subplot(1,2,1);

n=10;
d = sprintf('N=%d',n);
typeDot = 'x';
scatter(exp_v_array,c_n_10,typeDot,scatterColour,'DisplayName',d); hold on; 

n=100;
d = sprintf('N=%d',n);
typeDot = 'o';
scatter(exp_v_array,c_n_100,typeDot,scatterColour,'DisplayName',d); hold on;





saveas(gcf,'opt_eta_sigmaStar_one_plus_one.fig'); 

save('opt_eta_sigma_one_plus_one_.mat','sigma_star','z_start','z_step','z_end',...
    'v_array','opt_eta_array','opt_sigma_star_array');