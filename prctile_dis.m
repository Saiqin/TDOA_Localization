function [Mean_X, Max_X,Min_X] = prctile_dis(Error)
%% Error bar
NR_X = squeeze(Error(:,:,1));
GN_X = squeeze(Error(:,:,2));
SD_X = squeeze(Error(:,:,3));

NR_X_ML = squeeze(Error(:,:,4));
GN_X_ML = squeeze(Error(:,:,5));
SD_X_ML = squeeze(Error(:,:,6));
%% Mean
NR_X_Mean = mean(abs(NR_X),2);
GN_X_Mean = mean(abs(GN_X),2);
SD_X_Mean = mean(abs(SD_X),2);

NR_X_Mean_ML = mean(abs(NR_X_ML),2);
GN_X_Mean_ML = mean(abs(GN_X_ML),2);
SD_X_Mean_ML = mean(abs(SD_X_ML),2);
%% Max
upper =95;
NR_X_Max = prctile(NR_X,upper,2);
GN_X_Max = prctile(GN_X,upper,2);
SD_X_Max = prctile(SD_X,upper,2);

NR_X_Max_ML = prctile(NR_X_ML,upper,2);
GN_X_Max_ML = prctile(GN_X_ML,upper,2);
SD_X_Max_ML = prctile(SD_X_ML,upper,2);
%% Min
lower = 5;
NR_X_Min = prctile(NR_X,lower,2);
GN_X_Min = prctile(GN_X,lower,2);
SD_X_Min = prctile(SD_X,lower,2);

NR_X_Min_ML = prctile(NR_X_ML,lower,2);
GN_X_Min_ML = prctile(GN_X_ML,lower,2);
SD_X_Min_ML = prctile(SD_X_ML,lower,2);


Mean_X = ([NR_X_Mean NR_X_Mean_ML GN_X_Mean GN_X_Mean_ML SD_X_Mean SD_X_Mean_ML]);
Max_X = ([NR_X_Max NR_X_Max_ML GN_X_Max GN_X_Max_ML SD_X_Max SD_X_Max_ML]);
Min_X = ([NR_X_Min NR_X_Min_ML GN_X_Min GN_X_Min_ML SD_X_Min SD_X_Min_ML]);

