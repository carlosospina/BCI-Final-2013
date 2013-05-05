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

numBins=3;
decimationFactor = 50;
numFeatures=6;

%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub3_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));

%% Process the windows for all data samples
Feature_array1=processWindows(test_data);
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
    y(:,i)=(tmpData)';
end

%% Linear regression
lr=linearRegression;
X=lr.buildX(featureMatrix, numFeatures, numBins);

% Find the filter
%filter=lr.findFilter(X,y);

%% Predict 
prediction=X*filter;
interpolatedVal = zeros(size(prediction,1),size(prediction,2));
tmpDecimate=12;
for i=1:size(prediction,2)
    tmpdata = decimate(prediction(:,i)',tmpDecimate);
    tmpData=calcSpline(tmpDecimate,tmpdata');
    interpolatedVal(:,i)=tmpData(1:size(interpolatedVal,1),:);
end
prediction=interpolatedVal;

%% Find correlation
% adjust the size of y to have the same amount of rows
% Fix number of rows on X, according to y
numRows=min(size(y,1),size(prediction,1));
y=y(1:numRows,:);
prediction=prediction(1:numRows,:);
cf=zeros(1,size(prediction,2));
% for each finger
for i=1:size(prediction,2)
    cf(1,i)=corr(prediction(:,i),y(:,i));
    r2=rtwo(prediction(:,i),y(:,i));
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
useFingers=[1 2 3 5];
display(sprintf('Average correlation (no finger4): %f \n',mean(cf(useFingers))));

%%
% finding the spline cubic function
eval_dg = zeros(size(prediction,1)...
    *decimationFactor,size(shiftedY,2));
for i=1:size(prediction,2)
    eval_dg(:,i)= calcSpline(decimationFactor,prediction(:,i));
end

%save response
save('sub3_eval.mat','eval_dg');

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

