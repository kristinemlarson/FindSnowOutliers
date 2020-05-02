function data=load_without_crash(filename)
%LOAD_WITHOUT_CRASH - Loads data from the input file using MATLAB built in
% load function with the ability to handle a file load error
%
% Syntax:  data=load_without_crash(filename)
%
% Inputs:
%   filename        a string containing the filename of the file to load
%
% Outputs:
%   data            data loaded using MATLAB built in load function
%
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 04, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Initialize Output
data=[];

%% Handle Inputs
if(nargin<1)
    format_print('      No Input file to Load\n\n',0);                      % Display Errors (0)
    return
end

%% Check for file existence and load it
% 14apr07 KL changed this to use the correct function
[data] = load_file_nocrash(filename);
end


