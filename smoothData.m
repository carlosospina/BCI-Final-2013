function newData = smoothData(data)
    %Smooth data using FIR
    numSteps=100;
    a = 1;
    b = ones(1,numSteps).*1/numSteps; %Something like b=[1/n 1/n 1/n ....]
    newData = filter(b,a,data);
    %Small data
    smallValIndex=find(newData<=0.7);
    meanSmall=mean(newData(smallValIndex));
    newData(smallValIndex)=(newData(smallValIndex)/3)+meanSmall;
    %Large data (predictions)
%     largeValIndex=find(newData>1.7);
%     meanLarge=mean(newData(largeValIndex));
%     newData(largeValIndex)=(newData(largeValIndex)*2/meanLarge);
end