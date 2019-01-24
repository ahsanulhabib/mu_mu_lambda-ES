% 'NUM_OF_STRATEGIES','n','NUM_OF_RUNS','f6_range','f7_range', 'f8_range',...
%     'TRAINING_SIZE','LS_onePlusOne','LS_mml', 'NUM_OF_ITERATIONS','C1','C2','C3',...
%     'T_med_f6','f_x_med_f6','sigma_med_f6','sigma_star__med_f6','success_med_f6','four_prob_med_f6','eval_rate_med_f6',...
%     'T_med_f7','f_x_med_f7','sigma_med_f7','sigma_star__med_f7','success_med_f7','four_prob_med_f7','eval_rate_med_f7',...
%     'T_med_f8','f_x_med_f8','sigma_med_f8','sigma_star__med_f8','success_med_f8','four_prob_med_f8','eval_rate_med_f8',...
%     'T_med_f9','f_x_med_f9','sigma_med_f9','sigma_star__med_f9','success_med_f9','four_prob_med_f9','eval_rate_med_f9',....
%     'T_f6','f_x_f6','sigma_f6','sigma_star_f6','success_f6','four_prob_f6','eval_rate_f6',...
%     'T_f7','f_x_f7','sigma_f7','sigma_star_f7','success_f7','four_prob_f7','eval_rate_f7',...
%     'T_f8','f_x_f8','sigma_f8','sigma_star_f8','success_f8','four_prob_f8','eval_rate_f8',...
%     'T_f9','f_x_f9','sigma_f9','sigma_star_f9','success_f9','four_prob_f9','eval_rate_f9');
% 


% Count # of diverge 
f_diverge_COUNT = [sum(sum(sum(T_f6 == 9999,1),2),3),...
    sum(sum(sum(T_f7 == 9999,1),2),3),...
    sum(sum(sum(T_f8 == 9999,1),2),3),...
    sum(sum(sum(T_f9 == 9999,1),2),3)];



f_GPmml_diverge_COUNT_all = [sum(sum(sum(T_f6(3:5,:,:) == 9999,1),2),3),...
    sum(sum(sum(T_f7(3:5,:,:) == 9999,1),2),3),...
    sum(sum(sum(T_f8(3:5,:,:) == 9999,1),2),3),...
	sum(sum(sum(T_f9(3:5,:,:) == 9999,1),2),3)]

f6_GPmml_diverge_COUNT_REP = sum(T_f6(3:5,:,:),3);
f7_GPmml_diverge_COUNT_REP = sum(T_f7(3:5,:,:),3);
f8_GPmml_diverge_COUNT_REP = sum(T_f8(3:5,:,:),3);



f_GPmml_diverge_PEC = f_GPmml_diverge_COUNT_all./...
    [sum(sum(sum(T_f6(3:5,:,:) ~= 9999,1),2),3),...
    sum(sum(sum(T_f7(3:5,:,:) ~= 9999,1),2),3),...
    sum(sum(sum(T_f8(3:5,:,:) ~= 9999,1),2),3),...
    sum(sum(sum(T_f9(3:5,:,:) ~= 9999,1),2),3)]


f_onPlusOne_diverge_COUNT = [sum(sum(sum(T_f6(1,:,:) == 9999,1),2),3),...
    sum(sum(sum(T_f7(1,:,:) == 9999,1),2),3),...
    sum(sum(sum(T_f8(1,:,:) == 9999,1),2),3),...
    sum(sum(sum(T_f9(1,:,:) == 9999,1),2),3)]


% strategy index
s = 3;
% function parameter index
f = 21;
% replicate index 
r = 49;

f_x_array = squeeze(f_x_f7(s,f,r,:));
sigma_array = squeeze(sigma_f7(s,f,r,:));
sigma_star_array = squeeze(sigma_star_f7(s,f,r,:));
success_rate = squeeze(success_f7(s,f,r));
eval_rate = squeeze(eval_rate_f7(s,f,r));
four_probs = squeeze(four_prob_f7(s,f,r,:));

T_range = 1:9999;

% figure(334)
% 
% subplot(1,3,1)
% hold on;
% plot(T_range,f_x_array(T_range));hold on;
% xlabel('function calls','FontSize',15);
% ylabel('function value','FontSize',15);
% set(gca, 'YScale', 'log');
% 
% subplot(1,3,2)
% hold on;
% plot(T_range,sigma_array(T_range));hold on;
% xlabel('function calls','FontSize',15);
% ylabel('step size','FontSize',15);
% set(gca, 'YScale', 'log');
% 
% subplot(1,3,3)
% hold on;
% plot(T_range,sigma_star_array(T_range));hold on;
% xlabel('function calls','FontSize',15);
% ylabel('normalized step size','FontSize',15);
% set(gca, 'YScale', 'log');






