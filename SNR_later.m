close all;clear all;clc;
%% LFM
c=3e8;
B=5e6;                          %信号带宽
T=10e-6;                         %脉宽
Tr=200e-6;
fs=4*B;
N_T=round(fs*T);
N_Tr=round(fs*Tr);
dis_unit = 1/fs*c;
%% the positions
N = 4;
Tx = [0,0]'; % source position to be determined
x1 = [0,0];
x2 = [-15,0];
x3 = [0,30];
x4 = [45,0];
Rx =  [x1;x2;x3;x4]';
dis_real = (sqrt(sum((Tx*ones(1,N)-Rx).^2,1))).';
[~,I]  = sort(dis_real); %% order to receive
Rx = Rx(:,I);
dis_real = (sqrt(sum((Tx*ones(1,N)-Rx).^2,1))).';
%% Ture
Time = [5e-6] ;
Target= fix( dis_real(end) / c * fs) + fix(Time * fs);
%% generate the signal
DelayTime = [25e-6 45e-6 60e-6 70e-6] ; % 这里的
delay_num = length(DelayTime);
%%
not = 100; % number of trials

range_dB = [-16:4:10];

load LFM.mat lfm
LFM = lfm;
for kk = 1:length(range_dB)
    kk
    for run = 1:not
        for ii =1:N
            SNR = range_dB(kk);
            JNR = range_dB(kk)+10;
            [Sig_Tar(ii,:),Sig_Del(ii,:)] = generate_echo(dis_real(ii),B,T,Tr,SNR,Time,DelayTime,JNR);
            S_echo(ii,:) = Sig_Tar(ii,:)+Sig_Del(ii,:);
        end
        S_comp = XY_corr(LFM, S_echo);
        %% obtain the distance
        time = dis_real/c;
        t1 = (0 : N_Tr - 1)/fs;
        dis_all = t1*c;
        delay_num = length(DelayTime);

        for ii = 1:N
            %% case 2
            [Value,locs] = findpeaks(abs(S_comp(ii,:)));
            [V_Index,Index] = sort(Value,'descend');
            Peak1(ii,:) = locs(Index(1:delay_num));

            max_range = min(Peak1(ii,:));
            S = max_range-500+1;
            hide_range = S: max_range-300; %%%%%  !!!!
            if hide_range(1)<=0  S =1;  hide_range = 1:max_range-300;end
            [V_hide,I_hide] = max(abs(S_comp(ii,hide_range)));
            Peak2(ii) = S + I_hide -1;
        end

        %
        [V_att,I_att] = sort(Peak1(:,1)');
        % Rx_att = Rx(:,I_att);

        % [V_use,I_use] = sort(Peak2');
        V_use = Peak2';
        % Rx_use = Rx(:,I_use);

        D1_all = V_att' - V_att(1);
        D2_all = V_use - V_use(1);

        D1 = D1_all * dis_unit + 0.00001;
        D2 = D2_all * dis_unit + 0.00001;
        % figure;hold on;
        % plot(db(S_comp(4,:)));
        % plot(Peak2(end),db(S_comp(4,Peak2(end))),'ro');
        % plot(Target,db(S_comp(4,Target)),'go');
        % 
        % legend('signal','Find','True')


        sigma21 = ones(N,1) * 1/10^(20/10);%D1.^2/10^(20/10);
        sigma22 = ones(N,1) * 1/10^(20/10);%D2.^2/10^(20/10);
        TOA_result1 = TDOA(D1,Rx,0,sigma21);
        TOA_result2 = TDOA(D2,Rx,0,sigma22);
        A_Error = vecnorm(TOA_result1 - Tx);
        B_Error = vecnorm(TOA_result2 - Tx);
        boundary_A = 10^6;
        boundary_B = 10^6;
        if any(A_Error > boundary_A)  && ~all(A_Error > boundary_A)
            mean_value = mean(TOA_result1(:,A_Error < boundary_A),2);
            TOA_result1(1,A_Error >= boundary_A) = mean_value(1);
            TOA_result1(2,A_Error >= boundary_A) = mean_value(2);
        end
        if all(A_Error < 1)
            TOA_result1 = 0.01*ones(2,6);
        end
        if all(A_Error > boundary_A)
            TOA_result1 = 650000*ones(2,6);
        end
        %%
        if all(B_Error > boundary_B)
            TOA_result2 = 650000*ones(2,6);
            % run = run-1;
            % continue;
        end
        if any(B_Error > boundary_B)  && ~all(B_Error > boundary_B)
            mean_value = mean(TOA_result2(:,B_Error < boundary_B),2);
            TOA_result2(1,B_Error >= boundary_B) = mean_value(1);
            TOA_result2(2,B_Error >= boundary_B) = mean_value(2);
        end
        if all(B_Error < 1)
            TOA_result2 = 0.01*ones(2,6);
        end
        boundary_A = 10^3;
        boundary_B = 10^3;
        if any(A_Error > boundary_A)  && ~all(A_Error > boundary_A)
            mean_value = mean(TOA_result1(:,A_Error < boundary_A),2);
            TOA_result1(1,A_Error >= boundary_A) = mean_value(1);
            TOA_result1(2,A_Error >= boundary_A) = mean_value(2);
        end
        if any(B_Error > boundary_B)  && ~all(B_Error > boundary_B)
            mean_value = mean(TOA_result2(:,B_Error < boundary_B),2);
            TOA_result2(1,B_Error >= boundary_B) = mean_value(1);
            TOA_result2(2,B_Error >= boundary_B) = mean_value(2);
        end
        Error1(kk,run,:,:)  = abs(squeeze(TOA_result1) - Tx);
        Error2(kk,run,:,:)  = abs(squeeze(TOA_result2) - Tx);
        Error_dis1(kk,run,:) = sqrt(squeeze(sum(Error1(kk,run,:,:).^2)));
        Error_dis2(kk,run,:) = sqrt(squeeze(sum(Error2(kk,run,:,:).^2)));
        AA = squeeze(Error_dis1(kk,run,:));
        BB = squeeze(Error_dis2(kk,run,:));

        if any(BB>10^6)
            1
        end
    end
    clear Sig_Tar_True S_comp_True Peak delay_time
end

[Mean_X1, Mean_Y1, Max_X1,Max_Y1,Min_X1,Min_Y1] = Cons(Error1);
[Mean_X2, Mean_Y2, Max_X2,Max_Y2,Min_X2,Min_Y2] = Cons(Error2);
[dis_Mean1,dis_Max1,dis_Min1] = prctile_dis(Error_dis1);
[dis_Mean2,dis_Max2,dis_Min2] = prctile_dis(Error_dis2);

color=[0 0.4470 0.7410
    0.8500 0.3250 0.0980
    0.4940 0.1840 0.5560
    0.6350 0.0780 0.1840
    0.4660 0.6740 0.1880
    0.3010 0.7450 0.9330
    0.6350 0.0780 0.1840
    ];
str = {'d','o','s','x','v','^','o','p'};

SNR = 1:length(range_dB);
%% Dis error
figure; hold on;box on;grid on;
for ii=1:6
    errorbar(SNR+(ii-3)*0.1  ,dis_Mean2(:,ii), dis_Mean2(:,ii) - dis_Min2(:,ii), dis_Max2(:,ii) - dis_Mean2(:,ii),str{ii},'linewidth',1.1);
end
xlabel('SNR before Correlator (dB)','FontSize',12,'Fontname','Times New Roman','FontWeight','bold')
ylabel('MPE (m)','FontSize',12,'Fontname','Times New Roman','FontWeight','bold');
% title('First Signal','FontSize',12,'Fontname','Times New Roman','FontWeight','bold')
ax = gca; % 获取当前轴的句柄
ax.FontSize = 20; % 设置字体大小
ax.FontWeight = 'bold'; % 设置字体为粗体
ax.FontName = 'Times New Roman'; % 设置字体类型为Arial
set(ax, 'YScale', 'log');
legend({'Newton Raphson NLS','Newton Raphson ML','Gauss Netwon NLS','Gauss Netwon  ML','Steepest Descent NLS',...
    'Steepest Descent  ML'},'FontSize',14,'Fontname','Times New Roman',...
    'FontWeight','bold','Orientation','horizontal','NumColumns',1);
xlim([SNR(end,1)-0.5 SNR(end,end)+0.5]);
ylim([0.01,100000])


figure; hold on;box on;grid on;
for ii=1:6
    errorbar(SNR+(ii-3)*0.1  ,dis_Mean1(:,ii), dis_Mean1(:,ii) - dis_Min1(:,ii), dis_Max1(:,ii) - dis_Mean1(:,ii),str{ii},'linewidth',1.1);
end
xlabel('SNR before Correlator (dB)','FontSize',12,'Fontname','Times New Roman','FontWeight','bold')
ylabel('MPE (m)','FontSize',12,'Fontname','Times New Roman','FontWeight','bold');
% title('Delay Signal','FontSize',12,'Fontname','Times New Roman','FontWeight','bold')
ax = gca; % 获取当前轴的句柄
ax.FontSize = 20; % 设置字体大小
ax.FontWeight = 'bold'; % 设置字体为粗体
ax.FontName = 'Times New Roman'; % 设置字体类型为Arial
set(ax, 'YScale', 'log');
legend({'Newton Raphson NLS','Newton-Raphson ML','Gauss Netwon NLS','Gauss Netwon  ML','Steepest Descent NLS',...
    'Steepest Descent  ML'},'FontSize',14,'Fontname','Times New Roman',...
    'FontWeight','bold','Orientation','horizontal','NumColumns',1);
xlim([SNR(end,1)-0.5 SNR(end,end)+0.5]);
ylim([6,1200000])
