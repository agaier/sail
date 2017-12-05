% GP Tests

p = paramsGP(35);

%% Split Data
sRange = 1:1500;
sRangeEnd = 1+sRange(end);
train  = genome(sRange,:);
test   = genome(sRangeEnd:end,:);

trainX  = result(sRange,1);
testX   = result(sRangeEnd:end,1);

trainY  = result(sRange,2);
testY   = result(sRangeEnd:end,2);

%% Train Models
gpX = trainGP(train,trainX,p);  % Create Model
gpY = trainGP(train,trainY,p);  % Create Model

%% Test Models
predX = predictGP(gpX,test);
errorX = predX(:,1)-testX;
percErrorX = errorX./testX;
mseX = mean(errorX.^2);

predY = predictGP(gpY,test);
errorY = predY(:,1)-testY;
percErrorY = errorY./testY;
mseY = mean(errorY.^2);

%% Show Results
hf = figure(1); clf; hf.Name = 'Percentage Error';
subplot(2,1,1); hist(percErrorX); title('X Coordinate, % Error')
subplot(2,1,2); hist(percErrorY); title('Y Coordinate, % Error')

hf = figure(2); clf; hf.Name = 'Absolute Error';
subplot(2,1,1); hist(errorX); title('X Coordinate, Absolute Error')
subplot(2,1,2); hist(errorY); title('Y Coordinate, Absolute Error')


hf = figure(3); clf; hf.Name = 'Predicted and True Position';
background = imread('maze600.pbm'); colormap(gray);
imagesc(background);hold on;

scatter(testX,testY); scatter(predX(:,1),predY(:,1));
hl = legend('True End Point','Predicted End Point');
hl.FontSize = 18;
title('Predicted and True Position','FontSize',20);
xticklabels('');yticklabels('');






