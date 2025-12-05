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
%% generate the signal
Time = [15e-6] ;
DelayTime = [45e-6 60e-6 85e-6 105e-6] - Time; % 这里的
delay_num = length(DelayTime);
%% ture signal
Sig= zeros(1,N_Tr);
mu=B/T;
t=[0:1/fs:T-1/fs];
lfm = exp(1i*pi*mu*t.^2);
LFM =lfm;
save LFM.mat lfm
SNR = 5;
JNR = 15;

Target= round( dis_real(end) / c * fs) + fix(Time * fs); 
noise1 = 0.707 * (randn(1, N_Tr) + 1i * randn(1, N_Tr));
Sig_Tar = noise1;
for i=1:length(Target)
    Sig_Tar(Target(i):Target(i)+N_T-1) = Sig_Tar(i,Target(i):Target(i)+N_T-1)...
        +10^(SNR/20)*lfm;
end
Sig_Del = noise1;
DeltaDelay = fix(DelayTime * fs);
for i=1:length(DeltaDelay)
    Sig_Del(DeltaDelay(i):DeltaDelay(i)+N_T-1) = ...
        Sig_Del(DeltaDelay(i):DeltaDelay(i)+N_T-1)...
        +10^(JNR/20)*lfm;
end
S_echo = Sig_Tar+Sig_Del;
S_comp = XY_corr(LFM, S_echo);
for ii = 1:1
    %% case 2
    [Value,locs] = findpeaks(abs(S_comp(ii,:)));
    [V_Index,Index] = sort(Value,'descend');
    Peak1(ii,:) = locs(Index(1:delay_num));
    Peak2(ii) = locs(Index(delay_num+1));
end
t1 = (0 : N_Tr - 1)/fs;

h = figure;box on; grid on; hold on;
plot(t1*1e6,db(abs(Sig_Tar(1,:))),'Color','#77AC30','LineWidth',1);
plot(t1*1e6,db(abs(Sig_Del(1,:))),'Color','#7E2F8E','LineWidth',1);
xlabel('Time (us)','FontSize',14,'Fontname','Times New Roman','FontWeight','bold');
ylabel('Amlpitude (dB)','FontSize',14,'Fontname','Times New Roman','FontWeight','bold');
ylim([-10 20]);
set(gca,'fontsize',16,'fontname','Times');
legend('True signal','Delay signal','FontSize',16,'Fontname','Times New Roman','FontWeight','bold');
ax = gca; % 获取当前轴的句柄



First = Peak2./fs;
De = Peak1./fs
h = figure;box on; grid on; hold on;
plot(First*1e6,db(abs(S_comp(1,Peak2(1)))),'o','Color','#77AC30','LineWidth',2);
plot(De*1e6,db(abs(S_comp(1,Peak1(1,:)))),'o','Color','#7E2F8E','LineWidth',2);
plot(t1*1e6,db(abs(S_comp(1,:))),'Color','#0072BD','LineWidth',1);
xlabel('Time (us)');
ylabel('Amlpitude (dB)');
ylim([-10 70]);
set(gca,'fontsize',20,'fontname','Times');
ax = gca; % 获取当前轴的句柄


