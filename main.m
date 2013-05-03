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

%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub1_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));

%% Process the windows for all data samples
Feature_array1=processWindows(train_data);
save('Feature1_1.mat','Feature_array1');
%load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Downsample Y by 50
size_train_dg=size(train_dg);
numColsY=size(train_dg,2);
numRowsY=size(train_dg,1)/50;
y=zeros(numRowsY,numColsY);
for(i=1:numColsY)
    data=train_dg(:,i)';
    y(:,i)=(decimate(decimate(data,10),5))';
end
%% Normalize features before processing
normFeatureMatrix=normalizeByColumn(featureMatrix);

%% Create coficients for classifier
lr=linearRegression;
[filter X]=lr.createFilters(normFeatureMatrix, y, 6, 3);

%% Predict 
prediction=X*filter;
%% Find correlation
% adjust the size of y
newY=y(1:size(X,1),:);
% for each finger
for i=1:size(prediction,2)
    cf=corr(prediction(:,i),newY(:,i));
    r2=rtwo(prediction(:,i),newY(:,i));
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf));
end