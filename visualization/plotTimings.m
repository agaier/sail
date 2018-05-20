%% Plot timings from output file
% Readability
tTime = output.trainTime;
pTime = output.predictTime;
eTime = output.peTime;

% Matrix form
Y = [tTime; eTime; pTime]';

%
clf;
%h = area(Y);
h = area(cumsum(Y));
h(1).FaceColor = [0 0.25 0.25];
h(2).FaceColor = [0 0.5 0.5];
h(3).FaceColor = [0 0.75 0.75];
legend('Precise Evaluation\times10','Model Training\times2','Prediction \times25000',...
        'Location','SouthOutside','Orientation','horizontal')

ylabel('Seconds');xlabel('Precise Evaluations')

