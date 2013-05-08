function [CARData]=calcCAR(data)

% Data centering CAR 
meanTrain = size(data,1);
CARData =  zeros( size(data,1), size(data,2));
 
for i  = 1: size( data,1)
    
    meanTrain(i) = mean(data(i,:));
    CARData(i,:) = data(i,:) - meanTrain(i);

end