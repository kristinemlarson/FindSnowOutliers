function modify_path(cin)
%SETUP_PATH - Adds/Removes directories to/from the path
%   Modify this wrapper to allow additional directories to be added to the
%   path
%
% Syntax:   modify_path()
%           modify_path('s')
%           modify_path('c')
%
% Input:
%   's'     setup[default]
%   'c'     cleanup
%
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% February 20, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Handle Inputs
if((nargin <1)||~ischar(cin))
    cin='s';  % Default for no input
end
% Set logical
if(upper(cin)=='S')
    setup=true;
else
    setup=false;
end

%% Add/Rm Outliers local Subdirectories
outliers_dir='/gipsy/matlab/snr_outliers';      % Location of the main outliers folder
if(setup)
    addpath(genpath(outliers_dir));             % Add snr_outliers/*
else
    rmpath(genpath(outliers_dir));              % Remove snr_outliers/*
end

%% Add/Rm System Directories

system_dir='/gipsy/matlab';             % Location of local helper functions used in load_sites_list
if(setup)
    addpath(system_dir);                % Add system_dir
else
    rmpath(system_dir);                 % Remove system_dir
end
