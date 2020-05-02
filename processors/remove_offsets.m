function remove_offsets(site_ind,snr_ind)
%REMOVE_OFFSETS - Removes offsets from the snr data from a given site.
% A local average is taken before and after the offset to determine the
% change required
%
% Syntax:  remove_offsets(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%
% Global Parameters:
%   constants
%       .remove_offsets logical Perform this segment or not
%       .offset_range   [year.dec] number of days before/after the offset
%                       to use for a mean.  Converted to years
%       .offset_min_pts minimum number of data points within the range
%                       needed to calculate the mean
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind)
%       .data           [Nx4] [year doy year.dec snr] updated snr data set
%                       Set to equal no_offsets.
%       .no_offsets     [Nx4] [year doy year.dec snr] snr data that has all
%                       the firmware and other undocumented offsets removed.
%       .deltas         [Mx2] [year.dec delta]  A listing of the delta
%                       values for all the firmware changes corresponding
%                       to this snr data set only
%
%
% See also: SNR_OUTLIERS_MAIN MAIN_PROCESSOR
% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% March 20, 2013; Last revision: October 07, 2013
% Current Version: 2.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Predeclare Offset Variables
offsets=zeros(0,3);
delta=[];                                                   % Offset changes

%% Get SNR Data
snr_data=sites_list(site_ind).snr{snr_ind}.data;            % Incoming SNR Data

%% Check Segment Toggle
if(constants.remove_offsets)
    %% Check Size of SNR
    [nr,~]=size(snr_data);
    if(nr>0)
        %% Get Year.dec Data
        snr_ydec=snr_data(:,3);                                 % Incoming year.dec values
        
        %% Get Firmware and other Changes
        offsets=sites_list(site_ind).offset_dates;              % [year doy ydec] changes of firmware or other offsets
        % Remove changes outside data range
        if(~isempty(offsets))
            inds=offsets(:,3)<snr_data(1,3)|offsets(:,3)>snr_data(end,3);
            offsets=offsets(~inds,:);
        end
        
        %% Check size of list
        [nr,~]=size(offsets);                              % Check size of array
        if(nr>0)
            %% Process each offset
            for change=1:nr                                         % Process each change row
                ydec=offsets(change,3);                    % Date of current change
                
                %% Get snr data before and after the offset
                inds_before= snr_ydec<ydec & snr_ydec>=(ydec-constants.offset_range);        % dates that are smaller than the change and larger than the offset date
                inds_after=  snr_ydec>=ydec & snr_ydec<=(ydec+constants.offset_range);       % dates that are larger than the change and smaller than the offset date
                before=snr_data(inds_before,4);                                          % Data points that are just before the change
                after=snr_data(inds_after,4);                                            % Data points that are just after the change
                
                %% Check to ensure there are enough data points to average
                if(length(before)>constants.offset_min_pts&&...
                        length(after)>constants.offset_min_pts)
                    delta(change,1)=mean(after)-mean(before);       % calculated offset
                    %% Perform offset removal
                    inds = snr_ydec>=ydec;                                  % all points after firmware change
                    snr_data(inds,4)=snr_data(inds,4)-delta(change,1);      % Remove the offset
                    
                else
                    delta(change,1)=0;                              % offset not applied
                end
                
                %% Display Results
                format_print(sprintf('       Removed Offset of %4.2f on %7.3f\n',delta(change,1),ydec),1000); % Display All (1000)
            end
        end
        
    else        % No Data Points
        format_print('       No Data Points\n',1000);                           % Display All (1000)
    end
else        % Toggle is off
    format_print('       Segment Toggle is Off\n',1000);                           % Display All (1000)
end

%% Update sites_list
sites_list(site_ind).snr{snr_ind}.data=snr_data;                    % Add to sites_list
sites_list(site_ind).snr{snr_ind}.no_offsets=snr_data;              % Add to sites_list
sites_list(site_ind).snr{snr_ind}.offset_deltas=[offsets(:,3),delta];  % Store the delta values corresponding to each change