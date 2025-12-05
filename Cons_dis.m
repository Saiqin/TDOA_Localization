function [Mean_X, Max_X,Min_X] = Cons_dis(Error)
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
NR_X_Max = max(NR_X,[],2);
GN_X_Max = max(GN_X,[],2);
SD_X_Max = max(SD_X,[],2);

NR_X_Max_ML = max(NR_X_ML,[],2);
GN_X_Max_ML = max(GN_X_ML,[],2);
SD_X_Max_ML = max(SD_X_ML,[],2);
%% Min
NR_X_Min = min(NR_X,[],2);
GN_X_Min = min(GN_X,[],2);
SD_X_Min = min(SD_X,[],2);

NR_X_Min_ML = min(NR_X_ML,[],2);
GN_X_Min_ML = min(GN_X_ML,[],2);
SD_X_Min_ML = min(SD_X_ML,[],2);


Mean_X = ([NR_X_Mean NR_X_Mean_ML GN_X_Mean GN_X_Mean_ML SD_X_Mean SD_X_Mean_ML]);
Max_X = ([NR_X_Max NR_X_Max_ML GN_X_Max GN_X_Max_ML SD_X_Max SD_X_Max_ML]);
Min_X = ([NR_X_Min NR_X_Min_ML GN_X_Min GN_X_Min_ML SD_X_Min SD_X_Min_ML]);

