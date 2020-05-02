function [] = update_colors(snr_types)
%UPDATE_COLORS - Updates the list of colors in the format structure so that
%   they contain one column per snr type
%
% Syntax:   update_colors(snr_types)
%
% Inputs:
%   snr_types   number of snr data types to add columns for
%
% Outputs:
%
% Changes to Globals:
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_FORMAT
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 16, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global format

%% Find all the colors 
color_list=fieldnames(format.color);

%% Loop Through Each Entry
for ind=1:length(color_list)
    color_array=getfield(format.color,color_list{ind});
    [~,nc]=size(color_array);
    if(nc<snr_types)
        for col=2:snr_types
            color_array(:,col)=color_array(:,1);            % Copy the first column into all remaining columns            
        end
        format.color=setfield(format.color,color_list{ind},color_array);
    end
    
end
