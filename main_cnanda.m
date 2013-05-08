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
training_size = 400000;
[train_data, train_dg, test_data, test_dg]= Folding(train_data(1:training_size,:),train_dg(1:training_size,:));

for i = 1 : size (train_data,2)
   
    train_data(:,i) = smooth(train_data(:,i),'loess');
    
end
%%
% Data centering CAR 
train_data = calcCAR(train_data);
%% Reduce space of sensors using PCA to find the most relevant ones
chosenColumns=1:1:size(train_data,2);
%chosenColumns=chooseColumns(train_data);
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
for i = 1 : size(train_dg,2)
    train_dg(:,i) = smooth(train_dg(:,i),'loess');
end
y=downsampleGlove(train_dg,decimationFactor);
coeffs=lr.findFilter(X,y);
%% Predict
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
%     eval_dg(:,i) = smooth(eval_dg(:,i),'sgolay',5 );% filter the data
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 
%%
%Peak findng algo
% y = findpeaks(eval_dg,'MINPEAKHEIGHT',0.7 * max(eval_dg));
% pass: data, peak threshold, filter threshold 
% eval_dg = customFilter(eval_dg,0.7,0.4);
% function returnData = customFilter( data,peakThreshold,filterThreshold )
% returnData = zeros(size(data,1),size(data,2));
peakThreshold = 0.5;
filterThreshold = 0.001;
temp_dg = zeros(size(eval_dg,1),size(eval_dg,2));
Y = zeros(size(eval_dg,1),size(eval_dg,2));
temp = zeros(size(eval_dg,1),size(eval_dg,2));
for i = 1 : size(eval_dg,2)
    colum_max = max(eval_dg(:,i));
    Y(:,i) = findpeaks(eval_dg,'THRESHOLD',0.7);
    temp(Y(:,i)) = [];
    mean_column = mean( eval_dg(Y(:,i);
    for j = 1: size(eval_dg,1)
        if eval_dg(j,i) <= ( peakThreshold * colum_max )
            
            diff = eval_dg(j +1,i)- eval_dg(j,i);
            temp_dg(j,i)= eval_dg(j,i) + diff *filterThreshold;
    
        else
             temp_dg(j,i)= eval_dg(j,i);
        end
        
    end

end
eval_dg = temp_dg;

%% Find correlation with train_dg
[cf corrAvg]=findFingerCorrelation(train_dg,eval_dg);
for i=1:size(cf,2)
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation (no finger4): %f \n',corrAvg));
%% Plot Results
plotResults(train_dg,eval_dg);
aaa
%% =============== TEST DATA =============
%% Reduce space of sensors for test DATA
% for i = 1 : size(test_data,1)
%     test_data(:,i) = smooth(test_data(:,i));
% end
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
prediction=lr.predictData(coeffs,X);
% Upsample using splines
eval_dg = zeros(size(prediction,1)*decimationFactor,size(prediction,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
%     eval_dg(:,i) = filter(hd,eval_dg(:,i) );% filter the data
end
eval_dg=[zeros(200,5);eval_dg(1:end-200,:)]; 

%save response
sub3test_dg=eval_dg;
save('subtest3_dg.mat','sub3test_dg');
disp(sprintf('Prediction Saved\n'));

%% Find correlation with test_dg
[cf corrAvg]=findFingerCorrelation(test_dg,eval_dg);
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
plot(train_dg(1:time,finger));
title('Original');
hold on;
plot(eval_dg(1:time,finger),'r');
hold off;


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
data=eval_dg(:,1)';
b = filter(Hd,data');
plot(b);
% plotResults(y,prediction);