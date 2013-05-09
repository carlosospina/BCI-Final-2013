%%
% <latex>
% \title{EL9113 \\{\normalsize Spring 2013}}
% \author{BCI Group}
% \Carlos Ospina
% \Jordan Wolf
% \Chinmay Nanda
% \date{1/13/2012}
% \maketitle
% </latex>

% clear the workspace and console
clc
clear 

decimationFactor = 50;

%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub1_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));


%% Creating the folding matrices 
training_size = 200000;%Xsize(train_data,1);
[train_data, train_dg, test_data, test_dg]= Folding(train_data(1:training_size,:),train_dg(1:training_size,:));

%% Data centering CAR 
train_data = calcCAR(train_data);
test_data = calcCAR(test_data);

%% Reduce space of sensors. find the most relevant ones
chosenColumns=1:1:size(train_data,2);
%chosenColumns=chooseColumns(train_data);
train_data=train_data(:,chosenColumns);

%% Process the windows for all data samples
featureMatrix=processWindows(train_data);
save('trainFeatures1.mat','featureMatrix');
%load('Feature1_1.mat','featureMatrix');
%% Find X
featureMatrix=normalizeByColumn(featureMatrix);
featureMatrix=normalizeByRow(featureMatrix);
lr=linearRegression;
X=lr.buildX(featureMatrix);
%% Find filter
y=downsampleGlove(train_dg,decimationFactor);
coeffs=lr.findFilter(X,y);
%% Predict
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
%    eval_dg(:,i)=smoothData(eval_dg(:,i));
%    eval_dg(:,i) = filter(Hd,eval_dg(:,i) );% filter the data
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 
%% Find correlation with train_dg
[cf corrAvg]=findFingerCorrelation(train_dg,eval_dg);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));
%% Plot Results
plotResults(train_dg,eval_dg);

BREAK_HERE
%% =============== TEST DATA =============
%% Reduce space of sensors for test DATA
test_data=test_data(:,chosenColumns);
%% Process the windows for all data samples
featureMatrix=processWindows(test_data);
save('testFeatures1.mat','featureMatrix');
%load('testFeatures1.mat','featureMatrix');
%% Find X for test data
featureMatrix=normalizeByColumn(featureMatrix);
featureMatrix=normalizeByRow(featureMatrix);
lr=linearRegression;
X=lr.buildX(featureMatrix);
%% Predict
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
%     eval_dg(:,i)=smoothData(eval_dg(:,i));
%     eval_dg(:,i) = filter(hd,eval_dg(:,i) );% filter the data
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 

%save response
sub1test_dg=eval_dg;
save('subtest1_dg.mat','sub1test_dg');
disp(sprintf('Prediction Saved\n'));

%% Find correlation with test_dg
[cf corrAvg]=findFingerCorrelation(test_dg,eval_dg);
% y=downsampleGlove(test_dg,decimationFactor);
% [cf corrAvg]=findFingerCorrelation(y,prediction);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));

%% Plot Results
plotResults(test_dg,eval_dg);

Forced_End_Of_Program

% numInterpolatedRows=50%size(interpolatedVal,1);
% subplot(2,1,1);
% plot(y(1:numInterpolatedRows,1));
% title('Original');
% subplot(2,1,2);
% plot(prediction(1:numInterpolatedRows,1));
% title('Predicted');


%%
finger=1;
time=100000;
plot(test_dg(1:time,finger));
title('Original');
hold on;
plot(eval_dg(1:time,finger),'r');
hold off;

