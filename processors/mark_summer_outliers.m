function [indices,parameters,summer]=mark_summer_outliers(data,year,min)
%MARK_SUMMER_OUTLIERS - Marks outliers for a given year by determining a
% summer minimum.
% This code calculates summer for a given year and operates under the
% assumption that the snr is at the lowest point for a given year during
% the hot part of the summer.  This code takes a minimum value from the
% summer and then marks all points throughout the year that are lower than
% the summer minimum
%
% Syntax:   [indices,parameters,summer_snr]=mark_summer_outliers(data,year)
%           [indices,parameters,summer_snr]=mark_summer_outliers(data,year,min)
%
% Inputs:
%   data                [Nx4] [year doy year.dec snr] data to remove
%                       outliers from
%   year                year to find the summer of Ex: 2012
%   min(optional)       minimum if there are not enough summer points (default 0)
%                       Can use previous summer min.  A 0 will not process
%                       a summer that does not have enough points
%
% Global Parameters:
%   constants
%       .summer_range   [start_doy end_doy] DOY range for summer
%       .summer_min_pts     Minimum number of points required for a single
%                           summer
%       .summer_min_index   Index in sorted list to use as "minimum"
%                           1 is absolute minimum.  2 allows for 1 outlier
%
%
% Outputs:
%   indices             [Nx1] index logicals of the original data set that
%                       correspond to the outlier data
%   parameters          [1X4]   [start_date end_date min_snr sigma]
%   summer              [Mx4]   [year doy year.dec snr] summer data points
%
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Author: Kyle Wolma
%   University of Colorado at Boulder
% April 10, 2013; Last revision: August 06, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: remove_second_cut.m (1.1)

%% Load Globals
global constants

%% Predeclare
if(nargin>0)
  indices=false(length(data),1);                          % Array of false values equal to the length of input data
  parameters=[data(1),data(end),NaN,NaN];
else
  indices=[];
  parameters=[];
end
summer=zeros(0,4);

%% Handle Inputs
if(nargin<2||length(data)<1||~isnumeric(year))
  format_print('  Not Enough Inputs for Outlier Removal\n\n',0);          % Display Errors (0)
  format_print('Removing no Data Points\n\n',0);                          % Display Errors (0)
  return
end
snr_ydec=data(:,3);
if(nargin<3||~isnumeric(min))
    min=0;
end

%% Find Summer Start/End Points for the Year
summer_start=ydoy2ydec([year,constants.summer_range(1,1)]); % year.dec
summer_end=ydoy2ydec([year,constants.summer_range(2,1)]);   % year.dec
parameters(1,1:2)=[summer_start,summer_end];                % update parameters variable

%% Find Data Points
summer_inds=snr_ydec>=summer_start & snr_ydec<=summer_end;  % logical indices for the summer data
summer_snr=sort(data(summer_inds,4));                       % sorted snr data
year_inds=snr_ydec>=year & snr_ydec<(year+1);               % logical indices for the entire year of data
year_snr=data(year_inds,4);                                 % Entire year snr data

%% Process if There are Enough Points
if(length(summer_snr)>constants.summer_min_pts)
  %% Find Minimum Summer SNR Point
  min_snr=summer_snr(constants.summer_min_index);         % minimum value to use for this summer
  sigma=std(summer_snr);                                  % Standard deviation of the summer snr data
  parameters(1,3:4)=[min_snr,sigma];                      % update parameters variable
    
  %% Find Data Outliers for the Year
  year_outliers=year_snr<min_snr;                         % Snr data that are less than the minimum
  ind_nums=find(year_inds);                               % Numbered indices corresponding to rows in the full length indices vector
  indices(ind_nums)=year_outliers;                        % Add indices of yearly outliers to their locations in the full indices vector
    
  %% Display Results
  temp=ones(length(indices),1);
  num_pts=sum(temp(indices));
  format_print(sprintf('       Summer %4d: Using%3d of %3d Pts:',year,length(summer_snr),length(year_outliers)),1000);    % Display All (1000)
  format_print(sprintf(' Removed %3d Points sigma=%4.2f min=%4.2f\n',num_pts,sigma,min_snr),1000);    % Display All (1000)
    
  summer=data(summer_inds,:);                             % Output SNR Data
else
  if(min~=0)
    %% Set Minimum Summer Point as Input
    min_snr=min;
    sigma=-99;                         % Does not exist
    parameters(1,3:4)=[min_snr,sigma]; % update parameters variable
    %% Find Data Outliers for the Year
    year_outliers=year_snr<min_snr;   % Snr data that are less than the minimum
    ind_nums=find(year_inds);         % Numbered indices corresponding to rows in the full length indices vector
    indices(ind_nums)=year_outliers;  % Add indices of yearly outliers to their locations in the full indices vector
    %% Display Results
    temp=ones(length(indices),1);
    num_pts=sum(temp(indices));
    format_print(sprintf('       Summer %4d: Using Input Minimum\n',year),1000);                  % Display All (1000)
    format_print(sprintf('       Summer %4d: Using%3d of %3d Pts:',year,length(summer_snr),length(year_outliers)),1000);    % Display All (1000)
    format_print(sprintf(' Removed %3d Points sigma=%4.2f min=%4.2f\n',num_pts,sigma,min_snr),1000);    % Display All (1000)    
  else
    %% Display Results
    format_print(sprintf('       Summer %4d:',year),1000);                  % Display All (1000)
    format_print('Not Enough Points\n',1000);                               % Display All (1000)
  end 
end


