function [Sig_Tar,Sig_Del]=generate_echo(R,B,T,Tr,SNR,Time,DelayTime,JNR)
%% fundamental parameters
c=3e8;         
mu=B/T;
fs=4*B;

N_T=round(fs*T);
N_Tr=round(fs*Tr);

%% 产生信号
t=[0:1/fs:T-1/fs];
lfm=exp(1i*pi*mu*t.^2);
if ~exist('LFM.mat')
    save LFM.mat lfm
end
t1 = (0 : N_Tr - 1)/fs;

Target= round( R / c * fs) + fix(Time * fs); 

noise1 = 0.707 * (randn(1, N_Tr) + 1i * randn(1, N_Tr));
Sig_Tar = noise1;
for i=1:length(Target)
    Sig_Tar(Target(i):Target(i)+N_T-1) = Sig_Tar(i,Target(i):Target(i)+N_T-1)...
        +10^(SNR/20)*lfm;
end

Sig_Del = 0 * 0.707 * (randn(1, N_Tr) + 1i * randn(1, N_Tr));
if ~isempty(DelayTime) & DelayTime~= 0
    DeltaDelay = fix(DelayTime * fs);
    noise2 = 0 * (randn(1, N_Tr) + 1i * randn(1, N_Tr));
    Sig_Del = noise2;
    for i=1:length(DeltaDelay)
        Sig_Del(DeltaDelay(i):DeltaDelay(i)+N_T-1) = ...
            Sig_Del(DeltaDelay(i):DeltaDelay(i)+N_T-1)...
            +10^(JNR/20)*lfm;
    end
end



