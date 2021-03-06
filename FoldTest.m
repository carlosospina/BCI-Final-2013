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
% clear 

numBins=3;
decimationFactor = 50;
numFeatures=6;

%% Load Data
disp(sprintf('Loading data... \n'));
fileName='be521_sub1_compData.mat'
load(fileName); % Load the data for the first patient
disp(sprintf('... done loading data\n'));


%% Process the windows for all data samples
training_size = 400000;
[train_datx, train_daty, test_datx, test_daty] = ...
    Folding(train_data(1:training_size,:),train_dg(1:training_size,:));

%%
%  run the train_data
% Feature_array1=processWindows(train_datx);
% save('Feature1_train.mat','Feature_array1');
%  run the test_data
% Feature_array1=processWindows(test_datx);
% save('Feature1_1.mat','Feature_array1');

load('Feature1_test.mat','Feature_array1');
% 
featureMatrix=Feature_array1;

%% Process data from glove
% 1) Remove 200ms of data due to delay between brain and hand
% shiftedY = train_daty;
shiftedY = test_daty;
% shiftedY=train_dg(201:end,:);
% 2) Downsample Y by DecimationFactor (50)
numColsY=size(shiftedY,2)
numRowsY=floor(size(shiftedY,1)/decimationFactor)
y=zeros(numRowsY,numColsY);
ySize=size(y)
for(i=1:numColsY)
    % two step decimation
    data=shiftedY(:,i)';
    tmpData=decimate(data,10);
    tmpData = decimate(tmpData,5);
    tmpData = (tmpData)';
    y(:,i)= tmpData(1:size(y,1));
end

%% Linear regression
lr=linearRegression;
% unknown value of R matrix, 
X=lr.buildX(featureMatrix, numFeatures, numBins);
% Find the filter
% filter=lr.findFilter(X,y);

%% Predict 
prediction=X*filter;
% decimate for better results
interpolatedVal = zeros(size(prediction,1),size(prediction,2));
% tmpDecimate=12;
% for i=1:size(prediction,2)
%     tmpdata = decimate(prediction(:,i)',tmpDecimate);
%     tmpData=calcSpline(tmpDecimate,tmpdata');
%     interpolatedVal(:,i)=tmpData(1:size(interpolatedVal,1),:);
% end
% prediction=interpolatedVal;
% Pad the prediction matrix to have the smae number of predictions as Y
% prediction=[prediction;prediction(end,:)];
% prediction=[prediction;prediction(end,:)];
% prediction=[prediction;prediction(end,:)];
% normalize prediction
%prediction=normalizeByColumn(prediction);

%% Find correlation
% adjust the size of y to have the same amount of rows
% Fix number of rows on X, according to y
numRows=min(size(y,1),size(prediction,1));
y=y(1:numRows,:);
predictionTmp=prediction(1:numRows,:);
cf=zeros(1,size(prediction,2));
% for each finger
for i=1:size(predictionTmp,2)
    cf(1,i)=corr(predictionTmp(:,i),y(:,i));
    r2=rtwo(predictionTmp(:,i),y(:,i));
    display(sprintf('Finger %d ==> correlation: %f \n',i,cf(1,i)));
end
useFingers=[1 2 3 5];
display(sprintf('Average correlation (no finger4): %f \n',...
    mean(cf(useFingers))));

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

% aaaa
%%
subplot(2,1,1);
plot(train_dg(1:numInterpolatedRows,1));
title('Original');
subplot(2,1,2);
plot(eval_dg(1:numInterpolatedRows,1));
title('Predicted');


%%
% numRows=size(sub3test_dg);
% while numRows<200000
%     sub3test_dg=[sub3test_dg;sub3test_dg(end,:)];
%     numRows=size(sub3test_dg);
% end
% %
% subplot(2,1,1)
% plot(train_data(:,20));
% subplot(2,1,2)
% plot(decimate(train_data(:,20),100));
% 
% %
% ch=20;
% subplot(2,1,1)
% spectrogram(train_data(:,ch),100,50,1000,1000);
% subplot(2,1,2)
% spectrogram(test_data(:,ch),100,50,1000,1000);
% 
% 
% %
% Config vars:
% topNColumns=50
% topNPrincipalComp=3
% 
% 1,2 we find the PCA from R, removing first column
% [pc,score,latent,tsquare] = princomp(X(:,2:end));
% 
% If we plot the PC matrix:
% clf;
% imagesc(pc(:,1:topNPrincipalComp));
% colorbar();
% 
% 3 Find the 100 columns of the first 10 Principal Components
% chosenColumns=zeros(topNPrincipalComp,topNColumns);
% for i=1:topNPrincipalComp
%     [sortedValues,sortIndex] = sort(pc(:,i),'descend');
%     chosenColumns(i,:)=sortIndex(1:topNColumns,1)';
% end
% 
% 4 Remove Repeated
% chosenColumns=reshape(chosenColumns,1,topNPrincipalComp*topNColumns);
% chosenColumns=unique(chosenColumns);
