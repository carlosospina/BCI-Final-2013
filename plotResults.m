function plotResults(train_dg,eval_dg)
    numRows=size(train_dg,1);
    figure;
    subplot(2,5,1);
    for i=1:5
        subplot(2,5,i);
        plot(train_dg(1:numRows,i));
        title('Original');
        subplot(2,5,i+5);
        plot(eval_dg(1:numRows,i));
        title('Predicted');
    end
end