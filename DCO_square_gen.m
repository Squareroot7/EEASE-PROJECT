%INSERIRE DESCRIZIONE CODICE

clear;clc;
%///CONSTANTS

%Square generation
%Fs = 44100;
Fs=100e+6;
Ts = (1/Fs);
duty = 50;

f_set       = [20   100     1e+3    2e+3    4e+3]';
period_rep  = [5    5       5      5      5 ]';

%PWM generation -- 20Hz 4kHz function mapping 0%- 100% 20Hz- 4kHz linear
fmin=20; % 0 percent duty
fmax=4000; % 100 percent duty
Delta_F=fmax-fmin;

F_PWM= 20e+3; %fpwm is 20kHz fix


%////VARIABLES
period_set = period_rep ./ f_set;
samples_set = period_set ./ Ts;

tot_period = sum(period_set, 'all')
tot_samples = round(tot_period ./ Ts);
sq_seq = zeros(2.*tot_samples,1);
PWM_seq = zeros(2.*tot_samples,1);
%////CODE
index = 1;

for ii = 1:length(f_set)
   t = (0:Ts:period_set(ii))';
   %PWM
   duty_PWM(ii)=(100./Delta_F).*(f_set(ii)-fmin);
   PWM = square(2*pi*F_PWM.*t, duty_PWM(ii));
   PWM_seq(index:(index+length(t)-1),1)= PWM;
   
   %Square
   sq = square(2*pi*f_set(ii).*t, duty); 
   sq_seq(index:(index+length(t)-1),1)= sq;
   
   %index update
   index = index + length(t)+1;
end
sq_seq = nonzeros( sq_seq(:,1) );
PWM_seq = nonzeros( PWM_seq(:,1) );

filename = 'square1mil.wav';
audiowrite(filename,sq_seq,Fs);

filename = 'PWM1mil.wav';
audiowrite(filename,PWM_seq,Fs);


