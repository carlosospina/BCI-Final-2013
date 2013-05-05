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

%% Process the windows for all data samples
% Feature_array1=processWindows(train_data);
% save('Feature1_1.mat','Feature_array1');
load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Downsample Y by 50
size_train_dg=size(train_dg);
numColsY=size(train_dg,2);
numRowsY=size(train_dg,1)/decimationFactor;
y=zeros(numRowsY,numColsY);
for(i=1:numColsY)
    data=train_dg(:,i)';
    % two step decimation
    tmpData=decimate(data,floor(decimationFactor/5));
    tmpData = decimate(tmpData,decimationFactor/10);
    y(:,i)=(tmpData)';
end

%% Create coficients for regression
lr=linearRegression;
[filter X]=lr.createFilters(featureMatrix, y, numFeatures, numBins);

%% Predict 
prediction=X*filter;
%% Find correlation
% adjust the size of y
newY=y(1:size(X,1),:);
cf=zeros(1,size(prediction,2));
% for each finger
for i=1:size(prediction,2)
    cf(1,i)=corr(prediction(:,i),newY(:,i));
    r2=rtwo(prediction(:,i),newY(:,i));
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
display(sprintf('Average correlation: %f \n',mean(cf)));

%%
% finding the spline cubic function
interpolatedVal = zeros(size(prediction,1)...
    *decimationFactor,size(train_dg,2));
for i=1:size(prediction,2)
    interpolatedVal(:,i)= calcSpline(decimationFactor,prediction(:,i));
end

numInterpolatedRows=size(interpolatedVal,1);
subplot(2,1,1);
plot(train_dg(1:numInterpolatedRows,1));
title('Original');
subplot(2,1,2);
plot(interpolatedVal(1:numInterpolatedRows,1));
title('Predicted');
