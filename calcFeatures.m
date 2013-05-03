
%%
% data - Windowed data 100 x 62 
function Feature_array = calcFeatures( data, fs )
    windowSize=size(data,1);
    Electrodes=size(data,2);
    numFeatures=6;
    Feature_array = zeros(1,numFeatures*Electrodes);    

    for i = 1:Electrodes
        baseColumn=(i-1)*numFeatures;
        % Calculate mean
        Feature_array(baseColumn+1)=mean((data(:,i)));

        % Calculate frquency features
        [S,f,t] = spectrogram(data(:,i),windowSize,windowSize/2,1000,fs);

        S = S';
        %the 7th bin is corresponding to 6Hz, so here is 6Hz to 15Hz
        Feature_array(baseColumn+2) = sum(abs(S(:,7:16)'))';   

        Feature_array(baseColumn+3) = sum(abs(S(:,22:26)'))';
        Feature_array(baseColumn+4) = sum(abs(S(:,77:116)'))';
        Feature_array(baseColumn+5) = sum(abs(S(:,127:161)'))';
        Feature_array(baseColumn+6) = sum(abs(S(:,162:176)'))';
        clear S;
    end



for i = 1:Electrodes

end






