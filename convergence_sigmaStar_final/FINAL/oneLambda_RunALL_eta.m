% 

%oneLambda_RunALL_eta(subplotNum,FigureNum_opt1,FigureNum_opt2)
%Input
%   mu                    # parents AND # of parents replaced by offspring
%   lambda                generated offspring size
%   ita:                  ita = sigma_ep_star /sigma_star
%   n:                    dim of data
%   scatterColour:        r  Red, g  Green, b   Blue, c   Cyan, m  Magenta, y  Yellow, k   Black,w  White
%   typeDot:              type of dot (+  Plus sign, o  Circle, *  Asterisk, x    Cross)
%                         *: n=10     s: square n=100
%   LINE_OR_NOT:          justScatter = 0, includeLine = 1, dottedLine = 2
%   c_mu_lambda:          parameter for ploting the solide line 

%Return
%   dotted curve for opt. fitGain 

%
function val = oneLambda_RunALL_eta(subplotNum,FigureNum_opt1,FigureNum_opt2)


% subplotNum = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(subplotNum == 0) % (1+1)-ES
    lambda= 0;
    mu = 0;
    opt_plot_colour = 'c';
elseif (subplotNum == 1)
    lambda = 10;
    mu = ceil(lambda/4);
    opt_plot_colour = 'k';
elseif(subplotNum == 2)
    lambda = 20;
    mu = ceil(lambda/4);
    opt_plot_colour = 'b';
elseif(subplotNum == 3)
    lambda = 40;
    mu = ceil(lambda/4);
    opt_plot_colour = 'm';
else
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For expected convergence rate 
step = 0.0000001;
x = -10:step:10;
% expected fitness gain for n->\infty  under mu and lambda
if(mu==3 && lambda==10)
    c_mu_lambda = 1.065389626877247; % expected convergence rate for (3/3,10)-ES
elseif(mu==5 && lambda==20)
    c_mu_lambda = 1.214478382788638; % expected convergence rate for (5/5,20)-ES
elseif(mu==10 && lambda==40)
    c_mu_lambda = 1.242204493664515; % expected convergence rate for (10/10,40)-ES
elseif(mu ==0 && lambda == 0)        % for (1+1)-ES
    c_mu_lambda = 0;                               
else 
    c_mu_lambda = (lambda-mu)/(2*pi)*nchoosek(lambda,mu)*sum(exp(-x.^2).*(normcdf(x)).^(lambda-mu-1).*(1-normcdf(x)).^(mu-1))*step;
end

% If NOT (1+1)-ES
if(subplotNum~=0)

    legend('-DynamicLegend'); 

    % black
    ita = 0;
    
    s_start = 0.0001;
    increment =0.02;
    s_end = 50+s_start;
    sigma_star = s_start:increment:s_end;
    expected_cure = sigma_star*(c_mu_lambda)./sqrt(1+ita^2)-sigma_star.^2./(2*mu);
    expected_cure = expected_cure./lambda;
    d1 = sprintf('(%d/%d,%d)-ES',mu,mu,lambda);
    figure(FigureNum_opt1);
    plot(sigma_star,expected_cure,'Color',opt_plot_colour,'DisplayName',d1); hold on; 
    ylabel('opt. expected fitness gain \eta_{opt}','FontSize',15);
    xlabel('normalized step size \sigma^*','FontSize',15); 
    xlim([0 50]);
    ylim([0 inf]);
    [max_expected_cure expected_cure_max_index] = max(expected_cure);
    max_sigma_star = sigma_star(expected_cure_max_index);
    legend('-DynamicLegend'); 
    legend('show');
    
          
    disp(d1);
    
    box on;

    if(subplotNum==3)
        p2 = sprintf('opt_curve.fig');
        saveas(gcf,p2);
    end
    
    legend('-DynamicLegend'); 
    d1 = sprintf('N \\rightarrow \\infty');
    figure(FigureNum_opt2);hold on;
    subplot(1,2,1);
    plot([0 11],[max_expected_cure max_expected_cure],':','Color',opt_plot_colour,'DisplayName',d1);hold on;
    ylabel('opt. expected fitness gain \eta_{opt}','FontSize',15);
    xlabel('noise-to-signal-ratio \upsilon','FontSize',15); 
    % set(gca, 'XScale', 'log');
    set(gca,'FontSize',15);
    box on;
    
    if(subplotNum==3)
        box on;
        d2 = sprintf('N \\rightarrow \\infty');
        plot([0 11],[0.202 0.202],':','Color','r','DisplayName',d2); hold on; 
        legend('-DynamicLegend'); 
        legend('show');
    end
    xlim([0 10]);
    ylim([0 10]);
    
    legend('-DynamicLegend'); 
    legend('show');
    
    
    
    subplot(1,2,2);
    d1 = sprintf('(%d/%d,%d)-ES',mu,mu,lambda);
    plot([0 11],[max_sigma_star max_sigma_star],':','Color',opt_plot_colour,'DisplayName',d1);hold on;
    ylabel('opt. normalized step size \sigma^*_{opt}','FontSize',15);
    xlabel('noise-to-signal-ratio \upsilon','FontSize',15); 
    % set(gca, 'XScale', 'log');
    set(gca,'FontSize',15);
    box on;
    if(subplotNum==3)
        d2 = sprintf('(1+1)-ES');
        plot([0 11],[1.224 1.224],':','Color','r','DisplayName',d2); hold on;
        legend('-DynamicLegend'); 
    	legend('show');
        
        p3 = sprintf('opt_fitGain_step_v1.fig');
        saveas(gcf,p3);
    end
    xlim([0 10.05]);
    ylim([0 15]);
    legend('-DynamicLegend'); 
    legend('show');
    
    
    
    val = {max_sigma_star,max_expected_cure};
end

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot opt. expected fitness gain over noise-to-signal ratio 
% % experimental (x o for n = 10,100) and solid n->infty
% 
% s_start = 0.0001;
% increment =1;
% s_end = 10+s_start;
% v_array = s_start:increment:s_end;                                          % For experimental result
% 
% % v_expedted_curve_array = 0.0001:0.0001:20;                                % plot curve n -> infty
% v_expedted_curve_array = exp(-2.302585092994046: 0.0461:2.302585092994046+0.01);
% 
% FIG_NUM = 5;
% figure(FIG_NUM);
% subplot(1,2,1);hold on;
% if(subplotNum~=0)
%     fun_precise_optFitGain_over_v(f,NUM_OF_RUNS,mu,lambda,v_array,10,opt_plot_colour,'x',c_mu_lambda,v_expedted_curve_array);    % plot n = 10 (x)
% else 
%     subplotNum_step = 2;
%     fun_precise_optFitGain_over_v_ONE(f,NUM_OF_RUNS,FIG_NUM,subplotNum_step,v_array,10,opt_plot_colour,'x',c_mu_lambda,v_expedted_curve_array);
% end
% disp('* done'); 
% figure(FIG_NUM);
% subplot(1,2,1);hold on;
% fun_precise_optFitGain_over_v(f,NUM_OF_RUNS,mu,lambda,v_array,100,opt_plot_colour,'o',c_mu_lambda,v_expedted_curve_array);   % plot n = 100 (o)
% disp('s done');
% xlim([0 10]);
% ylim([0 inf]);
% box on;
% 
% 
% % % save opt. expected fitGain
% % if(subplotNum==3)
% %     box on;
% %     p2 = sprintf('opt_fitGain.fig');
% %     saveas(gcf,p2);
% % end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % noise-to-signal ratio
% % % v = 0.1:0.00001:10;
% % v = 0.001*2.^(1:1:18);
% % % solve the plot by taking derivative
% % % opt. step size
% % figure(5);
% % plot(v,c_mu_lambda*mu./(sqrt(1+v.*v)));
% % xlabel('noise-to-signal ratio \upsilon','FontSize',15);%
% % ylabel('opt. normalized step size \sigma^*','FontSize',15); 
% % set(gca, 'XScale', 'log');
% % set(gca,'FontSize',15);
% % p1 = sprintf('opt. normalized step size (%d/%d,%d)-ES',mu,mu,lambda);
% % title(p1,'fontsize',20);
% % p2 = sprintf('opt_step_size_%d_%d_%d_ES.fig',mu,mu,lambda);
% % saveas(gcf,p2);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % opt. fitness gain given opt. step size n= 10,100,infty
% % sigma_star = 0.1:0.001:8;
% % v_range = 0.001/2*2.^(1:1:19);
% % v_range_trans = transpose(v_range);
% % % a matrix 
% % row: different noise-to-signal ratio v
% % col: different normalized step size sigmaStar
% % n=10;
% % expected_cure_10 = c_mu_lambda*sigma_star.*(1+sigma_star.^2/2/mu/n)./(sqrt(1+sigma_star.^2/mu/n).*sqrt(1+v_range_trans.^2+sigma_star.^2/2/n))-n*(sqrt(1+sigma_star.^2/mu/n)-1);
% % [max_fitness_array_10 s_index] = max(expected_cure_10,[],2);
% % n=100;
% % expected_cure_100 = c_mu_lambda*sigma_star.*(1+sigma_star.^2/2/mu/n)./(sqrt(1+sigma_star.^2/mu/n).*sqrt(1+v_range_trans.^2+sigma_star.^2/2/n))-n*(sqrt(1+sigma_star.^2/mu/n)-1);
% % [max_fitness_array_100 s_index] = max(expected_cure_100,[],2);
% 
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot opt. expected step size gain over noise-to-signal ratio 
% % solid n->infty
% if(subplotNum~=0)
%     figure(FIG_NUM);hold on;
%     subplot(1,2,2);hold on;
%     v_range = v_expedted_curve_array;
%     sigma_star = c_mu_lambda*mu./(sqrt(1+v_range.*v_range));
%     plot(v_range,sigma_star,'Color',opt_plot_colour);
%     ylabel('opt. normalized step size \sigma^*_{opt}','FontSize',15);
%     xlabel('noise-to-signal-ratio \upsilon','FontSize',15); 
%     % set(gca, 'XScale', 'log');
%     set(gca,'FontSize',15);
%     box on;
%     xlim([0 10]);
%     ylim([0 inf]);
% end
% 
% % Add legend when last run(largest lambda)
% if(subplotNum==3)
%     leg = legend('(1+1)-ES','(3/3,10)-ES','(5/5,20)-ES','(10/10,40)-ES');
%     leg.FontSize = 10;
%     title(leg,'Model assisted');
%     box on;
%     p2 = sprintf('opt_stepSize_fitGain_FINAL.fig');
%     saveas(gcf,p2);
% end


end