function Feature_array = Calc_features( train_data )
       
        
WindowSize = 100; % block length
Bins = 2*500;
Overlap = 50;
Fs = 1000; % fs: sampling frequency
Overlap_factor = WindowSize / Overlap; % Since we have 50 ms overlap so 
decimation_factor = 100;

Electrodes = size( train_data,2 );
Num_features = 6; 
feat_rows = size( train_data,1 ) * Overlap_factor / decimation_factor;

feat_column = Electrodes * (Num_features ) ;


Feature_array = zeros( feat_rows - 1 ,feat_column );    
% Calculating the first feature, i.e the mean of the voltages
for i = 1:Electrodes
    for j = 1:feat_rows - 1
        Feature_array(j,1 + Num_features*(i-1)) = ...
            mean(train_data( (j-1)*50+1:(j+1)*50,i));
    end
end



for i = 1:Electrodes
    [S,f,t] = spectrogram(train_data(:,i),WindowSize,Overlap,Bins,Fs);
    
    S = S';
    Feature_array(:,2+ Num_features*(i-1)) = sum(abs(S(:,7:16)'))';   
    %the 7th bin is corresponding to 6Hz, so here is 6Hz to 15Hz
    
    Feature_array(:,3+ Num_features*(i-1)) = sum(abs(S(:,22:26)'))';
    Feature_array(:,4+Num_features*(i-1)) = sum(abs(S(:,77:116)'))';
    Feature_array(:,5+Num_features*(i-1)) = sum(abs(S(:,127:161)'))';
    Feature_array(:,6+Num_features*(i-1)) = sum(abs(S(:,162:176)'))';
    clear S;

end






