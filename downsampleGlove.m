%% Process data from glove
function y=downsampleGlove(train_dg,decimationFactor)
    % 1) Remove 200ms of data due to delay between brain and hand
    shiftedY=train_dg(201:end,:);
    % 2) Downsample Y by DecimationFactor (50)
    numColsY=size(shiftedY,2);
    numRowsY=size(shiftedY,1)/decimationFactor;
    y=zeros(numRowsY,numColsY);
    ySize=size(y);
    for(i=1:numColsY)
        % two step decimation
        data=shiftedY(:,i)';
        tmpData=decimate(data,10);
        tmpData = decimate(tmpData,5);
        tmpData = tmpData';
        y(:,i)=(tmpData(1:size(y,1)));
    end
end