function [ydec]=ydoy2ydec(ydoy)
%YDOY2YDEC - Converts inputs from [year doy] to [year.dec]
% Dates are converted based on the constants.equal_years parameter.  If
% this parameter is true then the year.dec=year+doy/365.25 otherwise,
% year.dec=year+doy/(#days)  where #days is 365 or 366 in a leap year
% 
% Syntax:  [ydec]=ydoy2ydec(ydoy)
%
% Inputs:
%   ydoy            [Nx2] [year doy] rows contain dates to convert
%
% Global Parameters:
%   constants
%       .equal_yrs  logical to not use leap years
%       .yr_length  length of an average year
%
% Outputs:
%   ydec            [Nx1] [year.dec] rows contain dates converted to
%                       year.dec
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% March 20, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A


%% Load Constants
global constants

%% Check Size of input
[nr,nc]=size(ydoy);
if(nr<1||nc<2)
    ydec=[];
    return
end


%% Convert to Year.dec based on constants parameter
if(constants.equal_yrs)                 % All years use 365.25
    ydec=ydoy(:,1)+ydoy(:,2)/constants.yr_length;
else    
    %% Find unique years
    all_years=unique(ydoy(:,1))';       % all years is a row vector 
    
    %% Process each year
    ydec=ydoy(:,1);
    for year=all_years
        inds=ydoy(:,1)==year;
        if(leapyear(year))
            ydec(inds,1)=ydoy(inds,1)+ydoy(inds,2)/366;
        else
            ydec(inds,1)=ydoy(inds,1)+ydoy(inds,2)/365;
        end
    end
end
