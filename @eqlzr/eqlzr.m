classdef eqlzr < handle % Makes sure there's only "one type of instance"
    
    properties
        track = 0; % object containing soundtrack
        FFTyL = 0; % Left Channel
        fqdL = 0;  % frequency domain Left channel
        FFTyR = 0; % Right Channel
        fqdR = 0;  % frequency domain right channel
        
        % Equalized FFTs
        eq_FFTyR = 0; % Right channel
        eq_FFTyL = 0; % Left channel
    end
    
    methods
        % Constructor
        function obj = eqlzr(soundtrack)
            obj.track = soundtrack; % Initializes instrument
        end
        
        function [] = get_fft(obj)
            obj.FFTyL = fft(obj.track.channelL);
            obj.FFTyR = fft(obj.track.channelR);
            % Make a copy of FFTs (used when equalizing)
            obj.eq_FFTyR = obj.FFTyR;
            obj.eq_FFTyL = obj.FFTyL;
            
            NL = length(obj.track.channelL);         % Length of signal
            obj.fqdL = obj.track.Fs/NL .* (0:NL-1);  % Obtain frequency donmain vector
            
            NR = length(obj.track.channelL);         % Length of signal
            obj.fqdR = obj.track.Fs/NR .* (0:NR-1);  % Obtain frequency donmain vector
        end
        
        % Get the indices of the frequencies (freq domain)
        function [indices] = get_freq_indices(obj,f,minf,maxf)
            k = find(f >= minf & f <= maxf);
            indices = k;
        end
        
        % Alter FFT's values (attenuate or amplify)
        function [new_value] = alter_fft(obj,n,LR,indices) % attenuate or amplify by a factor of n, LR --> 1 = left channel, 2= right channel, i = index
            % Choose channel
            if LR == 1
                FFTx = obj.FFTyL; % Left
            end
            if LR == 2
                FFTx = obj.FFTyR; % Right
            end
 
            % phase_angle = phase(FFTx(indices)); % phase(a + bj); ---> acos(a/R)
            phase_angle = zeros(length(indices),1);
            an = zeros(length(indices),1);
            bn = zeros(length(indices),1);
            Z = zeros(length(indices),1);

            % Magnitude
            R = abs(FFTx(indices)); % magnitude ---> sqrt(a^2 + (bj)^2)
            % Desired new magnitude
            Rn = R .* n;

            % Get real and imaginary parts ... 
            a = real(FFTx(indices));
            b = imag(FFTx(indices));
            
            for k=1:length(indices)                
                % Quadrants
                if a(k) >= 0 && b(k) >= 0
                    % first quadrant
                    phase_angle(k) = atan(b(k)/a(k));
                end
                if a(k) < 0 && b(k) >= 0
                    % second quadrant
                    phase_angle(k) = pi + atan(b(k)/a(k));
                end
                if a(k) < 0 && b(k) < 0
                    % third quadrant
                    phase_angle(k) = atan(b(k)/a(k)) + pi;
                end
                if a(k) >= 0 && b(k) < 0
                    % fourth quadrant
                    phase_angle(k) = 2*pi + atan(b(k)/a(k));
                end 
                
                % New values
                an(k) = Rn(k)*cos(phase_angle(k));
                bn(k) = Rn(k)*sin(phase_angle(k));

                Z(k) = an(k) + bn(k)*i;
                
                % Replace FFT with new FFT!
                if LR == 1
                    obj.eq_FFTyL(indices(k)) = Z(k); % Left
                end
                if LR == 2
                    obj.eq_FFTyR(indices(k)) = Z(k); % Right
                end
                
            end
            new_value = Z;

%             length(FFTx(indices))
%             Z
           
        end
        
        function [original_signal] = inverse_fft(obj,LR)
            % Replace FFT with new FFT!
            if LR == 1
                original_signal = ifft(obj.eq_FFTyL); % Left
            end
            if LR == 2
                original_signal = ifft(obj.eq_FFTyR); % Right
            end
            
        end
        
        % Obtain closer whole number that's multiple of X e.g 6's
        function [NUM] = get_closer_x(obj,a,X)
            d = mod(a,X); % "distance" from a zero, that is how far away is the closer number that's multiple of X 
            mid_d = X/2; % Mid point distance (in terms of modulo)
            
            % Remainder found!
            if d ~= 0
                if d > mid_d
                    NUM = a + (X-d);
                end
                if d < mid_d
                    NUM = a - d;
                end
                if d == mid_d
                    NUM = a - d;
                end
            else
                NUM = a;
            end
        end
        
        
        
    end
end