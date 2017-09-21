classdef dr_compressor < handle % Makes sure there's only "one type of instance"
    
    properties
        track = 0; % object containing soundtrack
        
        avg_difference = 0;
    end
    
    methods
        % Constructor
        function obj = dr_compressor(soundtrack)
            obj.track = soundtrack; % Initializes instrument
        end        
        
        function [obj,differences_vect] = maxmin_window(obj,track,n_samples)
            differences_vect = zeros(length(track),1);
            
            % initialize
            max_window = max(track(1:n_samples));
            min_window = min(track(1:n_samples));
            differences_vect(n_samples) = max_window-min_window;
            for i=n_samples+1:length(track)
                % Compute max and mins
                current_sample = track(i);
                if current_sample > max_window
                    max_window = current_sample;
                end
                if current_sample < min_window
                    min_window = current_sample;
                end
                
                diff = max_window-min_window; % Return max-min
                differences_vect(i) = diff;
            end
            obj.avg_difference = mean(differences_vect(n_samples:end)); % Get the average of all those differences
        end
    end
    
end