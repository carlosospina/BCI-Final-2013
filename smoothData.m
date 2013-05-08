function newData = smoothData(data)
    %Smooth data using FIR
    numSteps=50;
    a = 1;
    b = ones(1,numSteps).*1/numSteps; %Something like b=[1/n 1/n 1/n ....]
    newData = filter(b,a,data);
    %Small data
    smallValIndex=find(newData<=1);
    meanSmall=mean(newData(smallValIndex));
    newData(smallValIndex)=(newData(smallValIndex)/2)+meanSmall;
    %Large data (predictions)
%     largeValIndex=find(newData>2);
%     meanLarge=mean(newData(largeValIndex));
%     newData(largeValIndex)=(newData(largeValIndex)*3/meanLarge);
end