% code to align signals using cross correlation

% source :  https://www.mathworks.com/help/signal/ug/align-signals-using-cross-correlation.html
clear

load ke.mat


k = 1;
idx_shift = [];


% Get reference signals
for k = 1
    for freq = 0:6        
       sig_2{freq+1} = ke((k-1)*70 + freq+1).fluc_filt;   
       sig_2{freq+1} = ke((k-1)*70 + freq+1).ke_filt(:,3);   
    end
end
   

for row = 8:350
       
           sig_1 = ke(row).fluc_filt;   
           sig_1 = ke(row).ke_filt(:,3);   
           sig_1_freq = ke(row).freq;

           % apply cross correlation
           [c_21, lag_21] = xcorr(sig_2{sig_1_freq+1},sig_1);
           [max_val,max_idx] = max(c_21);
           idx_shift(row) = lag_21(max_idx);       
end



%% plot the aligned signals
figure(1)
clf
lim_y = [ 0 1 ; ...
          0 1 ; ...
          0 1 ; ...
          0 2 ; ...
          0 3 ; ...
          0 5 ; ...
          0 5 ;]
      
for freq = 1:7
   sp{freq} = subplot(7,1,freq);
   hold on; box on; set(gca,'fontsize',15)
   xlabel('x (mm)')
   if(freq~=7)
       xticklabels('');
       xlabel('');
   else
       xlabel(' KE (mJ)')       
   end
   
   subplot(sp{freq})
   row = freq;
   x_val = 0:(length(ke(row).fluc_filt)-1);
   plot(x_val,ke(row).fluc_filt, 'color',[0 0 0 0.1])           
   
end


for row = 8:350
   subplot(sp{ke(row).freq +1})
   x_val = 0:(length(ke(row).fluc_filt)-1);
   plot(x_val+idx_shift(row),ke(row).fluc_filt, 'color',[0 0 0 0.1])
   ylim(lim_y(ke(row).freq+1,:))
   
end


