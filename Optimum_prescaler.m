%%
clear all
clc
%%
tic

f_min = 20;
f_max = 20e+3;
f_delta = 1; %1Hz frequency step between f_min and f_max
f_clock = 16e+6;
counter_ov_thresh = 2^(8); %8 bit register
%counter_ov_thresh = 2^(16); %16 bit register
% prescaler_set = [1 2 4 8 16 32 64 128 256 512 1024];    
prescaler_set = [1 8 64 256 1024];    % atmega328p, 1,8,64,256,1024

f_vect = (f_min:f_delta:f_max)';
result = zeros(length(f_vect),4);
uC_table = zeros(length(prescaler_set)*counter_ov_thresh,3);

%calculate and save the frequency output that corresponds to current
%prescaler/counter ovf    
index = 1;
for ii = 1:length(prescaler_set) %11
    for jj = 1:counter_ov_thresh %256

        fout =  f_clock ./( jj .* prescaler_set(ii) );
        uC_table(index,1) = fout;               %save corresponding freq
        uC_table(index,2) = prescaler_set(ii);  %save prescaler
        uC_table(index,3) = jj;                 %save ovf counter
        index = index + 1;
    end
end

for kk = 1:length(f_vect)
    %search for the minimum error of a specific input freq given the table
    %of all synthesizable frequencies
    [diff_value,position] = min( abs( f_vect(kk) - uC_table(:,1) ) );
    result(kk,1) = f_vect(kk);
    result(kk,2) = f_vect(kk) - uC_table(position,1);
    result(kk,3) = uC_table(position,2);
    result(kk,4) = uC_table(position,3);
end
toc
%%
figure;
plot(result(:,1),abs(result(:,2)));
legend('output frequency error');
figure;
plot( result(:,1),result(:,3));
legend('optimum prescaler');
figure;
plot(result(:,1),result(:,4));
legend('optimum counter ovf value');