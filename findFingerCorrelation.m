%% Find correlation
% adjust the size of y to have the same amount of rows
% Fix number of rows on X, according to y
function [cf corrAvg] = findFingerCorrelation(predictedY,Y);
    numRows=min(size(Y,1),size(predictedY,1));
    %Y=Y(1:numRows,:);
    %predictedY=predictedY(1:numRows,:);
    cf=zeros(1,size(predictedY,2));
    % for each finger
    for i=1:5
        cf(1,i)=corr(predictedY(1:numRows,i),Y(1:numRows,i));
        r2=rtwo(predictedY(1:numRows,i),Y(1:numRows,i));
    end
    useFingers=[1 2 3 5];
    corrAvg=mean(cf(useFingers));
end
