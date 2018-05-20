%% Plot timings from output file
% Readability


tTime = output.trainTime(2:end); tTime(32) = mean([tTime(31) tTime(33)]);
pTime = output.predictTime(2:end);
eTime = output.peTime(2:end);


% 1 Gen

    % Single Prediction
    Y(:,1) = smooth((pTime./10000));

    % Model Training
    Y(:,2) = smooth(tTime,30);

    % Illumination
    Y(:,3) = smooth(pTime,30);
    
    % Evaluation
    Y(:,4) = smooth(eTime);

% Cumulative and full Map-Elites Cost
    Y2 = cumsum(Y);
    Y2(:,5) = 10000*median(eTime).*ones(size(Y2(:,4)));
 
% Figures
xScale = 210:10:1000;
figure(1)
yyaxis left;
    h1 = plot(xScale,Y(:,2));
yyaxis right;
    h2 = plot(xScale,Y(:,3));
    
h1.LineWidth = 3; h2.LineWidth = 3;
title('Computation Time by Number of Sample');
legend('Model Training', 'Illumination (Prediction\times10,000)',...
        'Location','SouthOutside','Orientation','horizontal');
grid on
set(gca,'FontSize',18); grid on;

% h=plot(200:10:990,Y,'LineWidth',3);
% set(gca,'YScale','log');
% legend('Single Prediction','Model Training',...
%         'Illumination (Prediction\times10,000)',...
%         'Precise Evaluation',...
%         'Location','SouthOutside','Orientation','horizontal')
% title('Computation Time Per Iteration')
% set(gca,'YScale','linear','FontSize',18); grid on;
% 
% for i=1:length(h)
%     text(h(i).XData(end)+15,h(i).YData(end),seconds2human(h(i).YData(end)))
% end

%-%
figure(2)
h = plot(xScale,Y2(:,2:5),'LineWidth',3);
legend('Model Training',...
        'Illumination (Prediction\times10,000)',...
        'Precise Evaluation','MAP-Elites (Evaluation\times10,000)',...
        'Location','SouthOutside','Orientation','horizontal')
title('Cumulative Computation Time')
h(end).LineStyle = ':';
set(gca,'YScale','log','FontSize',18); grid on;

for i=1:length(h)
    text(h(i).XData(end)+5,h(i).YData(end),seconds2human(h(i).YData(end)))
end


% % Matrix form
% %Y = [tTime; eTime; pTime]';
% evalTime = median(eTime);
% Y = [smooth(tTime,10) smooth(pTime,10)];
% 
% %
% clf;
% h = area(Y);
% %h = area(cumsum(Y));
% h(1).FaceColor = [0 0.25 0.25];
% h(2).FaceColor = [0 0.5 0.5];
% %h(3).FaceColor = [0 0.75 0.75];
% legend('Model Training\times2','Prediction \times10,000',...
%         'Location','SouthOutside','Orientation','horizontal')
% 
% ylabel('Seconds');xlabel('Precise Evaluations')

