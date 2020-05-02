function remove_second_cut(site_ind,snr_ind)
%REMOVE_SECOND_CUT - Removes outliers from SNR data as determined by using
% a summer minimum.
% The minimum SNR value for the summer is taken and any data points
% throughout the year that are lower are marked as bad.
%
% Syntax:  remove_first_cut(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%
% Global Parameters:
%   constants
%       .remove_cut2    logical Perform this segment or not
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind}
%       .data           [Nx4] [year doy year.dec snr] updated snr data set
%       .all_bad        [Mx4] [year doy year.dec snr] update set of all bad
%                       data points so far
%       .second_cut     [Nx4] [year doy year.dec snr] updated snr data set
%       .bad_second_cut [Rx4] [year doy year.dec snr] days marked as
%                               outliers in this segment
%       .second_cut_params   [Sx4] [start_date end_date min_snr sigma]
%       .summer_pts     [Tx4] [year doy year.dec snr] snr points used for
%                               summer each year
%
% See also: SNR_OUTLIERS_MAIN MARK_SUMMER_OUTLIERS
% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% March 20, 2013; Last revision: August 06, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.1
% Precedent Versions: mark_summer_outliers.m (1.1)
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Predeclare
good_data=zeros(0,4);
bad_data=zeros(0,4);
summer_pts=zeros(0,4);
parameters=[];

%% Get SNR Data
good_data=sites_list(site_ind).snr{snr_ind}.data;


%% Check Segment Toggle
if(constants.remove_cut2)
  %% Check SNR Data Size
  [nr,~]=size(good_data);
  if(nr>0)
    %% Process Each Summer
    for year=constants.snr_yrs
      if(year==constants.snr_yr_min)
         [indices,params,summer]=mark_summer_outliers(good_data,year);
      else % Not first year
         [indices,params,summer]=mark_summer_outliers(good_data,year,parameters(end,3));
      end
      bad_data=[bad_data;good_data(indices,:)];        % Add outliers to bad data list
      good_data=good_data(~indices,:);            % Keep only the points not marked as outliers
      clear indices;
      summer_pts=[summer_pts;summer];
      parameters=[parameters;params];
    end
        
    %% Display Total Results
    [nr_b,~]=size(bad_data);
    format_print(sprintf('       Removed %4d Bad Points\n',nr_b),1000); % Display All (1000)
  else        % No Data Points
    format_print('       No Data Points\n',1000);                           % Display All (1000)
  end
else            % Toggle is Off
  format_print('       Segment Toggle is Off\n',1000);                           % Display All (1000)
end
%% Add Back to sites_list
sites_list(site_ind).snr{snr_ind}.data=good_data;
sites_list(site_ind).snr{snr_ind}.all_bad=sort_by_ydec([sites_list(site_ind).snr{snr_ind}.all_bad;bad_data]);
sites_list(site_ind).snr{snr_ind}.second_cut=good_data;
sites_list(site_ind).snr{snr_ind}.bad_second_cut=bad_data;
sites_list(site_ind).snr{snr_ind}.second_cut_params=parameters;
sites_list(site_ind).snr{snr_ind}.summer_pts=summer_pts;
