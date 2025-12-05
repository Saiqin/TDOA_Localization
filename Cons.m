function [Mean_X, Mean_Y, Max_X,Max_Y,Min_X,Min_Y] = Cons(Error)
%% Error bar
NR_X = squeeze(Error(:,:,1,1));
NR_Y = squeeze(Error(:,:,2,1));
GN_X = squeeze(Error(:,:,1,2));
GN_Y = squeeze(Error(:,:,2,2));
SD_X = squeeze(Error(:,:,1,3));
SD_Y = squeeze(Error(:,:,2,3));

NR_X_ML = squeeze(Error(:,:,1,4));
NR_Y_ML = squeeze(Error(:,:,2,4));
GN_X_ML = squeeze(Error(:,:,1,5));
GN_Y_ML = squeeze(Error(:,:,2,5));
SD_X_ML = squeeze(Error(:,:,1,6));
SD_Y_ML = squeeze(Error(:,:,2,6));
%% Mean
NR_X_Mean = mean(abs(NR_X),2);
NR_Y_Mean = mean(abs(NR_Y),2);
GN_X_Mean = mean(abs(GN_X),2);
GN_Y_Mean = mean(abs(GN_Y),2);
SD_X_Mean = mean(abs(SD_X),2);
SD_Y_Mean = mean(abs(SD_Y),2);

NR_X_Mean_ML = mean(abs(NR_X_ML),2);
NR_Y_Mean_ML = mean(abs(NR_Y_ML),2);
GN_X_Mean_ML = mean(abs(GN_X_ML),2);
GN_Y_Mean_ML = mean(abs(GN_Y_ML),2);
SD_X_Mean_ML = mean(abs(SD_X_ML),2);
SD_Y_Mean_ML = mean(abs(SD_Y_ML),2);
%% Max
NR_X_Max = max(NR_X,[],2);
NR_Y_Max = max(NR_Y,[],2);
GN_X_Max = max(GN_X,[],2);
GN_Y_Max = max(GN_Y,[],2);
SD_X_Max = max(SD_X,[],2);
SD_Y_Max = max(SD_Y,[],2);

NR_X_Max_ML = max(NR_X_ML,[],2);
NR_Y_Max_ML = max(NR_Y_ML,[],2);
GN_X_Max_ML = max(GN_X_ML,[],2);
GN_Y_Max_ML = max(GN_Y_ML,[],2);
SD_X_Max_ML = max(SD_X_ML,[],2);
SD_Y_Max_ML = max(SD_Y_ML,[],2);
%% Min
NR_X_Min = min(NR_X,[],2);
NR_Y_Min = min(NR_Y,[],2);
GN_X_Min = min(GN_X,[],2);
GN_Y_Min = min(GN_Y,[],2);
SD_X_Min = min(SD_X,[],2);
SD_Y_Min = min(SD_Y,[],2);

NR_X_Min_ML = min(NR_X_ML,[],2);
NR_Y_Min_ML = min(NR_Y_ML,[],2);
GN_X_Min_ML = min(GN_X_ML,[],2);
GN_Y_Min_ML = min(GN_Y_ML,[],2);
SD_X_Min_ML = min(SD_X_ML,[],2);
SD_Y_Min_ML = min(SD_Y_ML,[],2);


Mean_X = ([NR_X_Mean NR_X_Mean_ML GN_X_Mean GN_X_Mean_ML SD_X_Mean SD_X_Mean_ML]);
Mean_Y = ([NR_Y_Mean NR_Y_Mean_ML GN_Y_Mean GN_Y_Mean_ML SD_Y_Mean SD_Y_Mean_ML]);
Max_X = ([NR_X_Max NR_X_Max_ML GN_X_Max GN_X_Max_ML SD_X_Max SD_X_Max_ML]);
Max_Y = ([NR_Y_Max NR_Y_Max_ML GN_Y_Max GN_Y_Max_ML SD_Y_Max SD_Y_Max_ML]);
Min_X = ([NR_X_Min NR_X_Min_ML GN_X_Min GN_X_Min_ML SD_X_Min SD_X_Min_ML]);
Min_Y = ([NR_Y_Min GN_Y_Min_ML GN_Y_Min NR_Y_Min_ML SD_Y_Min SD_Y_Min_ML]);
