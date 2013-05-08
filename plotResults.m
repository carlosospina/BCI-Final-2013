function plotResults(train_dg,eval_dg)
    numRows=min(size(train_dg,1),size(eval_dg,1));
    numFingers=size(train_dg,2);
    close all;
    figure;
    subplot(2,numFingers,1);
    for i=1:numFingers
        subplot(2,numFingers,i);
        plot(train_dg(1:numRows,i));
        title('Original');
        subplot(2,numFingers,i+numFingers);
        plot(eval_dg(1:numRows,i));
        title('Predicted');
    end
end