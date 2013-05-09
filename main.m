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

% ======= Lowpass Filter ===========
Fs = 1000;  % Sampling Frequency
N  = 8    % Order
Fc = 100;  % Cutoff Frequency
% the BUTTER function.
[z, p, k] = butter(N, Fc/(Fs/2));
[sos_var,g] = zp2sos(z, p, k);
lpf          = dfilt.df2sos(sos_var, g);


%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub1_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));


%% Creating the folding matrices 
training_size = 100000;%size(train_data,1);
[train_data, train_dg, test_data, test_dg]= Folding(train_data(1:training_size,:),train_dg(1:training_size,:));

%% Data centering CAR 
% train_data=smoothData(train_data);
% train_dg=smoothData(train_dg);
% test_data=smoothData(test_data);
% test_dg=smoothData(test_dg);
train_data = calcCAR(train_data);
test_data = calcCAR(test_data);
%% Reduce space of sensors. find the most relevant ones
chosenColumns=1:1:size(train_data,2);
%chosenColumns=chooseColumns(train_data);
newTrainData=train_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTrainData);
save('trainFeatures1.mat','Feature_array1');
%load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;
%% Find X
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
%% Find filter
y=downsampleGlove(train_dg,decimationFactor);
coeffs=lr.findFilter(X,y);
%% Predict
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
%    eval_dg=filter(lpf,eval_dg);
%    eval_dg(:,i)=smoothData(eval_dg(:,i));
%     eval_dg(:,i) = filter(Hd,eval_dg(:,i) );% filter the data
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 
% Find correlation with train_dg
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
newTestData=test_data(:,chosenColumns);
%% Process the windows for all data samples
Feature_array1=processWindows(newTestData);
save('testFeatures1.mat','Feature_array1');
%load('testFeatures1.mat','Feature_array1');
featureMatrix=Feature_array1;
%% Predict test data
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);
%% Predict
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 

%save response
sub1test_dg=eval_dg;
save('subtest1_dg.mat','sub1test_dg');
disp(sprintf('Prediction Saved\n'));

%% Find correlation with test_dg
[cf corrAvg]=findFingerCorrelation(test_dg,eval_dg);
% y=downsampleGlove(test_dg,decimationFactor);
%[cf corrAvg]=findFingerCorrelation(y,prediction);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));

%% Plot Results
plotResults(test_dg,eval_dg);

BREAK_HERE

% numInterpolatedRows=50%size(interpolatedVal,1);
% subplot(2,1,1);
% plot(y(1:numInterpolatedRows,1));
% title('Original');
% subplot(2,1,2);
% plot(prediction(1:numInterpolatedRows,1));
% title('Predicted');


%%
clf
finger=1;
time=30000;
plot(test_dg(1:time,finger));
title('Original');
hold on;
plot(eval_dg(1:time,finger),'r');
hold off;

%%
plot(train_dg(1:time,finger),'r');
%%
numRows=size(sub3test_dg);
while numRows<200000
    sub3test_dg=[sub3test_dg;sub3test_dg(end,:)];
    numRows=size(sub3test_dg);
end
size(sub3test_dg)
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
% ======== bandpass filter ===========
Fs = 1000;  % Sampling Frequency
N   = 8;    % Order
Fc1 = 5;    % First Cutoff Frequency
Fc2 = 200;  % Second Cutoff Frequency
% Calculate the zpk values using the BUTTER function.
[z,p,k] = butter(N/2, [Fc1 Fc2]/(Fs/2));
% To avoid round-off errors, do not use the transfer function.  Instead
% get the zpk representation and convert it to second-order sections.
[sos_var,g] = zp2sos(z, p, k);
bpf          = dfilt.df2sos(sos_var, g);
% ======= Lowpass Filter ===========
Fs = 1000;  % Sampling Frequency
N  = 4    % Order
Fc = 10;  % Cutoff Frequency
% the BUTTER function.
[z, p, k] = butter(N, Fc/(Fs/2));
[sos_var,g] = zp2sos(z, p, k);
lpf          = dfilt.df2sos(sos_var, g);

numRows=30000;
data=train_dg(:,1);
%data=filter(lpf,data);
data=smoothData(data);
clf
plot(train_dg(1:numRows,1))
hold on
plot(data(1:numRows,:),'red')
