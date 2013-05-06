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

numBins=3;
decimationFactor = 50;
numFeatures=6;

%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub1_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));

%% Reduce space of sensors using PCA to find the most relevant ones
chosenColumns=chooseColumns(train_data);
newTrainData=train_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTrainData);
%save('Feature1_3.mat','Feature_array1');
%load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Process data from glove
% 1) Remove 200ms of data due to delay between brain and hand
shiftedY=train_dg(201:end,:);
% 2) Downsample Y by DecimationFactor (50)
numColsY=size(shiftedY,2)
numRowsY=size(shiftedY,1)/decimationFactor
y=zeros(numRowsY,numColsY);
ySize=size(y)
for(i=1:numColsY)
    % two step decimation
    data=shiftedY(:,i)';
    tmpData=decimate(data,10);
    tmpData = decimate(tmpData,5);
    y(:,i)=(tmpData(1:size(y,1)))';
end

%% Predict train data
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
% Find the filter
filter=lr.findFilter(X,y);
% predict
prediction=X*filter;
% Pad the prediction matrix to have the smae number of predictions as Y
prediction=[prediction;prediction(end,:)];
prediction=[prediction;prediction(end,:)];
prediction=[prediction;prediction(end,:)];

%% Find correlation with train_dg
[cf corrAvg]=findFingerCorrelation(prediction,y);
for i=1:size(predictionTmp,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));

%% =============== TEST DATA =============
%% Reduce space of sensors for test DATA
newTrainData=test_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTrainData);
save('testFeatures1.mat','Feature_array1');
%load('testFeatures1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Predict test data
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
% Use filter from train data
prediction=X*filter;
% Pad the prediction matrix to have the smae number of predictions as Y
prediction=[prediction;prediction(end,:)];
prediction=[prediction;prediction(end,:)];
prediction=[prediction;prediction(end,:)];
%% Process data from glove
% 1) Remove 200ms of data due to delay between brain and hand
shiftedY=test_dg(201:end,:);
% 2) Downsample Y by DecimationFactor (50)
numColsY=size(shiftedY,2)
numRowsY=size(shiftedY,1)/decimationFactor
y=zeros(numRowsY,numColsY);
ySize=size(y)
for(i=1:numColsY)
    % two step decimation
    data=shiftedY(:,i)';
    tmpData=decimate(data,10);
    tmpData = decimate(tmpData,5);
    y(:,i)=(tmpData(1:size(y,1)))';
end
%% Find correlation with test_dg
[cf corrAvg]=findFingerCorrelation(prediction,y);
for i=1:size(predictionTmp,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));

aaaa

%%
% finding the spline cubic function
eval_dg = zeros(size(prediction,1)...
    *decimationFactor,size(shiftedY,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
end

%save response
%sub1test_dg=eval_dg;
%save('sub1_eval.mat','subltest_dg');

numInterpolatedRows=size(eval_dg,1);
subplot(2,5,1);
for i=1:size(prediction,2)
    subplot(2,5,i);
    plot(train_dg(1:numInterpolatedRows,i));
    title('Original');
    subplot(2,5,i+5);
    plot(eval_dg(1:numInterpolatedRows,i));
    title('Predicted');
end

% numInterpolatedRows=50%size(interpolatedVal,1);
% subplot(2,1,1);
% plot(y(1:numInterpolatedRows,1));
% title('Original');
% subplot(2,1,2);
% plot(prediction(1:numInterpolatedRows,1));
% title('Predicted');


%%
subplot(2,1,1);
plot(train_dg(1:numInterpolatedRows,1));
title('Original');
subplot(2,1,2);
plot(eval_dg(1:numInterpolatedRows,1));
title('Predicted');


%%
numRows=size(sub3test_dg);
while numRows<200000
    sub3test_dg=[sub3test_dg;sub3test_dg(end,:)];
    numRows=size(sub3test_dg);
end
%%
subplot(2,1,1)
plot(train_data(:,20));
subplot(2,1,2)

d = fdesign.bandpass('N,F3db1,F3dB2',6,1,10,1000);
Hd = design(d,'butter');
test_filter = filter(Hd, train_data(:,ch));
plot(test_filter);

%%
ch=20;
subplot(2,1,1)
spectrogram(train_data(:,ch),100,50,1000,1000);
subplot(2,1,2)
Fs = 1000;  % Sampling Frequency
N  = 6;    % Order
Fc = 100;  % Cutoff Frequency
% the BUTTER function.
[z, p, k] = butter(N, Fc/(Fs/2));
[sos_var,g] = zp2sos(z, p, k);
Hd          = dfilt.df2sos(sos_var, g);

test_filter = filter(Hd, test_data(:,ch));
spectrogram(test_filter,100,50,1000,1000);


