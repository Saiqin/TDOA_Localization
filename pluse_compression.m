function [result_after]=pluse_compression(S_echo,B,T,Tr)
%% fundamental parameters
c=3e8;
f0 = 60e9;                    
lambda = c/f0;

mu=B/T;
fs=2*B;

N_T=round(fs*T);
N_Tr=round(fs*Tr);

%% 产生信号
t=(-N_T/2:N_T/2-1)/fs;
lfm=exp(1i*pi*mu*t.^2);
t1 = (0 : N_Tr - 1)/fs;

Nfft=2^(nextpow2(N_Tr+length(N_T)-1));
win=taylorwin(N_T,4,-40);Coe_win=lfm.*win';
Hf = fftshift(fft(conj(flipud(Coe_win)),Nfft));  
%S_echo = Sig_Tar + Sig_Del;
Sf=fftshift(fft(S_echo,Nfft));
result = ifft(ifftshift(Sf.*Hf,Nfft));
result_after = [result(N_T+1:N_T+N_Tr)];


