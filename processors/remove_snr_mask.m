function remove_snr_mask(site_ind,snr_ind)
%REMOVE_SNR_MASK - Removes SNR data points that are outside the mask
% tolerance for minimum and maximum SNR values.
%
% Syntax:  remove_snr_mask(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%
% Global Parameters:
%   constants
%       .remove_mask    logical Perform this segment or not
%       .bad_snr_max    maximum snr value allowed
%       .bad_snr_min    minimum snr value allowed
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind)
%       .data           [Nx4] [year doy year.dec snr] updated snr data set
%                       Set to equal no_bad.
%       .masked         [Nx4] [year doy year.dec snr] snr data that has all
%                       the bad data points removed
%       .all_bad        [Mx4] [year doy year.dec snr] snr data points that
%
%       .bad_snr_mask   [Mx4] [year doy year.dec snr] snr data points that
%                       were removed from the cleaned data are included for
%                       easy access
%
%
% See also: SNR_OUTLIERS_MAIN
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

%% Get Percentage
if(isfield(constants,'snr_mask_pct'))
    mask_pct=constants.snr_mask_pct/100;
else
    mask_pct=5/100;
end

%% Check Segment Toggle
if(constants.remove_mask)
    %% Check Size of SNR Data
    [nr,~]=size(snr_data);
    if(nr>0)
        %% Compare to Tolerances
        % Above High Tolerance
        inds=snr_data(:,4)>constants.bad_snr_max;                   % indices of data pts above tolerance
        bad_snr_high=snr_data(inds,:);                              % bad data
        snr_data=snr_data(~inds,:);                                 % remove bad data
        [num_high,~]=size(bad_snr_high);                            % number of bad data pts
        % Below Low Tolerance
        inds=snr_data(:,4)<constants.bad_snr_min;                   % indices of data pts below tolerance
        if(length(snr_data(inds,1))>nr*mask_pct)
            format_print(sprintf('       Minimum is too low. %d pts. below threshold\n',length(snr_data(inds,1))),1000);   % Display All (1000)
            inds=snr_data(:,4)==0;                                  % indices of zeros only            
        end
        bad_snr_low=snr_data(inds,:);                               % bad data
        snr_data=snr_data(~inds,:);                                 % remove bad data
        [num_low,~]=size(bad_snr_low);                              % number of bad data pts
        
        
        %% Combine Arrays
        if(length(bad_snr_high)<1)
            bad_snr_high=ones(0,4);                                 % Predeclare [0x4] empty matrix if there are no bad snr_high days
        end
        if(length(bad_snr_low)<1)
            bad_snr_low=ones(0,4);                                  % Predeclare [0x4] empty matrix if there are no bad snr_low days
        end
        bad_days=[bad_snr_high;bad_snr_low];                        % concatenate bad high and bad low days
        
        %% Remove NaNs
        inds=isnan(bad_days(:,4));
        bad_days=bad_days(~inds,:);
        
        
        %% Display Results
        format_print(sprintf('       Removed %3d high SNR %3d low SNR\n',num_high,num_low),1000);   % Display All (1000)
                
        
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
sites_list(site_ind).snr{snr_ind}.masked=snr_data;
sites_list(site_ind).snr{snr_ind}.bad_snr_mask=bad_days;
