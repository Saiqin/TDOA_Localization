function [result_after] = XY_corr(LFM, Input)
% LFM　参考信号
% Input 输入
    TpLen = length(LFM);
    win=taylorwin(round(TpLen),4,-30)';
    lmf_win=LFM.*win;
    [num_Cycle,num_Distance]=size(Input);
    for ii = 1:num_Cycle
        results(ii,:) = conv(Input(ii,:),conj(fliplr(lmf_win)));
        result_after(ii,:) = results(ii,TpLen:TpLen+num_Distance-1);
    end 
end