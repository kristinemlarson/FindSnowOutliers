function load_snr_data(site_ind)
%LOAD_SNR_DATA - Loads SNR data for one site
%   Modify this wrapper to change how data are loaded for a given site
%
% Syntax:  load_snr_data(site_ind)
%
% Inputs:
%   site_ind            index of the site in the sites_list
%
% Outputs:
%
% Global Changes:
%   Added to sites_list(site_ind)
%   .snr{m}             a structure containing the raw snr data for m
%                       different data types
%           type        String of the name of the type of data Ex: 'L1'
%           process     Logical whether to process this snr data set or not
%           data        [Nx4] [year doy year.dec snr]
%                       corresponding to the most active, up to date snr
%                       data (In this case raw but after different snr cuts
%                       this will reflect the most recent changes)
%           all_bad     [0x4] [year doy year.dec snr] Placeholder for a
%                       list of all the bad data compiled for all processes
%           raw         [Nx4] [year doy year.dec snr]
%                       Daily average of the chosen raw snr data
%                       corresponding to each day of year value
%           missing     [Mx3] [year doy year.dec] corresponding to each day
%                       in the total range that does not have raw data
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% March 06, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Get SID
sid=sites_list(site_ind).sid;

%% LOAD L1 Data============================================================
%%=========================================================================
%% Add Data Type Information
l1.type='L1';
l1.process=false;                                           % Do not process this snr data product

%% Predeclare Data Arrays
% Predeclare l1 data arrays
l1.data=[];
l1.all_bad=[];
l1.raw=[];
l1.missing=[];

%% Get L1 data for All Years
for year=constants.snr_yrs                          % Each year in the snr range
    %% Create an Array of doy indices to compare to
    if(leapyear(year))
        ndays=366;
    else
        ndays=365;
    end
    days=(1:ndays)';                                        % doy indices in a column
    
    %% Load raw L1 Data
        if(constants.demo_mode)
        snr_file = ['demo/snr/' num2str(year) '/' sid '.s1'] ;             % l1 data location                                                          % Index in sites_list
    else
        snr_file = ['/data/snr/' num2str(year) '/' sid '.s1'] ;            % l1 data location
        end
    
    l1_raw_yr=load_without_crash(snr_file);                             % returns daily average snr data for the current year
    %l1_raw [nx4] [doy #pts sigma mean(l1)]
    
    % Add Data to the end of the l1 data column
    [nr,~]=size(l1_raw_yr);                                             % check size of data
    if nr > 0                                               % yearly data exist
        l1_raw=[year*ones(nr,1), l1_raw_yr(:,1)];                       % [year doy]
        l1_raw(:,3)=ydoy2ydec(l1_raw);                                  % [year doy year.dec]  convert to decimal using helper function
        l1_raw(:,4)=l1_raw_yr(:,4);                                     % [year doy year.dec snr]
        % Append to end of data columns
        l1.raw=[l1.raw; l1_raw];                                        % append to l1 raw data
    end
    
    %% Find dates missing L1 data
    if(nr>0)                                                    % data exist
        [diff_days,inds] = setdiff(days, l1_raw_yr(:,1),'rows');        % find missing days
        if(~isempty(inds))
            yrs= year*ones(length(inds),1);
            ydec=ydoy2ydec([yrs,diff_days]);                            % year.dec
            l1.missing = [l1.missing; yrs diff_days ydec];              % append [year doy year.dec] for each missing day
        end
    else                                                        % all data are missing for this year
        yrs= year*ones(length(days),1);
        ydec=ydoy2ydec([yrs,days]);                                     % year.dec
        l1.missing = [l1.missing; yrs days ydec];                       % append [year doy year.dec] for entire year
    end
    
end

%% Add Data to sites_list
l1.data=l1.raw;                                                 % Copy raw data to active snr data
sites_list(site_ind).snr{1}=l1;                                 % Add to sites_list


%% LOAD S2 Data============================================================
%%=========================================================================
%% Add Data type information
l2.type='L2';
l2.process=true;

%% Predeclare data arrays
% Predeclare l2 data arrays
l2.data=[];
l2.all_bad=[];
l2.raw=[];
l2.missing=[];


%% Get S2 data for all years
for year=constants.snr_yrs                          % Each year in the snr range
    %% Create an array of doy indices to compare to
    if(leapyear(year))
        ndays=366;
    else
        ndays=365;
    end
    days=(1:ndays)';                                        % doy indices in a column
    
    %% Load raw S2 Data
    if(constants.demo_mode)
        snr_file = ['demo/snr/' num2str(year) '/' sid '.s12'] ;             % l2 data location                                                          % Index in sites_list
    else
        snr_file = ['/data/snr/' num2str(year) '/' sid '.s12'] ;            % l2 data location
    end
    l2_raw_yr=load_without_crash(snr_file);                             % load file without crashing
    %l2_raw_yr [nx10] [doy #pts sigma mean_S2(55-60) #pts sigma mean_S2(35-40) #pts sigma mean_S2(20-25)]
    
    % Add Data to the end of the S2 data column
    [nr,~]=size(l2_raw_yr);                                             % check size of yearly data
    if nr > 0                                               % yearly data exist
        l2_raw=[year*ones(nr,1), l2_raw_yr(:,1)];                       % [year doy]
        l2_raw(:,3)=ydoy2ydec(l2_raw);                                  % [year doy year.dec]  convert to decimal using helper function
        l2_raw(:,4)=l2_raw_yr(:,4);                                     % [year doy year.dec snr]
        % Append to end of data columns
        l2.raw=[l2.raw; l2_raw];                                        % append to l2 snr data
    end
    
    %% Find dates missing S2 data
    if(nr>0)                                                    % data exist
        [diff_days,inds] = setdiff(days, l2_raw_yr(:,1),'rows');        % find missing days
        if(~isempty(inds))
            yrs= year*ones(length(inds),1);
            ydec=ydoy2ydec([yrs,diff_days]);                            % year.dec
            l2.missing = [l2.missing; yrs diff_days ydec];              % append [year doy year.dec] for each missing day
        end
    else                                                        % all data are missing for this year
        yrs= year*ones(length(days),1);
        ydec=ydoy2ydec([yrs,days]);                                     % year.dec
        l2.missing = [l2.missing; yrs days ydec];                       % append [year doy year.dec] for entire year
    end
    
end

%% Add Data to sites_list
l2.data=l2.raw;
sites_list(site_ind).snr{2}=l2;

