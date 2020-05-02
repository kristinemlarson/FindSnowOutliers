function remove_bad_days(site_ind,snr_ind)
%REMOVE_BAD_DAYS - Removes bad days from a given site based on global and
% local lists
%
% Syntax:  remove_bad_days(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%
% Global Parameters:
%   constants
%       .remove_bad         logical     Perform this segment or not
%       .global_bad_days    [year doy] global bad days
%       .local_bad_sids     {}          List of sites with local bad days
%       .local_bad_days     {[year doy]}Corresponding list of loca bad days
%
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind}
%       .data           [Nx4] [year doy year.dec snr] updated snr data set                       
%       .cleaned        [Nx4] [year doy year.dec snr] snr data that has all
%                       the bad data points removed
%       .all_bad        [Mx4] [year doy year.dec snr] update set of all bad
%                       data points so far
%       .bad_days       [Mx4] [year doy year.dec snr] snr data points that
%                       were removed from the cleaned data are included for
%                       easy access
%
%
% See also: SNR_OUTLIERS_MAIN LOAD_BAD_DAYS_LIST
%
% Author: Kyle Wolma
%   University of Colorado at Boulder
% April 04, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Get SNR Data
snr_data=sites_list(site_ind).snr{snr_ind}.data;                % Incoming SNR data

%% Check Segment Toggle
if(constants.remove_bad)
    %% Check Size of SNR Data
    [nr,~]=size(snr_data);
    if(nr>0)
        %% Find Local Bad Days
        sid=sites_list(site_ind).sid;
        % Find the site id in the list of bad days
        if(constants.case_sensitive)
            inds = strcmp(constants.local_bad_sids, sid);           % Find indices of all rows that match the sid
        else
            inds = strcmpi(constants.local_bad_sids, sid);          % Find indices of all rows that match the sid
        end
        % Use the indices to get the day values
        if(max(inds))
            bad_local=constants.local_bad_days{inds};                   % Local bad days
        else
            bad_local=zeros(0,3);
        end
        
        %% Remove Local Bad Days
        num_local=0;
        for day=1:length(bad_local)
            % current day to remove
            ydec=bad_local(day,3);
            % Find indices of all good points
            inds=snr_data(:,3)~=ydec;                               % Check year.dec value of snr_data
            if(~min(inds))                                          % min(inds)=1 if the bad_data point is not in the data
                % Remove bad data point from set
                bad_local(day,4)=snr_data(~inds,4);                 % Add the bad snr point to the bad days list
                snr_data=snr_data(inds,:);
                num_local=num_local+1;                              % store number of local days removed
            else
                % Mark bad day as a NaN for later removal
                bad_local(day,4)=NaN;
            end
            
        end
        
        
        %% Find Global Bad Days
        bad_global=constants.global_bad_days;                       % Global list of bad days
        
        %% Remove Global Bad Days
        num_global=0;
        for day=1:length(bad_global)
            % current day to remove
            ydec=bad_global(day,3);
            % Find indices of all good points
            inds=snr_data(:,3)~=ydec;                               % Check year.dec value of snr_data
            if(~min(inds))                                          % min(inds)=1 if the bad_data point is not in the data
                % Remove bad data point from set
                bad_global(day,4)=snr_data(~inds,4);                % Add the bad snr point to the bad days list
                snr_data=snr_data(inds,:);
                num_global=num_global+1;                            % store number of local days removed
            else
                % Mark bad day as a NaN for later removal
                bad_global(day,4)=NaN;
            end
            
        end
        
        
               %% Combine Arrays
        if(length(bad_local)<1)
            bad_local=ones(0,4);                                    % Predeclare [0x4] empty matrix if there are no bad local days
        end
        if(length(bad_global)<1)
            bad_global=ones(0,4);                                   % Predeclare [0x4] empty matrix if there are no bad global days
        end
        bad_days=[bad_local;bad_global];   % concatenate bad local and global days
        
        %% Remove NaNs
        inds=isnan(bad_days(:,4));
        bad_days=bad_days(~inds,:);
        
        
        %% Display Results
        format_print(sprintf('       Removed %3d local %d global\n',num_local,num_global),1000);    % Display All (1000)
                
        
    else        % No Data Points
        format_print('       No Data Points\n',1000);                       % Display All (1000)
        bad_days=zeros(0,4);
    end
    
else        % Toggle is off
    format_print('       Segment Toggle is Off\n',1000);                    % Display All (1000)
    bad_days=zeros(0,4);                                     % Dummy Variable
end

%% Add to sites_list
sites_list(site_ind).snr{snr_ind}.data=snr_data;
sites_list(site_ind).snr{snr_ind}.all_bad=sort_by_ydec([sites_list(site_ind).snr{snr_ind}.all_bad;bad_days]);
sites_list(site_ind).snr{snr_ind}.cleaned=snr_data;
sites_list(site_ind).snr{snr_ind}.bad_days=bad_days;
