% code to align signals using cross correlation

% source :  https://www.mathworks.com/help/signal/ug/align-signals-using-cross-correlation.html
clear

load ke.mat


k = 1;
idx_shift = [];
% Get reference signals
for k = 1:5
    for freq = 0:6

       sig_2 = ke((k-1)*70 + freq+1).fluc_filt;   

       % Loop over all the trials and get the signal to align
       for trial = 2:10
            (k-1)*70 + (trial-1)*7 + freq + 1
           sig_1 = ke( (k-1)*70 + (trial-1)*7 + freq + 1).fluc_filt;   

           % apply cross correlation
           [c_21, lag_21] = xcorr(sig_2,sig_1);
           [max_val,max_idx] = max(c_21);
           idx_shift(k,freq+1,trial) = lag_21(max_idx);
       end


    end
end
1


% plot the aligned signals
%%

load relatedsig

ax(1) = subplot(3,1,1);
plot(s1)
ylabel('s_1')
axis tight

ax(2) = subplot(3,1,2);
plot(s2)
ylabel('s_2')
axis tight

ax(3) = subplot(3,1,3);
plot(s3)
ylabel('s_3')
axis tight
xlabel('Samples')

linkaxes(ax,'x')

[C21,lag21] = xcorr(s2,s1);
C21 = C21/max(C21);

[C31,lag31] = xcorr(s3,s1);
C31 = C31/max(C31);

[C32,lag32] = xcorr(s3,s2);
C32 = C32/max(C32);

[M21,I21] = max(C21);
t21 = lag21(I21);

[M31,I31] = max(C31);
t31 = lag31(I31);

[M32,I32] = max(C32);
t32 = lag31(I32);


subplot(3,1,1)
plot(lag21,C21,[t21 t21],[-0.5 1],'r:')
text(t21+100,0.5,['Lag: ' int2str(t21)])
ylabel('C_{21}')
axis tight
title('Cross-Correlations')

subplot(3,1,2)
plot(lag31,C31,[t31 t31],[-0.5 1],'r:')
text(t31+100,0.5,['Lag: ' int2str(t31)])
ylabel('C_{31}')
axis tight

subplot(3,1,3)
plot(lag32,C32,[t32 t32],[-0.5 1],'r:')
text(t32+100,0.5,['Lag: ' int2str(t32)])
ylabel('C_{32}')
axis tight
xlabel('Samples')