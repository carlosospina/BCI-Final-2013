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


%% Creating the folding matrices 
training_size = 100000;
[train_data, train_dg, test_data, test_dg] = Folding(train_data(1:training_size,:),train_dg(1:training_size,:));

%% Data centering CAR 
meanTrain=mean(train_data,2);
meanTest = mean(test_data,2);
for i  = 1: size( train_data,2)
    train_data(:,i) = train_data(:,i) - meanTrain;
    test_data(:,i) = test_data(:,i) - meanTest;
end
%% Reduce space of sensors using PCA to find the most relevant ones
chosenColumns=chooseColumns(train_data);
newTrainData=train_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTrainData);
save('trainFeatures1.mat','Feature_array1');
% load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;
%% Find X
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
%% Find filter
y=downsampleGlove(train_dg,decimationFactor);
filter=lr.findFilter(X,y);
%% Predict
prediction=lr.predictData(filter,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
end
%% Find correlation with train_dg
[cf corrAvg]=findFingerCorrelation(train_dg,eval_dg);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));
%% Plot Results
plotResults(train_dg,eval_dg);

%% =============== TEST DATA =============
%% Reduce space of sensors for test DATA
newTestData=test_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTestData);
save('testFeatures1.mat','Feature_array1');
% load('testFeatures1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Predict test data
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
%% Predict
prediction=lr.predictData(filter,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(shiftedY,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
end
%save response
sub1test_dg=eval_dg;
save('subtest_dg.mat','sub1test_dg');
%% Process data from glove
y=downsampleGlove(train_dg,decimationFactor);
%% Find correlation with test_dg
[cf corrAvg]=findFingerCorrelation(eval_dg,y);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));

%% Plot Results
plotResults(train_dg,eval_dg);

Forced-End

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

%%
for i=1:size(y,2)
    smalValIndex=find(y(:,i)<1);
    y(smalValIndex,i)=0;
end
size(y)



%%
data=prediction(:,1)'
b = filter(Hd,data);
%plotResults(y,prediction);