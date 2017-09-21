classdef instrument < handle % Makes sure there's only "one type of instance"
    
    properties
        Fs = 0; % Sampling Frequency
        FileInfo = 0; % File info
        channelL = 0; % Left channel
        channelR = 0; % Right channel
        
        equalizer = 0;
    end
    
    methods
        % Constructor
        function obj = instrument(file_read)
            [y,obj.Fs] = audioread(file_read);
            if size(y,2) == 2
                obj.channelL = y(:,1); % Left channel
                obj.channelR = y(:,2); % Right channel
            else
                obj.channelL = y(:,1); % One channel only
            end
            obj.FileInfo = audioinfo(file_read); % Obtain the info of wav file
            
            obj.equalizer = eqlzr(obj);
        end
    end
end