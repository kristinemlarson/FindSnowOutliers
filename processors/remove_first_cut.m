function remove_first_cut(site_ind,snr_ind)
%REMOVE_FIRST_CUT - Removes standard deviation based outliers from SNR data
% Outliers are determined for each section of data that occur between 
% different equipment changes.
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
%       .remove_cut1    logical Perform this segment or not
%       .cut1_sigma     number of standard deviations away from the mean
%       .cut1_outliers  [2x1] logical [low;high] remove low/high outliers
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind}
%       .data           [Nx4] [year doy year.dec snr] updated snr data set 
%       .all_bad        [Mx4] [year doy year.dec snr] update set of all bad
%                       data points so far
%       .first_cut      [Nx4] [year doy year.dec snr] updated snr data set
%       .bad_first_cut  [Rx4] [year doy year.dec snr] days marked as
%                               outliers in this segment
%       .first_cut_params   [Sx3] [start_date end_date sigma]
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: SNR_OUTLIERS_MAIN MARK_SIGMA_OUTLIERS
% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% March 20, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Predeclare
good_data=zeros(0,4);
bad_data=zeros(0,4);
parameters=zeros(0,3);

%% Get SNR Data
data=sites_list(site_ind).snr{snr_ind}.data;

%% Check Segment Toggle
if(constants.remove_cut1)
    %% Check SNR Data Size
    [nr,~]=size(data);
    if(nr>0)
        %% Discretize Station Equipment Changes
        equipment_changes=sites_list(site_ind).equipment_changes;
        % Remove values that occur outside the data range
        if(~isempty(equipment_changes))
            inds=equipment_changes(:,3)<data(1,3)|equipment_changes(:,3)>data(end,3);
            equipment_changes=equipment_changes(~inds,:);
        end
        [nr,~]=size(equipment_changes);                         % Update size for loop
        
        %% Remove First Cut Outliers
        if(nr>0)
            %% Process Each Segment
            for change=0:nr
                %% Find Data Set Endpoints
                if(change==0)       % first segment
                    % Endpoints
                    tmin=data(1,3);
                    tmax=equipment_changes(change+1,3);
                elseif(change==nr)  % last segment
                    tmin=equipment_changes(change,3);
                    tmax=data(end,3)+0.00001;                       % Last point plus a small positive offset so that it is included in <tmax
                else
                    tmin=equipment_changes(change,3);
                    tmax=equipment_changes(change+1,3);
                end
                
                %% Trim data set
                inds=(data(:,3)>=tmin & data(:,3)<tmax);
                segment_data=data(inds,:);
                
                %% Process Segment
                if(~isempty(segment_data))                          % Data Exist in segment
                    [inds,segment]=mark_sigma_outliers(segment_data,constants.cut1_sigma,constants.cut1_outliers);
                    good_data=[good_data;segment_data(~inds,:)];
                    bad_data=[bad_data;segment_data(inds,:)];
                    parameters=[parameters;segment];
                end
            end
        else    % No Equipment Changes
            %% Process Whole Timeseries
            [inds,parameters]=mark_sigma_outliers(data,constants.cut1_sigma,constants.cut1_outliers);
            good_data=data(~inds,:);
            bad_data=data(inds,:);
            
        end
        
        
        %% Display Total Results
        [nr,~]=size(bad_data);
        format_print(sprintf('       Removed %4d Bad Points\n',nr),1000);      % Display All (1000)
    else        % No Data Points
        good_data=data;
        format_print('       No Data Points\n',1000);                           % Display All (1000)
    end
else            % Toggle is Off
    good_data=data;
    format_print('       Segment Toggle is Off\n',1000);                           % Display All (1000)
end
%% Add Back to sites_list
sites_list(site_ind).snr{snr_ind}.data=good_data;
sites_list(site_ind).snr{snr_ind}.all_bad=sort_by_ydec([sites_list(site_ind).snr{snr_ind}.all_bad;bad_data]);
sites_list(site_ind).snr{snr_ind}.first_cut=good_data;
sites_list(site_ind).snr{snr_ind}.bad_first_cut=bad_data;
sites_list(site_ind).snr{snr_ind}.first_cut_params=parameters;
