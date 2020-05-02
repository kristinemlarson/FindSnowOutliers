function [ly] = leapyear(year)
%LEAPYEAR - Determines whether the input year is a leapyear or not
% If the MATLAB aerospace toolbox is installed, this function should be
% removed in favor of using the toolbox version of this function
%
% Syntax:   le=leapyear(year)
%
% Inputs:
%   year            The year to check %
%
% Outputs:
%   ly              Logical array matching the size of the year array
%                   Values are determined by yrs divisible by 4, not
%                   divisible by 100, or divisible by 400
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% August 27, 2013; Last revision: August 27, 2013
% Current Version: 1.2
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A


%% Check Input for proper format
if(~isnumeric(year))
    ly=false;
    return;
end

%% Start with Mod 4:      Accept true
ly=(mod(year,4)==0);

%% Check Against Mod 100: Remove true
ly=ly&(~(mod(year,100)==0));

%% Check Against Mod 400: Add true
ly=ly| (mod(year,400)==0);
