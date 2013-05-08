function [CARData]=calcCAR(data)
    % Data centering CAR 
    CARData =  zeros( size(data,1), size(data,2));    
    for i  = 1: size( data,1)
        meanTrain = mean(data(i,:));
        CARData(i,:) = data(i,:) - meanTrain;
    end
end