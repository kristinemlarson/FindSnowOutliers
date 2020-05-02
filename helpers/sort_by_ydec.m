function [sorted]=sort_by_ydec(data)
%SORT_BY_YDEC Sorts an input set of snr data by the year.dec values in the 
% 3rd column of the input data
%
% Syntax:  [sorted]=sort_by_ydec(data)
%
% Inputs:
%   data            [Nx(3+n)] [year doy year.dec snr(optional)] unsorted
%                               data
%
% Outputs:
%   sorted          [Nx(3+n)] [year doy year.dec snr(optional)] Data sorted
%                               by increasing year.dec value
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 12, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Handle Inputs
if(nargin<1)
    sorted=[];
    return
end

%% Sort Data
[~,inds]=sort(data,1);                          % Sort data by column
if(~isempty(inds))
    sorted=data(inds(:,3),:);                       % inds(:,3) are sorted indices corresponding to the sorting of year.dec
else
    sorted=data;
end