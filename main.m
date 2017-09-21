% Create track object 
fprintf('Reading song...\n');
song1 = instrument('D:\AMM\RAW STEMS-20170819T202100Z-001\RAW STEMS\seven nation army 2_11_BASS_SUB.wav');

% Start compressor
fprintf('Starting compressor...\n');
drcomp = dr_compressor(song1);

% Get the average difference between the max/min samples accross the windows of n samples
n = 4096; % window
[~,differences_vect] = drcomp.maxmin_window(drcomp.track.channelL,n); % Left channel

fprintf('Average value (not ignoring complete silence samples -- 0s): %.7f\n',drcomp.avg_difference);

% % Start equalizer, and get FFT
% fprintf('Calculating FFT...\n');
% song1.equalizer.get_fft();
% 
% % Frequency range
% minHz = 100;
% maxHz = 300;
% fprintf('Getting indices for frequencies %d Hz - %d Hz...\n',minHz,maxHz);
% % Get the indices corresponding to the frequencies above
% [indices] = song1.equalizer.get_freq_indices(song1.equalizer.fqdL,minHz,maxHz);
% % Alter FFT
% fprintf('Equalizing...\n');
% n = 0.25; % Attenuate or Amplify by this factor 
% new_value = song1.equalizer.alter_fft(n,1,indices);
% 
% fprintf('Calculating Inverse FFT...\n');
% % Get original signal by applying an ifft
% [new_signal] = song1.equalizer.inverse_fft(1);
% 
% plot(song1.equalizer.fqdL,abs(song1.equalizer.FFTyL));
% hold on;
% plot(song1.equalizer.fqdL,abs(song1.equalizer.eq_FFTyL));
% 
% t = 1:length(song1.channelL);
% figure;
% plot(t,song1.channelL);
% hold on;
% plot(t,new_signal)
% 
% % Wrtie file
% filename = 'equalizedraw.wav';
% audiowrite(filename,new_signal,song1.Fs);

%  isequal(song1.equalizer.FFTyL,song1.equalizer.eq_FFTyL)
