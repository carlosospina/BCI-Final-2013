function predictedY=predictData(filter, X)
    % predict
    prediction=X*filter;
    % Pad the prediction matrix to have the smae number of predictions as Y
    prediction=[prediction;prediction(end,:)];
    prediction=[prediction;prediction(end,:)];
    prediction=[prediction;prediction(end,:)];
    predictedY=prediction;
end